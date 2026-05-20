import yaml
import logging, colorlog

handler = colorlog.StreamHandler()
handler.setFormatter(colorlog.ColoredFormatter(
	'%(log_color)s%(levelname)s:%(name)s:%(message)s'))

logging.getLogger("mysql.connector").setLevel(logging.WARNING)
logging.getLogger("psycopg2").setLevel(logging.WARNING)

logger = logging.getLogger("YAML_GENERATOR")
logger.addHandler(handler)
logger.setLevel(logging.INFO)
logger.propagate = False


includes = None
types_ds = None

# TO DO
# POZOR CO AK INCLUDE NIE JE PRVE
# POZOR CO AK TYPES NIE JE PRVE


def validate_yaml(yaml_str: str):
    try:
        yaml_str = yaml_str.strip()
        print(f"YAML STR: \n {yaml_str}")
        if yaml_str.startswith("```"):
            yaml_str = yaml_str.split("\n", 1)[1]
        if yaml_str.endswith("```"):
            yaml_str = yaml_str.split("```", 1)[0]
            
        global includes, types_ds
        stream = yaml.safe_load(yaml_str)
        stream_keys: list[str] = list(stream.keys())

        if not all(key in stream_keys for key in ["types", "schema", "generate"]):
            logger.error("Schema containes invalid parts")
        for key in stream_keys:
            if key == "include":
                validate_include(stream[key])   
                includes = stream[key]
            elif key == "types":
                iterate_types(stream[key])
                types_ds = stream[key]
            elif key == "schema":
                iterate_schemas(stream[key])
            elif key == "generate":
                validate_generate(stream[key])
            elif key == "constrains":
                validate_constrains(stream[key])
            else:
                logger.error("Uknown type")
        save_yaml(stream)
    except yaml.YAMLError as exc:
        logger.error(f"Error: {exc}")
    
    

def validate_types(each_type: str):
    basic_types: list[str] = ["int", "bool", "string", "float", "bigInt"]
    param_types: list[str] = ["seq", "interval", "dinterval", "finterval", "str_len", "regex"]
    dataset_types: list[str] = includes

    for value in list(each_type.values()):
        if isinstance(value, list):
            pass
        if isinstance(value,dict):
            pass
        if value in basic_types:
            pass
        elif any(value.startswith(whatever) for whatever in param_types):
            pass
        elif dataset_types is not None and value in dataset_types:
            pass
        else:
            logger.error("Uknown type")



def iterate_types(types: str):
    list_of_types: list[dict[str, str]] = list(types.keys())
    for part in list_of_types:
        validate_types(types[part])



def validate_schema(each_schema: str):
    if types_ds is None:
        return
    for value in list(each_schema.values()):
        if isinstance(value, str) and value.startswith("FFROM: "):
            continue
        split_fiction = value.split(".")
        if split_fiction[0] not in types_ds:
            logger.error("Uknown type")
        elif split_fiction[1] not in list(types_ds[split_fiction[0]].keys()):
            logger.error("Uknown type")



def iterate_schemas(schema: str):
    list_of_schemas: list[dict[str, str]] = list(schema.keys())
    for part in list_of_schemas:
        validate_schema(schema[part])



def validate_generate(generate: str):
    if types_ds is None:
        return
    
    split_generate: list[str]
    for value in generate:
        if not "=" in value:
            logger.error("Value is missing =")
        split_generate = value.split("=")
        count = split_generate[1].strip()
        if split_generate[0].strip() not in types_ds or not split_generate[1].strip().isdigit() and count != "auto":
            logger.error(f"Uknown type or invalid count: {value}")



def validate_include(includes: str):
    pass


def validate_constrains(constrains: str):
    pass


def save_yaml(stream: str):
    yaml_string = yaml.dump(stream, default_flow_style=False, indent=4, width=80)
    with open("demo.yaml", "w") as f:
        f.write(yaml_string)

       