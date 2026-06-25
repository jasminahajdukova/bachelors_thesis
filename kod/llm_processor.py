import re

import ollama, httpx
import logging, colorlog, json, datetime
from decimal import Decimal
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


def json_decimal(dec):
    if isinstance(dec, Decimal):
        return float(dec)
    if isinstance(dec, datetime.date):
        return f"{dec.year}-{dec.month}-{dec.day}"
    raise TypeError(f"Object of type {type(dec)} is not JSON serializable")

# def build_yaml_prompt(samples, sql_server_type):
#     json_data = json.dumps(samples, default=json_decimal)
#     prompt = f"""Generate a YAML file ONLY for these exacts tables and columns from a {sql_server_type} database.
#         Do NOT copy examples. Generate based ONLY on this data.
#         Each sample shows values in format:
#             - for non primary key column: [value, MIN, MAX, COUNT_DISTINCT] - use sample values to infer the correct Dataster type
#             - for primary key column: {{'is_pk': true, 'seq': 'seq(MIN,MAX,1)'}} - use the seq value directly as the type, e.g. id: 'seq(1,5,1)'
#         Database samples:
#         {json_data}

#         Generate the YAML. Return ONLY the raw content, nothing else:
#     """
#     logger.debug(f"Prompt: {prompt}")
#     return prompt

def check_ollama(type: str, prompt: str, model: str, thinking: bool = False):
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
    logger.info(f"Generate SQL query prompt = {prompt}")
    response = check_ollama("SQL query", prompt, model)
    logger.info(f"Generated SQL query: {response.response}")
    return response.response


def build_types_prompt(samples, sql_server_type):
    json_data = json.dumps(samples, default=json_decimal)
    prompt = f"""Generate ONLY the 'types:' section for a Dataster YAML from a {sql_server_type} database.
    Each sample shows values in format:
        - for non primary key column: [value, MIN, MAX, COUNT_DISTINCT] - use sample values to infer the correct Dataster type
        - for primary key column: {{'is_pk': true, 'seq': 'seq(MIN,MAX,1)'}} - use the seq value directly as the type
      
    Database samples:
    {json_data}
    
    Return ONLY the types section starting with 'types:', nothing else.
    """
    logger.debug(f"Inside build types prompt \nPROMP = {prompt}\n")
    return prompt


def build_schema_prompt(types_section: str, sql_server_type: str):
    prompt = f"""Generate ONLY the 'schema:' section for a Dataster YAML from a {sql_server_type} database.
    
    Here are the generated types:
    {types_section}
    
    Rules:
    - Every column must reference a type as 'typename.attribute'
    - Schema table names must match exactly the type names
    - Foreign keys use FROM syntax: 'FROM tablename.column'
    - NEVER put data types directly in schema
    
    Example: if types has 'users: id: seq(1,5,1)' then schema must have 'id: users.id'
    
    Return ONLY the schema section starting with 'schema:', nothing else.
    """
    logger.debug(f"Inside build schema prompt \nPROMP = {prompt}\n")
    return prompt


def build_generate_prompt(types_section, sql_server_type):
    prompt = f"""Generate ONLY the 'generate:' section for a Dataster YAML from a {sql_server_type} database.
    
    Here are the generated types:
    {types_section}
    
    Rules:
    - Identify all root table types defined in the types section.
    - Generate records for each table type using the exact format: 'typename = count' (e.g., users = 1000) under the 'generate:' key.
    - If you cannot deduce the exact count from the types, use a reasonable default (e.g., 1000 for main tables, 100 for dictionary/lookup tables).
    
    Return ONLY the generate section starting with 'generate:', nothing else.
    """
    logger.debug(f"Inside build generate prompt \nPROMP = {prompt}\n")
    return prompt


def build_contraints_prompt(types_section, samples, sql_server_type):
    json_data = json.dumps(samples, default=json_decimal)
    prompt = f"""Generate ONLY the 'constraints:' section for a Dataster YAML from a {sql_server_type} database.

    Here are the generated types:
    {types_section}

    Here are real data samples from the database:
    {json_data}

    Generate realistic constraints based on column names and sample values. 
    Rules: 
    - date relationships: from_date < to_date, hire_date <= from_date 
    - numeric: salary > 0, age >= 18, price > 0 
    - foreign keys usually don't need explicit constraints 

    Return format: 
        constraints: 
            - 'employee.hire_date < employee.from_date' 
            - 'salary.salary > 0' 

    Return ONLY the constraints section or empty list if no meaningful constraints can be inferred. 
    """
    logger.debug(f"Inside build constraints prompt \nPROMP = {prompt}\n")
    return prompt

def strip_markdown(content: str) -> str:
    content = content.strip()
    if content.startswith("```"):
        content = content.split("\n", 1)[1]
    if content.endswith("```"):
        content = content.rsplit("```", 1)[0]
    return content.strip()

def generate_yaml_generate(types_section, sql_server_type):
    logger.info("Generating YAML 'generate' section")
    prompt = build_generate_prompt(types_section, sql_server_type)

    response = check_ollama("YAML", prompt, "yaml-generator-generate")
    logger.debug(f"Generated YAML generate: {response.response}")
    generated_yaml = strip_markdown(response.response)
    return generated_yaml


def generate_yaml_schema(types_section, sql_server_type):
    logger.info("Generating YAML 'schema' section")
    prompt = build_schema_prompt(types_section, sql_server_type)

    response = check_ollama("YAML schema", prompt, "yaml-generator-schema")
    logger.debug(f"Generated YAML schemas: {response.response}")
    generated_yaml = strip_markdown(response.response)
    return generated_yaml


def generate_yaml_types(samples, sql_server_type):
    logger.info("Generating YAML 'types' section")
    prompt = build_types_prompt(samples,sql_server_type)
    logger.info(f"PROMPT=\n{prompt}")
 
    response = check_ollama("YAML types", prompt, "yaml-generator-types")    
    logger.info(f"Generated YAML types: {response.response}")
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
    
def generate_yaml_constraints(types_content, samples, sql_server_type):
    logger.info("Generating YAML 'constraints' section")
    prompt = build_contraints_prompt(types_content, samples, sql_server_type)

    response = check_ollama("YAML constraint", prompt, "yaml-generator-constraints")   
    logger.debug(f"Generated YAML constraints: {response.response}")
    generated_yaml = strip_markdown(response.response)
    return generated_yaml


def generate_yaml_fix(full_yaml):
    logger.info("Generating YAML fix")
    prompt = f"""Fix this Dataster YAML. Return ONLY the corrected YAML:

    {full_yaml}
    """
    response = check_ollama("YAML fix", prompt, "yaml-generator-fix")
    logger.debug(f"Generated YAML fix: {response.response}")
    generated_yaml = strip_markdown(response.response)
    return generated_yaml


def filter_constraints(constraints_yaml) :
    lines = constraints_yaml.split('\n')
    filtered = []
    # in the future check in/IN
    invalid_operators = ['~', '=~', '!~', 'match', 'regex', 'is not NULL', 'IS NOT NULL', 'is null', 'IS NULL']
    logger.info("------------------------------------------------------------------------------------------------------------------------------")
    for line in lines:
        logger.info(f"Line = {line.split()}")
        if (stripped_line := line.split()) and len(stripped_line) == 4 and stripped_line[1].strip("'") == stripped_line[3].strip("'"):
            logger.info(f"Removing self-referencing contraint: {line.strip()}")
            continue
        if any(op in line for op in invalid_operators):
            logger.debug(f"Removing invalid constraint: {line.strip()}")
            continue
        right_side = " ".join(stripped_line[3:])
        right_side = right_side.strip("'\"")
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
        except ValueError:
            logger.error("cannot convert to number")
            new_generate.append(line)
            continue
        logger.info(f"line_split[1] = {line_split[1]}, gen_copunt = {gen_count}")
        if line_split[0] not in gen_count:
            new_generate.append(line)
            continue
        if gen_count[line_split[0]] != line_split[1]:
            new_generate.append(f" - '{line_split[0]} = {gen_count[line_split[0]]}'")
        else:
            new_generate.append(line)
        logger.info(f"line_split[1] = {line_split[1]}")
    
    final_generate = "\n".join(new_generate)
    logger.info(f"final_generate = {final_generate}")
    return final_generate
    
def generate_yaml(samples, sql_server_type, fk_map, generate_count, skip_fix=False):
    sorted_table_names = sort_tables_multi_level(fk_map)
    sorted_samples = {table: samples[table] for table in sorted_table_names if table in samples}
    types_content = generate_yaml_types(sorted_samples, sql_server_type)
    
    logger.info(f"types content:\n{types_content}")
    include_content = generate_yaml_include(types_content)

    with ThreadPoolExecutor() as executor:
        f_schema      = executor.submit(generate_yaml_schema, types_content, sql_server_type)
        f_generate    = executor.submit(generate_yaml_generate, types_content, sql_server_type)
        f_constraints = executor.submit(generate_yaml_constraints, types_content, sorted_samples, sql_server_type)
    
    schema_content      = f_schema.result()
    schema_content      = apply_fk_to_schema(schema_content, fk_map)
    generate_content = go_over_generate(generate_count, f_generate.result())
    constraints_content = f_constraints.result()
    constraints_content = filter_constraints(constraints_content)
    
    
    full_yaml = (
        f"{include_content}\n\n"
        f"{types_content}\n\n"
        f"{schema_content}\n\n"
        f"{generate_content}\n\n"
        f"{constraints_content}"
    )
    if skip_fix:
        logger.info(f"Skipping YAML fix. Original YAML = {full_yaml}\n")
        return full_yaml
    logger.info(f"Sending yaml to fix. Original YAML = {full_yaml}\n")
    fixed_yaml = generate_yaml_fix(full_yaml)
    return fixed_yaml