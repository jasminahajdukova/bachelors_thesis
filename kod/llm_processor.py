import re
import ollama
import httpx
import prompts
import logger_setup

AVAILABLE_INCLUDES = [
    "psc_cs",               # postal codes of cities in Czech Republic
    "first_names_cs",       # first names that are used in Czech Republic
    "cities_cs",            # names of cities in Czech Republic
    "animals_blocks_en",     # some animal kinds in English language
    "last_names_cs",        # last names that are used in Czech Republic
    "colors_blocks_en",      # basic color names in English language
    "countries_cs"          # names of counties (in Czech language)
]

client = ollama.Client(timeout=600.0)

def get_response(type_name: str, prompt: str, model: str, thinking: bool = False):
    

    try: 
        response = client.generate(model=model,
                           prompt=prompt,
                           think=thinking,
                            options={ "num_predict": 4096})
        
    except (httpx.TimeoutException, httpx.ReadTimeout) as exc:
        logger_setup.logger.error(f"Ollama timed out after 600s during {type_name} generation {exc}") 
        raise RuntimeError(f"{type_name} generation timed out {exc}")
    except ollama.ResponseError as exc:
        logger_setup.logger.error(f"Ollama model error: {exc}")
        raise RuntimeError(f"{type_name} was not generated: {exc}") from exc
    except httpx.ConnectError as exc:
        logger_setup.logger.error(f"Ollama is not running: {exc}")
        raise RuntimeError(f"Ollama is not running: {exc}") from exc
    return response

def generate_sql_query(template, db_name, table_name):
    query = template.format(db_name=db_name, table_name=table_name)
    return query


def strip_markdown(content: str) -> str:

    if not content:
        return ""

    content = content.strip()

    if content.startswith("```"):

        first_newline = content.find("\n")
        if first_newline != -1:
            content = content[first_newline + 1:]
        else:
            content = content[3:]
    if content.endswith("```"):
        content = content[:-3]
    return content.strip()


def generate_yaml_prompt(samples, types_section, sql_server_type, model, section):

    logger_setup.logger.info(f"Generating YAML '{section}' section")
    if section == "schema":
        prompt = prompts.build_schema_prompt(types_section, sql_server_type)

    elif section == "types":
        prompt = prompts.build_types_prompt(samples, sql_server_type)
    
    elif section == "generate":
        prompt = prompts.build_generate_prompt(types_section, sql_server_type)
    
    elif section == "constraints":
        prompt = prompts.build_constraints_prompt(types_section, sql_server_type)

    else: 
        raise ValueError(f"Uknown section: {section}")

    response = get_response(f"YAML {section}", prompt, model)
    generated_yaml = strip_markdown(response.response)

    return generated_yaml



def generate_yaml_include(type_content):
    if not type_content:
        return "include: []"
    
    cl_content = type_content
    for char in [":", "[", "]", "(", ")", ",", "-", "\n", "\r"]:
        cl_content = cl_content.replace(char, " ")
    
    words_in_content = set(cl_content.split())

    includes = []
    for dataset in AVAILABLE_INCLUDES:
    
        if dataset in words_in_content:
            includes.append(dataset)

    if includes:
        items = "\n".join([f"  - {d}" for d in includes])
        return f"include:\n{items}"
    else:
        return "include: []"
    

def filter_constraints(constraints_yaml) :
    if not constraints_yaml:
        return "constraints: []"
    
    lines = constraints_yaml.split('\n')
    filtered = []
    
    invalid_operators = ['~', '=~', '!~', 'match', 'regex', 'is not NULL', 'IS NOT NULL', 'is null', 'IS NULL']

    for line in lines:
        if line is None:
            continue
        
        stripped_line = line.split()
        if not stripped_line or line.strip().endswith(":"):
            filtered.append(line)
            continue

        if  len(stripped_line) < 3:
            logger_setup.logger.warning(f"Removing LLM output {line.strip()}")
            continue
        
        if len(stripped_line) == 4 and stripped_line[0].strip("'\"") == stripped_line[3].strip("'\""):
            logger_setup.logger.warning(f"Removing self-referencing constraint: {line.strip()}")
            continue

        if any(op in line for op in invalid_operators):
            logger_setup.logger.debug(f"Removing invalid constraint: {line.strip()}")
            continue

        operator = stripped_line[1].lower()
        right_side = " ".join(stripped_line[2:]).strip("'\"")

        if operator == 'in':
            in_match = bool(re.match(r"^\w+\.\w+$", stripped_line[0]) and right_side.startswith('(') and right_side.endswith(')'))

            if in_match:
                filtered.append(line)
                
            else:
                logger_setup.logger.warning(f"Removing invalid 'in' constraint {line.strip()}")
            
            continue

        is_numeric = bool(re.match(r'^[-+]?(?:\d+(?:\.\d*)?|\.\d+)$', right_side))
        is_col_ref = '.' in right_side and len(right_side.split('.')) == 2

        if not is_numeric and not is_col_ref:
            logger_setup.logger.warning(f"Removing invalid constraint: {line.strip()}")
            continue

        filtered.append(line)
    result = '\n'.join(filtered)

    if result.strip() == 'constraints:':
        return 'constraints: []'
    return result


def apply_fk_to_schema(schema_yaml: str, fk_map: dict) -> str:
    logger_setup.logger.debug(f"schema_yaml repr:\n{repr(schema_yaml)}")
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
        

        if current_table and indent_count == 4 and ':' in stripped:
            col_name = stripped.split(':')[0].strip()

            if current_table in fk_map and col_name in fk_map[current_table]:

                ref_table, ref_col = fk_map[current_table][col_name]
                result.append(f"{' ' * indent_count}{col_name}: FROM {ref_table}.{ref_col}")
                continue

            if 'FROM' in stripped:
                value = stripped.split(":", 1)[1].strip()
                value = value.strip("'\"")
                value = value.replace("FROM ", "").strip()
                value_split = value.split(".")

                if len(value_split) == 2:
                    ref_table, ref_col = value_split[0], value_split[1]

                    if current_table.lower() == ref_table.lower():
                        result.append(f"{' ' * indent_count}{col_name}: {current_table}.{col_name}")
                        continue
                
                else:
                    logger_setup.logger.warning(f"Form of from is wrong: {stripped}")
                    result.append(line)
                    continue

        result.append(line)
        
    
    return '\n'.join(result)


def sort_tables_multi_level(fk_map):
    remaining_tables = list(fk_map.keys())
    sorted_tables = []  
    while remaining_tables:
        made_progress = False
        for table in list(remaining_tables):
            fk_details = fk_map[table]
            parent_tables = [
                parent_table for parent_table, _ in fk_details.values() if parent_table is not None 
                and parent_table != table
            ]
            if all(parent in sorted_tables for parent in parent_tables):
                sorted_tables.append(table)
                remaining_tables.remove(table)
                made_progress = (
                    True  
                )

        if not made_progress:
            raise ValueError("Cyclic dependency or missing parent table detected")
        
    return sorted_tables

def go_over_generate(gen_count, generate_content):
    logger_setup.logger.debug(f"GEN COUNT = {gen_count}")
    generate_content = generate_content.split("\n")

    new_generate = []
    for line in generate_content:
        if line == "generate:" or not line.strip() or line == "":
            new_generate.append(line)
            continue
        line_split = line.split("=")
        try:
            line_split[0] = line_split[0].replace("-", "").replace(" ", "").replace("'", "")
            line_split[1] = int(line_split[1].replace("'", "").replace(" ",""))
        except (ValueError, IndexError):
            logger_setup.logger.error("cannot convert to number")
            new_generate.append(line)
            continue
        if line_split[0] not in gen_count:
            new_generate.append(line)
            continue
        if gen_count[line_split[0]] != line_split[1]:
            new_generate.append(f"- '{line_split[0]} = {gen_count[line_split[0]]}'")
        else:
            new_generate.append(line)

    
    final_generate = "\n".join(new_generate)
    return final_generate
    
def fix_regex_quoting(types_yaml):
    re_pattern = r"regex\([\\'](.*?)[\\']\)"

    results = []

    lines = types_yaml.splitlines()

    for line in lines:
        if "regex(" not in line:
            results.append(line)
            continue
        
        re_match = re.search(re_pattern, line)
        if re_match:
            inner = re_match.group(1)

            inner = inner.replace("\\'", "'")
            inner = inner.replace("'", "''")

            fixed_line = re.sub(re_pattern, f"regex(''{inner}'')", line)
            results.append(fixed_line)
        else:
            results.append(line)

    return "\n".join(results)

def go_over_schema(schemas, samples):
    current_table = ""
    new_schema = []
    schemas = schemas.split("\n")

    for line in schemas:
        

        if line == "schema:" or not line.strip():
            new_schema.append(line)
            continue
        line_split = line.strip().split(" ")

        table_name = line_split[0].strip(":")
        if len(line_split) == 1:
            if table_name in samples:
                current_table = table_name
                new_schema.append(line)
                continue
            else:
                logger_setup.logger.warning(f"{table_name} is not part of {samples.keys()}")
                continue
       
        schema_name = line_split[0].strip(":")
        if not current_table:
            continue
        
        if schema_name not in samples[current_table]:
            logger_setup.logger.warning(f"This schema_name does not belong = {schema_name}")
            continue

        new_schema.append(line)

    new_schema = '\n'.join(new_schema)
    return new_schema

def generate_yaml(samples, sql_server_type, fk_map, gen_count):
    sorted_table_names = sort_tables_multi_level(fk_map)
    sorted_samples = {table: samples[table] for table in sorted_table_names if table in samples}
    
    types_content = generate_yaml_prompt(sorted_samples, None, sql_server_type, "yaml-generator-types", "types")
    types_content = fix_regex_quoting(types_content)
    
    include_content = generate_yaml_include(types_content)

    schema_content      = generate_yaml_prompt(None, types_content, sql_server_type, "yaml-generator-schema", "schema")
    generate_content    = generate_yaml_prompt(None, types_content, sql_server_type, "yaml-generator-generate", "generate")
    constraints_content = generate_yaml_prompt(None, types_content, sql_server_type, "yaml-generator-constraints", "constraints")
    
    schema_content      = apply_fk_to_schema(schema_content, fk_map)
    schema_content      = go_over_schema(schema_content, samples)
    generate_content    = go_over_generate(gen_count, generate_content)
    constraints_content = filter_constraints(constraints_content)
    
    
    full_yaml = (
        f"{include_content}\n\n"
        f"{types_content}\n\n"
        f"{schema_content}\n\n"
        f"{generate_content}\n\n"
        f"{constraints_content}"
    )

    return full_yaml
