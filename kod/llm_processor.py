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

def build_yaml_prompt(samples, sql_server_type):
    json_data = json.dumps(samples, default=json_decimal)
    prompt = f"""Generate a YAML file ONLY for these exacts tables and columns from a {sql_server_type} database.
        Do NOT copy examples. Generate based ONLY on this data.
        Each sample shows values in format [MIN, MAX, AVG, COUNT_DISTINCT] for that column.

        Database samples:
        {json_data}

        Generate the YAML. Return ONLY the raw content, nothing else:
    """
    logger.debug(f"Prompt: {prompt}")
    return prompt





# pridaj rozsirenie dalsich llm
def generate_sql_query(template: str, sql_server_type: str, db_name: str,model: str = "llama3.1:8b"):
    logger.info(f"Generating SQL query for {sql_server_type}")
    prompt = f"""You are a SQL expert. Generate a valid {sql_server_type} SQL query based on this template for database: {db_name}.

            Template:
            {template}

            Rules:
            - Return ONLY the SQL query, no explanation, no markdown
            - do not wrap the query in ```sql``` blocks
            - The query must be valid {sql_server_type} syntax

            SQL query:"""
    
    response = ollama.chat(model=model,
                           messages=[
                               {'role': 'user', 'content': prompt}
                           ])
    print(f"QUERY MESSAGE = {response.message.content}")
    logger.debug(f"Generated SQL query: {response.message.content}")
    return response.message.content




def generate_yaml(samples: dict[str, str], sql_server_type: str, model: str = "yaml-generator-llm"):
    logger.info(f"Generating YAML for {sql_server_type}")
    prompt = build_yaml_prompt(samples, sql_server_type)
    response = ollama.chat(model=model,
                           messages=[
                               {'role': 'user', 'content': prompt}
                           ])
    
    logger.debug(f"Generated YAML: {response.message.content}")
    return response.message.content