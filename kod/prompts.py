import logging
import colorlog
import json
import json
import datetime
from decimal import Decimal

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



def json_decimal(dec):
    if isinstance(dec, Decimal):
        return float(dec)
    if isinstance(dec, (datetime.date, datetime.datetime)):
        return dec.isoformat()
    raise TypeError(f"Object of type {type(dec)} is not JSON serializable")




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