import ollama
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
        return str(dec)
    if isinstance(dec, datetime.date):
        return f"{dec.year}-{dec.month}-{dec.day}"
    return None

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



# pridaj rozsirenie dalsich llm
def generate_sql_query(template: str, sql_server_type: str, db_name: str,model: str = "yaml-generator-sql"):
    logger.info(f"Generating SQL query for {sql_server_type}")
    prompt = f"""Generate a valid {sql_server_type} SQL query based on this template for database: {db_name}.

            Template:
            {template}

            SQL query:"""
    
    response = ollama.chat(model=model,
                           messages=[
                               {'role': 'user', 'content': prompt}
                           ])
    logger.debug(f"Generated SQL query: {response.message.content}")
    return response.message.content


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

    response = ollama.chat(
        model="yaml-generator-generate",
        messages=([
                               {'role': 'user', 'content': prompt}
                           ])
    )
    logger.debug(f"Generated YAML generate: {response.message.content}")
    generated_yaml = strip_markdown(response.message.content)
    return generated_yaml


def generate_yaml_schema(types_section, sql_server_type):
    logger.info("Generating YAML 'schema' section")
    prompt = build_schema_prompt(types_section, sql_server_type)

    response = ollama.chat(
        model="yaml-generator-schema",
        messages=([
                               {'role': 'user', 'content': prompt}
                           ])
    )
    logger.debug(f"Generated YAML schemas: {response.message.content}")
    generated_yaml = strip_markdown(response.message.content)
    return generated_yaml


def generate_yaml_types(samples, sql_server_type):
    logger.info("Generating YAML 'types' section")
    prompt = build_types_prompt(samples,sql_server_type)

    response = ollama.chat(
        model="yaml-generator-types",
        messages=([
                               {'role': 'user', 'content': prompt}
                           ])
    )
    logger.debug(f"Generated YAML types: {response.message.content}")
    generated_yaml = strip_markdown(response.message.content)
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

    response = ollama.chat(
        model="yaml-generator-constraints",
        messages=([
                               {'role': 'user', 'content': prompt}
                           ])
    )
    logger.debug(f"Generated YAML constraints: {response.message.content}")
    generated_yaml = strip_markdown(response.message.content)
    return generated_yaml


def generate_yaml_fix(full_yaml):
    logger.info("Generating YAML fix")
    prompt = f"""Fix this Dataster YAML. Return ONLY the corrected YAML:

    {full_yaml}
    """
    response = ollama.chat(
        model="yaml-generator-fix",
        messages=([
                    {'role': 'user', 'content': prompt}
                ])
    )
    logger.debug(f"Generated YAML fix: {response.message.content}")
    generated_yaml = strip_markdown(response.message.content)
    return generated_yaml



def generate_yaml(samples, sql_server_type, skip_fix=False):
    types_content = generate_yaml_types(samples, sql_server_type)
    include_content = generate_yaml_include(types_content)

    with ThreadPoolExecutor() as executor:
        f_schema      = executor.submit(generate_yaml_schema, types_content, sql_server_type)
        f_generate    = executor.submit(generate_yaml_generate, types_content, sql_server_type)
        f_constraints = executor.submit(generate_yaml_constraints, types_content, samples, sql_server_type)
    
    schema_content      = f_schema.result()
    generate_content    = f_generate.result()
    constraints_content = f_constraints.result()
    
    
    full_yaml = (
        f"{include_content}\n\n"
        f"{types_content}\n\n"
        f"{schema_content}\n\n"
        f"{generate_content}\n\n"
        f"{constraints_content}"
    )
    if skip_fix:
        logger.info("Skipping YAML fix")
        return full_yaml
    logger.info(f"Sending yaml to fix. Original YAML = {full_yaml}\n")
    fixed_yaml = generate_yaml_fix(full_yaml)
    return fixed_yaml