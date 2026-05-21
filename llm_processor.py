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

    return f"""You are generating a Dataster YAML configuration file for test data generation.

        Dataster YAML has this exact structure:
        - include: list of external datasets (use empty list [] if none needed)
        - types: defines a generator for each field using Dataster syntax
        - schema: maps real database tables and columns to types
        - generate: how many rows to generate per type
        - constraints: optional conditions between fields

        Available Dataster generators:
        - int, bool, string, float       (basic types)
        - seq(start,end,step)            (auto-incrementing number)
        - interval(min,max)              (random integer in range)
        - dinterval(YYYY-M-D,YYYY-M-D)  (random date in range)
        - str_len(min,max)               (random string of given length)
        - regex('pattern')               (string matching regex)
        - BLOCKS with list               (pick from enum values)
        - FROM table.column              (foreign key reference)

        Available datasets for include:
        {include_list}

        Rules:
        - Every column in schema must reference a type defined in types
        - Foreign keys must use FROM syntax
        - Use sample data (MIN, MAX, AVG) to choose realistic ranges for intervals
        - Use include datasets when column name suggests names, cities, countries, colors, animals
        - Return ONLY valid YAML, no explanation, no markdown fences
        - Do NOT include any explanation, comments or markdown fences
        - Return ONLY the raw content, nothing else
        - For regex patterns, always use double quotes inside: regex("[pattern]")
        - Generate YAML ONLY based on the provided database samples
        - Do NOT invent tables or columns that are not in the samples
        - If samples are empty, return an empty YAML structure
        - Do NOT start the YAML with a dash (-)
        - The YAML must start directly with a key like 'include:' or 'types:' 
        - If there are no constraints, write 'constraints: []', never leave it empty
        - When using regex, always wrap the entire value in double quotes: regex("[pattern]")
        - Never mix single and double quotes in regex patterns  


        Here are all available Dataster YAML examples to learn the format from:

        {examples}

        --- End of examples ---

        Now generate a Dataster YAML for this {sql_server_type} database.
        Each sample shows (MIN, MAX, AVG, COUNT_DISTINCT) for that column.

        Database samples:
        {samples}

        Generate the YAML:"""


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