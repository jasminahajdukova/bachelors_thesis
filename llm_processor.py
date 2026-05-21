import ollama
import logging, colorlog

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


def build_yaml_prompt(samples, sql_server_type):
    return f"""
        Generate a Dataster YAML for this {sql_server_type} database.
        Each sample shows (MIN, MAX, AVG, COUNT_DISTINCT) for that column.

        Database samples:
        {samples}

        Generate the YAML. Return ONLY the raw content, nothing else:
    """





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
    #print(f"QUERY MESSAGE = {response.message.content}")
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