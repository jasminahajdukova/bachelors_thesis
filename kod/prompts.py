import json
import datetime
from decimal import Decimal
import logger_setup


def json_decimal(dec):
    if dec is None:
        return None
    
    if isinstance(dec, Decimal):
        return float(dec)
    
    if isinstance(dec, datetime.datetime):
        return dec.isoformat(sep=" ")
    
    if isinstance(dec, datetime.date):
        return dec.isoformat()
    
    if isinstance(dec, datetime.timedelta):
        total_seconds = int(dec.total_seconds())
        hours = total_seconds // 3600
        minutes = (total_seconds % 3600) // 60
        seconds = total_seconds % 60
        return f"{hours:02d}:{minutes:02d}:{seconds:02d}"
    if isinstance(dec, (str, int, float)):
        return dec
    raise TypeError(f"Object of type {type(dec)} is not JSON serializable")


def build_types_prompt(samples, sql_server_type):
    json_data = json.dumps(samples, default=json_decimal)
    
    prompt = f"""Generate ONLY the 'types:' section for a Dataster YAML from a {sql_server_type} database.
    
    Database samples:
    {json_data}
    
    Return ONLY the types section starting with 'types:', nothing else. Do not wrap code in markdown block format.
    """
    logger_setup.logger.debug(f"Inside build types prompt \nPROMPT = {prompt}\n")
    return prompt


def build_schema_prompt(types_section, sql_server_type):
    prompt = f"""Generate ONLY the 'schema:' section for a Dataster YAML from a {sql_server_type} database.

    Here are the defined types:
    {types_section}

    CRITICAL SCHEMA RULES:
    1. Every table and column defined in the types section above MUST appear in the schema section.
    2. Format rules:
       - For standard columns, assign the table name and column name: column_name: table_name.column_name
       - For columns that represent relations (foreign keys), specify source table and column: column_name: FROM parent_table.parent_column
    3. Return ONLY valid YAML syntax. Do not invent tables or columns.

    VALID EXAMPLE:
    schema:
      users:
        id: users.id
        username: users.username
      orders:
        id: orders.id
        user_id: FROM users.id

    Return ONLY the schema section starting with 'schema:', nothing else. Do not wrap code in markdown block format.
    """
    logger_setup.logger.debug(f"Inside build schema prompt \nPROMPT = {prompt}\n")
    return prompt


def build_generate_prompt(types_section, sql_server_type):
    prompt = f"""Generate ONLY the 'generate:' section for a Dataster YAML from a {sql_server_type} database.

    Here are the defined types:
    {types_section}

    STRICT GENERATE RULES:
    1. Define production count for every table present in the types section.
    2. Format: '- table_name = COUNT' inside a list.
    3. Derivate the COUNT from the primary key's seq(MIN, MAX, STEP) if available, otherwise use a sensible default (e.g., 100).

    VALID EXAMPLE:
    generate:
      - 'users = 100'
      - 'orders = 250'

    Return ONLY the generate section starting with 'generate:', nothing else. Do not wrap code in markdown block format.
    """
    logger_setup.logger.debug(f"Inside build generate prompt \nPROMPT = {prompt}\n")
    return prompt


def build_constraints_prompt(types_section, sql_server_type):
    prompt = f"""Generate ONLY the 'constraints:' section for a Dataster YAML from a {sql_server_type} database.

    Here are the generated types:
    {types_section}

    STRICT CONSTRAINTS RULES:
    1. Only use valid column names and tables that exist in the types section above.
    2. Format each constraint on a new line as: 'table.column OPERATOR value' or 'table.column in (val1, val2, ...)'.
    3. ALLOWED OPERATORS: You are ONLY allowed to use these relational operators: =, !=, <, >, <=, >=, in.
    4. STRICTLY PROHIBITED: Do NOT generate constraints using 'LIKE', 'MATCH', '~', 'REGEX', 'IS NULL' or 'IS NOT NULL'.
    5. AVOID self-referencing constraints (e.g., 'users.age = users.age' is invalid).

    VALID EXAMPLE:
    constraints:
      - users.age >= 18
      - orders.status in ('pending', 'shipped', 'delivered')
      - products.price > 0.0

    Return ONLY the constraints section starting with 'constraints:', or an empty list 'constraints: []' if no logical constraints can be derived. Do not wrap code in markdown block format.
    """
    logger_setup.logger.debug(f"Inside build constraints prompt \nPROMPT = {prompt}\n")
    return prompt