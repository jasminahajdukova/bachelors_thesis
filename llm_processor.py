import ollama
import os, logging, colorlog

handler = colorlog.StreamHandler()
handler.setFormatter(colorlog.ColoredFormatter(
	'%(log_color)s%(levelname)s:%(name)s:%(message)s'))

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


def load_yaml_examples(examples_dir = "yaml_examples"):
    examples = []
    if not os.path.exists(examples_dir):
        logger.error("Folder does not exist.")
        return []
    
    for file_name in os.listdir(examples_dir):
        if file_name.endswith(".yaml"):
            file_path = os.path.join(examples_dir, file_name)
            with open(file_path, "r", encoding="utf-8") as file:
                logger.debug(f"Reading file: {file_name}")
                content = file.read()
            examples.append(f"Example: {file_name} \n{content}")

    return "\n\n".join(examples)


def build_yaml_prompt(samples, sql_server_type):
    examples = load_yaml_examples()
    include_list = "\n".join(f" - {inc}" for inc in AVAILABLE_INCLUDES)

    return 





# pridaj rozsirenie dalsich llm
def generate_sql_query(template: str, sql_server_type: str, db_name: str,model: str = "llama3.1:8b"):
    logger.info(f"Generating SQL query for {sql_server_type}")
    prompt = f"""You are a SQL expert. Generate a valid {sql_server_type} SQL query based on this template for database: {db_name}.

            Template:
            {template}

            Rules:
            - Return ONLY the SQL query, no explanation
            - The query must be valid {sql_server_type} syntax

            SQL query:"""
    
    response = ollama.chat(model=model,
                           messages=[
                               {'role': 'user', 'content': prompt}
                           ])
    #print(f"QUERY MESSAGE = {response.message.content}")
    logger.debug(f"Generated SQL query: {response.message.content}")
    return response.message.content


def generate_yaml(samples: dict[str, str], sql_server_type: str, model: str = "llama3.1:8b"):
    prompt = build_yaml_prompt(samples, sql_server_type)
    response = ollama.chat(model=model,
                           messages=[
                               {'role': 'user', 'content': prompt}
                           ])
    
    logger.debug(f"Generated YAML: {response.message.content}")
    return response.message.content