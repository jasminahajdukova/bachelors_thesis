import re

import ollama
import httpx
import logging
import colorlog
import prompts

from concurrent.futures import ThreadPoolExecutor

handler = colorlog.StreamHandler()
handler.setFormatter(colorlog.ColoredFormatter(
	'%(asctime)s %(log_color)s %(levelname)s: %(name)s:%(message)s',
    datefmt='%Y-%m-%d %H:%M:%S'))

logging.getLogger("mysql.connector").setLevel(logging.WARNING)
logging.getLogger("psycopg2").setLevel(logging.WARNING)

logger = logging.getLogger("LLM_PROCESSOR")
logger.addHandler(handler)
logger.setLevel(logging.INFO)
logger.propagate = False




AVAILABLE_INCLUDES = [
    "psc_cs",               # postal codes of cities in Czech Republic
    "first_names_cs",       # first names that are used in Czech Republic
    "cities_cs",            # names of cities in Czech Republic
    "animals_blocks_en",     # some animal kinds in English language
    "last_names_cs",        # last names that are used in Czech Republic
    "colors_blocks_en",      # basic color names in English language
    "countries_cs"          # names of counties (in Czech language)
]


def get_response(type: str, prompt: str, model: str, thinking: bool = False):
    try: 
        response = ollama.generate(model=model,
                           prompt=prompt,
                           think=thinking)
    except ollama.ResponseError as exc:
        logger.error(f"Ollama model error: {exc}")
        raise RuntimeError(f"{type} was not generated: {exc}") from exc
    except httpx.ConnectError as exc:
        logger.error(f"Ollama is not running: {exc}")
        raise RuntimeError(f"Ollama is not running: {exc}") from exc
    return response

# pridaj rozsirenie dalsich llm
def generate_sql_query(template: str, sql_server_type: str, db_name: str, table_name: str | None, model: str = "yaml-generator-sql"):
    logger.info(f"Generating SQL query for {sql_server_type}")
    prompt = f"""Generate a valid {sql_server_type} SQL query based on this template.
            Database name = {db_name}
            Database server = {sql_server_type}
            Table name = {table_name}

            Template:
            {template}

            SQL query:"""
    logger.debug(f"Generate SQL query prompt = {prompt}")
    response = get_response("SQL query", prompt, model)
    logger.debug(f"Generated SQL query: {response.response}")
    return response.response



def strip_markdown(content: str) -> str:
    content = content.strip()
    if content.startswith("```"):
        content = content.split("\n", 1)[1]
    if content.endswith("```"):
        content = content.rsplit("```", 1)[0]
    return content.strip()


def generate_yaml_prompt(samples, types_section, sql_server_type, model, section):
    build_prompt = {
        "schema": prompts.build_schema_prompt(types_section, sql_server_type),
        "types": prompts.build_types_prompt(samples, sql_server_type),
        "generate": prompts.build_generate_prompt(types_section, sql_server_type),
        "constraints": prompts.build_contraints_prompt(types_section, samples, sql_server_type)
    }
    logger.info(f"Generating YAML '{section}' section")
    if section in build_prompt:
        prompt = build_prompt[section]

    response = get_response(f"YAML {section}", prompt, model)
    generated_yaml = strip_markdown(response.response)
    return generated_yaml


def generate_yaml_include(type_content):
    includes = []
    for dataset in AVAILABLE_INCLUDES:
        if dataset in type_content:
            includes.append(dataset)

    if includes:
        items = "\n".join([f"  - {d}" for d in includes])
        return f"include:\n{items}"
    else:
        return "include: []"
    

def filter_constraints(constraints_yaml) :
    lines = constraints_yaml.split('\n')
    filtered = []
    invalid_operators = ['~', '=~', '!~', 'match', 'regex', 'is not NULL', 'IS NOT NULL', 'is null', 'IS NULL']
    logger.info("------------------------------------------------------------------------------------------------------------------------------")
    for line in lines:
        if line is None:
            continue
        logger.info(f"Line = {line.split()}")
        if (stripped_line := line.split()) and len(stripped_line) == 4 and stripped_line[1].strip("'") == stripped_line[3].strip("'"):
            logger.info(f"Removing self-referencing contraint: {line.strip()}")
            continue
        if any(op in line for op in invalid_operators):
            logger.debug(f"Removing invalid constraint: {line.strip()}")
            continue
        right_side = " ".join(stripped_line[3:])
        right_side = right_side.strip("'\"")

        if len(stripped_line) >= 4 and stripped_line[1].lower() == 'in':
            in_match = re.match(r"^\w+\.\w+$", stripped_line[0]) and right_side.strip().startswith('(') and right_side.strip().endswith(')')

            if in_match:
                filtered.append(line)
                continue
            else:
                logger.info(f"Removing invalid 'in' constraint {line.strip()}")

        if not re.match(r'[-+]?(?:\d+(?:\.\d*)?|\.\d+)', right_side) and '.' not in right_side and len(stripped_line) >= 4:
            logger.info(f"Removing invalid constraint: {line.strip()}")
            continue
        filtered.append(line)
    result = '\n'.join(filtered)
    logger.info("-------------------------------------------------------------------------------------------------------------------------------")
    if result.strip() == 'constraints:':
        return 'constraints: []'
    return result


def apply_fk_to_schema(schema_yaml: str, fk_map: dict) -> str:
    logger.info(f"apply_fk_to_schema called with fk_map: {fk_map}")
    logger.info(f"schema_yaml repr:\n{repr(schema_yaml)}")
    lines = schema_yaml.split('\n')
    result = []
    current_table = None
    
    for line in lines:
        stripped = line.strip()
        

        if stripped == 'schema:':
            result.append(line)
            continue

        indent_count = len(line) - len(line.lstrip())
        if stripped.endswith(':') and indent_count == 2 and not stripped.startswith('-'):
            current_table = stripped[:-1]
            result.append(line)
            continue
        

        if current_table and ':' in stripped and indent_count == 4:
            col_name = stripped.split(':')[0].strip()
            if current_table in fk_map and col_name in fk_map[current_table]:
                ref_table, ref_col = fk_map[current_table][col_name]
                result.append(f"{' ' * indent_count}{col_name}: FROM {ref_table}.{ref_col}")
                continue
    
        result.append(line)
        
    
    return '\n'.join(result)


def sort_tables_multi_level(fk_map):
    logger.info(f"FK_MAP = {fk_map}")
    remaining_tables = list(fk_map.keys())
    sorted_tables = []  
    while remaining_tables:
        made_progress = False
        for table in list(remaining_tables):
            fk_details = fk_map[table]
            parent_tables = [
                parent_table for parent_table, _ in fk_details.values() if parent_table is not None
            ]
            if all(parent in sorted_tables for parent in parent_tables):
                sorted_tables.append(table)
                remaining_tables.remove(table)
                made_progress = (
                    True  
                )

        if not made_progress:
            raise ValueError(
                "Detekovaná cyklická závislosť alebo chýbajúca materská tabuľka!"
            )
    logger.info(f"Sorted tables = {sorted_tables}")
    return sorted_tables

def go_over_generate(gen_count, generate_content):
    logger.info(f"GEN COUNT = {gen_count}")
    logger.info(f"generate_content = {generate_content}")
    generate_content = generate_content.split("\n")
    logger.info(f"generate_content after split = {generate_content}")

    new_generate = []
    for line in generate_content:
        logger.info(f"Line before split ={line}")
        if line == "generate:" or not line.strip():
            new_generate.append(line)
            continue
        line_split = line.split("=")
        logger.info(f"line_split = {line_split}")
        try:
            line_split[0] = line_split[0].replace("-", "").replace(" ", "").replace("'", "")
            line_split[1] = int(line_split[1].replace("'", "").replace(" ",""))
        except (ValueError, IndexError):
            logger.error("cannot convert to number")
            new_generate.append(line)
            continue
        logger.info(f"line_split[1] = {line_split[1]}, gen_copunt = {gen_count}")
        if line_split[0] not in gen_count:
            new_generate.append(line)
            continue
        if gen_count[line_split[0]] != line_split[1]:
            new_generate.append(f"- '{line_split[0]} = {gen_count[line_split[0]]}'")
        else:
            new_generate.append(line)
        logger.info(f"line_split[1] = {line_split[1]}")
    
    final_generate = "\n".join(new_generate)
    logger.info(f"final_generate = {final_generate}")
    return final_generate
    
def generate_yaml(samples, sql_server_type, fk_map, generate_count):
    sorted_table_names = sort_tables_multi_level(fk_map)
    sorted_samples = {table: samples[table] for table in sorted_table_names if table in samples}
    types_content = generate_yaml_prompt(sorted_samples, None, sql_server_type, "yaml-generator-types", "types")
    
    logger.info(f"types content:\n{types_content}")
    include_content = generate_yaml_include(types_content)

    with ThreadPoolExecutor() as executor:
        f_schema      = executor.submit(generate_yaml_prompt, None, types_content, sql_server_type, "yaml-generator-schema", "schema")
        f_generate    = executor.submit(generate_yaml_prompt, None, types_content, sql_server_type, "yaml-generator-generate", "generate")
        f_constraints = executor.submit(generate_yaml_prompt, samples, types_content, sql_server_type, "yaml-generator-constraints", "constraints")
    
    schema_content      = f_schema.result()
    schema_content      = apply_fk_to_schema(schema_content, fk_map)
    generate_content    = go_over_generate(generate_count, f_generate.result())
    constraints_content = f_constraints.result()
    constraints_content = filter_constraints(constraints_content)
    
    
    full_yaml = (
        f"{include_content}\n\n"
        f"{types_content}\n\n"
        f"{schema_content}\n\n"
        f"{generate_content}\n\n"
        f"{constraints_content}"
    )

    logger.info(f"Original YAML = {full_yaml}\n")
    return full_yaml
