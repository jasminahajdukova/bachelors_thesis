import json
import datetime
from decimal import Decimal
import logger_setup


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
    
    CRITICAL: CLOSED LIST OF ALLOWED DATASTER TYPES & CONSTRUCTS
    You are STRICTLY FORBIDDEN from using any types or syntax structures other than this list:
    - int: Basic integer.
    - bigint: Large integer.
    - float: Decimal numbers.
    - bool: Boolean values.
    - string: Plain text.
    - seq(MIN,MAX,STEP): Numeric sequence (use ONLY for numeric primary keys).
    - interval(MIN,MAX): Integer range (e.g., interval(18, 99)).
    - finterval(MIN,MAX): Float range (e.g., finterval(0.0, 1.0)).
    - dinterval(YYYY-MM-DD, YYYY-MM-DD): Date range (ALWAYS use padded YYYY-MM-DD format).
      Example: dinterval(2020-01-01, 2026-12-31)
    - str_len(MIN, MAX): Text with character length bounds (e.g., str_len(2, 50)). Do NOT include character categories like [cC].
    - regex('PATTERN'): Text matching a valid Python regular expression pattern.
      CRITICAL: The regex pattern MUST be enclosed in SINGLE QUOTES inside the parentheses. Example: regex('^[0-9]{3}$')
    
    ADVANCED ALLOWED STRUCTURES (Use for Enums, Configuration Blocks, Emails and Names):
    - BLOCKS / Enumerations: A YAML list of literal text values. Always use '- BLOCKS' as the first element.
    - format and values: Used for composite string pattern construction.
      Syntax:
        column_name:
          format: 'pattern_{{}}_with_{{}}'
          values:
            - reference_to_helper_column_or_built_in_dataset

    ALLOWED BUILT-IN DATASETS (Use ONLY inside 'values' list):
    - first_names_cs, last_names_cs, cities_cs, psc_cs, countries_cs, animals_blocks_en, colors_blocks_en

    CRITICAL GROUNDING RULES FOR COMPLEX FIELDS (EMAILS & NAMES):
    1. For Emails: NEVER invent domain names out of thin air. You MUST look at the input samples, extract the real domains (the part after @), create a hidden helper column using a BLOCKS list, and reference that helper column inside 'values'.
    2. For Emails: NEVER put raw string literals (like 'gmail.com') directly into the 'values' list. Every item in 'values' must be a valid reference or dataset.
    3. For Full Names: If a single column contains full names, implicitly inject separate 'first_name: first_names_cs' and 'last_name: last_names_cs' columns first.

    CONTRASTING EXAMPLES FOR EMAIL GENERATION:
    --------------------------------------------------
    CORRECT (Domains are grounded from samples and mapped via helper column):
      users:
        user_id: seq(1,10,1)
        username: str_len(5,15)
        _email_domains:
          - BLOCKS
          - uni.com
          - test.cz
        email:
          format: '{{}}@{{}}'
          values:
            - users.username
            - users._email_domains

    WRONG (CRASHES THE PIPELINE - Raw literals inside values are forbidden):
      email:
        format: '{{}}@{{}}'
        values:
          - users.username
          - 'uni.com'       <-- CRITICAL ERROR! Never put string literals here.
    --------------------------------------------------

    Data structure rules for columns:
    1. If a column is a PRIMARY KEY, it is an object with: {{"is_pk": true, "data_type": "numeric"|"non-numeric", "seq": "seq(MIN,MAX,1)"}} or {{"samples": [...]}}
       For numeric primary keys, ALWAYS use the provided 'seq' value directly as the Dataster type.
    2. If a column is NOT a primary key, it is an object with: {{"is_pk": false, "distinct_count_in_sample": N, "samples": [value1, value2, ...]}}
       Use the 'samples' array and 'distinct_count_in_sample' to infer the correct Dataster type from the allowed list above.
    
    FALLBACK / ALLOWANCE TO SAY "I DON'T KNOW":
    If the 'samples' array for a column is EMPTY, or if there is not enough context to reliably infer a specific format (like interval or date), DO NOT GUESS OR HALUCINATE. 
    Use 'string' as a safe, default fallback type for that column.
    
    STRICT SYNTAX RULES FOR PARAMETRIC TYPES (dinterval, regex):
    1. For 'dinterval' and 'regex', never wrap the internal arguments inside SINGLE QUOTES directly (e.g., dinterval(2023-01-01, 2024-01-01)).
    2. NEVER wrap the entire Dataster type definition in quotes in the YAML output. 
       Correct:  birth_date: dinterval(1990-01-01, 2000-01-01)
       Incorrect: birth_date: "dinterval('1990-01-01', '2000-01-01')"
       Incorrect: phone_number: 'regex("^[0-9]{3}$")'
    
    Database samples:
    {json_data}
    
    Return ONLY the types section starting with 'types:', nothing else. Do not wrap code in markdown block format.
    """
    return prompt


def build_schema_prompt(types_section: str, sql_server_type: str):
    prompt = f"""Generate ONLY the 'schema:' section for a Dataster YAML from a {sql_server_type} database.

    Here are the generated types:
    {types_section}
    
    Rules:
    - Every column must reference a type as 'typename.attribute'.
    - Schema table names must match exactly the type names.
    - Foreign keys MUST use the exact 'FROM tablename.column' syntax to point to the referenced primary key.
    - NEVER put data types directly in the schema section.
    
    MULTI-TABLE FEW-SHOT EXAMPLE:
    If types contains:
      types:
        users:
          id: seq(1,10,1)
          name: string
        orders:
          order_id: seq(1,50,1)
          user_id: int
    
    Then the schema section MUST look exactly like this:
    schema:
      users:
        id: users.id
        name: users.name
      orders:
        order_id: orders.order_id
        user_id: FROM users.id

    Return ONLY the schema section starting with 'schema:', nothing else. Do not wrap code in markdown block format.
    """
    logger_setup.logger.debug(f"Inside build schema prompt \nPROMP = {prompt}\n")
    return prompt


def build_generate_prompt(types_section, sql_server_type):
    prompt = f"""Generate ONLY the 'generate:' section for a Dataster YAML from a {sql_server_type} database.
    
    Here are the generated types:
    {types_section}
    
    Rules:
    - Identify all root table types defined in the types section.
    - Generate records for each table type using the exact format: 'typename = count' (e.g., users = 1000) under the 'generate:' key.
    - If you cannot deduce the exact count from the types, use a reasonable default (e.g., 1000 for main tables, 100 for dictionary/lookup tables).
    
    Return ONLY the generate section starting with 'generate:', nothing else. Do not wrap code in markdown block format.
    """
    logger_setup.logger.debug(f"Inside build generate prompt \nPROMP = {prompt}\n")
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

    Return ONLY the constraints section starting with 'constraints:', or an empty list 'constraints: []' if no meaningful constraints can be inferred. Do not wrap code in markdown block format.
    """
    logger_setup.logger.debug(f"Inside build constraints prompt \nPROMP = {prompt}\n")
    return prompt