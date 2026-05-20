import ollama


AVAILABLE_INCLUDES = [
    "psc_cs",               # postal codes of cities in Czech Republic
    "first_names_cs",       # first names that are used in Czech Republic
    "cities_cs",            # names of cities in Czech Republic
    "animal_blocks_en",     # some animal kinds in English language
    "last_names_cs",        # last names that are used in Czech Republic
    "color_blocks_en",      # basic color names in English language
    "countries_cs"          # names of counties (in Czech language)
]


# pridaj rozsirenie dalsich llm
def generate_sql_query(template: str, sql_server_type: str, model: str = "llama3.1:8b"):
    response = ollama.chat(model=model,
                           messages=[
                               {'role': 'user', 'content': f'Generate SQL query based on this template {template} for {sql_server_type}'}
                           ])
    return response.message.content

def generate_yaml(samples: dict[str, str], sql_server_type: str, model: str = "llama3.1:8b"):
    response = ollama.chat(model=model,
                           messages=[
                               {'role': 'user', 'content': f'Generate YAML file based on these samples {samples} for {sql_server_type}'}
                           ])
    return response.message.content