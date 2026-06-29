import logging
import colorlog
import json
import json
import datetime
from decimal import Decimal

handler = colorlog.StreamHandler()
handler.setFormatter(colorlog.ColoredFormatter(
	'%(asctime)s %(log_color)s %(message)s',
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
    
    if isinstance(dec, datetime.timedelta):
        return str(dec)
    
    raise TypeError(f"Object of type {type(dec)} is not JSON serializable")




def build_types_prompt(samples, sql_server_type):
    json_data = json.dumps(samples, default=json_decimal)
    prompt = f"""Generate ONLY the 'types:' section for a Dataster YAML from a {sql_server_type} database.
    
    The database samples are provided as a JSON structure where each table contains its columns.
    
    Data structure rules for columns:
    - If a column is a PRIMARY KEY, it is an object with: {{"is_pk": true, "data_type": "numeric"|"non-numeric", "seq": "seq(MIN,MAX,1)"}} or {{"samples": [...]}}
      For numeric primary keys, ALWAYS use the provided 'seq' value directly as the Dataster type.
    - If a column is NOT a primary key, it is an object with: {{"is_pk": false, "distinct_count_in_sample": N, "samples": [value1, value2, ...]}}
      Use the 'samples' array and 'distinct_count_in_sample' to infer the correct Dataster type (e.g., str_len, interval, dataset, regex, etc.).
      
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



def build_constraints_prompt(types_section, sql_server_type):
    prompt = f"""Generate ONLY the 'constraints:' section for a Dataster YAML from a {sql_server_type} database.

    Here are the generated types:
    {types_section}

    Return ONLY the constraints section starting with 'constraints:', or an empty list 'constraints: []' if no meaningful constraints can be inferred.
    """
    
    logger.debug(f"Inside build constraints prompt \nPROMP = {prompt}\n")
    return prompt