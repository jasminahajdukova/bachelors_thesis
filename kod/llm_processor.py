import ollama
import logging, colorlog, json
from decimal import Decimal

handler = colorlog.StreamHandler()
handler.setFormatter(colorlog.ColoredFormatter(
	'%(asctime)s %(log_color)s %(levelname)s: %(name)s:%(message)s',
    datefmt='%Y-%m-%d %H:%M:%S'))

logging.getLogger("mysql.connector").setLevel(logging.WARNING)
logging.getLogger("psycopg2").setLevel(logging.WARNING)

logger = logging.getLogger("LLM_PROCESSOR")
logger.addHandler(handler)
logger.setLevel(logging.DEBUG)
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
    print(f"QUERY MESSAGE = {response.message.content}")
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
    
    Return ONLY the schema section starting with 'schema:', nothing else.
    """
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
    logger.debug(f"Generated YAML schemas: {response.message.content}")
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


def generate_yaml(samples, sql_server_type):
    types_content = generate_yaml_types(samples, sql_server_type)
    schema_content = generate_yaml_schema(types_content, sql_server_type)
    generate_content = generate_yaml_generate(types_content, sql_server_type)
    full_yaml = (
        f"include: []\n\n"
        f"{types_content}\n\n"
        f"{schema_content}\n\n"
        f"{generate_content}\n\n"
        f"constraints: []"
    )
    return full_yaml