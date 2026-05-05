import ollama

# pridaj rozsirenie dalsich llm
def generate_sql_query(template: str, sql_server_type: str, model: str = "llama3.1:8b"):
    response = ollama.chat(model=model,
                           messages=[
                               {'role': 'user', 'content': f'Generate SQL query based on this template {template} for {sql_server_type}'}
                           ])
    return response.message.content

def generate_yaml(template: str, samples: dict[str, str], sql_server_type: str, model: str = "llama3.1:8b"):
    response = ollama.chat(model=model,
                           messages=[
                               {'role': 'user', 'content': f'Generate YAML file based on this template {template} and samples {samples} for {sql_server_type}'}
                           ])
    return response.message.content