import yaml, re
import logging, colorlog
from llm_processor import AVAILABLE_INCLUDES

handler = colorlog.StreamHandler()
handler.setFormatter(colorlog.ColoredFormatter(
	'%(asctime)s %(log_color)s %(levelname)s: %(name)s:%(message)s',
    datefmt='%Y-%m-%d %H:%M:%S'))

logging.getLogger("mysql.connector").setLevel(logging.WARNING)
logging.getLogger("psycopg2").setLevel(logging.WARNING)

logger = logging.getLogger("YAML_GENERATOR")
logger.addHandler(handler)
logger.setLevel(logging.INFO)
logger.propagate = False

def remove_markdown(yaml_str):

    if "```" in yaml_str:
        yaml_part = yaml_str.split("```")
        yaml_str = yaml_part[1].strip()
        if yaml_str.startswith("yaml\n") or yaml_str.startswith("yml\n"):
            yaml_str = yaml_str.split("\n", 1)[1] 
    if yaml_str.endswith("```"):
        yaml_str = yaml_str.split("```", 1)[0]

    if '---' in yaml_str:
        yaml_str = yaml_str.split("---")[0].strip()

    return yaml_str

def validate_yaml(yaml_str: str):
    try:
        yaml_str = yaml_str.strip()
        
        
        yaml_str = remove_markdown(yaml_str)
        logger.debug(f"YAML STR: \n {yaml_str}")

        stream = yaml.safe_load(yaml_str)
        stream_keys: list[str] = list(stream.keys())

        includes = None
        types_ds = None
        if not all(key in stream_keys for key in ["types", "schema", "generate"]):
            logger.error(f"Schema containes invalid parts")
            raise TypeError("YAML contais invalid parts")
        
        if "include" in stream_keys:
            validate_include(stream["include"])   
            includes = stream["include"]

        if "types" in stream_keys:
            iterate_types(stream["types"], includes)
            types_ds = stream["types"]

        if "schema" in stream_keys:
            iterate_schemas(stream["schema"], types_ds)
        
        if "generate" in stream_keys:
            validate_generate(stream["generate"], types_ds)

        if "constraints" in stream_keys:
            validate_constrains(stream["constraints"], types_ds)
        
        save_yaml(stream)
    except yaml.YAMLError as exc:
        logger.error(f"Error: {exc}")
    except TypeError as exc:
        logger.error(f"Error: {exc}")
    
def check_param(value):
    value_split = re.split(r"\s*[\(\),]\s*", value)
    logger.info(f"   VALUE SPLIT = {value_split}")

    if value_split[0] == "interval" and ("." in value_split[1] or "." in value_split[2]):
        raise TypeError("Interval expects int values")
    


def validate_types(each_type: str, includes):
    basic_types: list[str] = ["int", "bool", "string", "float", "bigint"]
    param_types: list[str] = ["seq", "interval", "dinterval", "finterval", "str_len", "regex"]
    dataset_types: list[str] = includes

    if isinstance(each_type, str): # tohto sa musim zbavit
        return
    for value in list(each_type.values()):
        logger.info(f"VALUE = {value}")
        if value is None:
            logger.error(f"Column has null type")
            continue
        if isinstance(value, list):
            continue
        if isinstance(value,dict):
            continue
        if value in basic_types:
            continue
        elif any(value.startswith(whatever) for whatever in param_types):
            check_param(value)
            continue
        elif dataset_types is not None and value in dataset_types:
            continue
        else:
            logger.error(f"2. Uknown type {value}")
            raise TypeError(f"2. Unknow type {value}")



def iterate_types(types: str, includes):
    list_of_types: list[dict[str, str]] = list(types.keys())
    for part in list_of_types:
        if isinstance(types[part], list):
            pass
        else:
            validate_types(types[part], includes)



def validate_schema(each_schema: str, types_ds):
    if types_ds is None:
        return
    
    if isinstance(each_schema, str): # tohto sa musim zbavit
        return

    for value in list(each_schema.values()):
        if value is None:
            logger.error("Schema contains null value")
            continue
        if isinstance(value, str) and value.startswith("FROM "):
            continue
        if isinstance(value, list) or isinstance(value,dict):
            continue
        split_fiction = value.split(".")
        if split_fiction[0] not in types_ds:
            logger.error(f"3. Uknown type {split_fiction[0]}")
            raise TypeError(f"3. Uknown type {split_fiction[0]}")
        elif len(split_fiction) < 2 :
            continue
        elif split_fiction[1] not in list(types_ds[split_fiction[0]].keys()):
            logger.error(f"4. Uknown type {split_fiction[1]}")
            raise TypeError(f"2. Unknow type {value}")



def iterate_schemas(schema: str, types_ds):
    list_of_schemas: list[dict[str, str]] = list(schema.keys())
    for part in list_of_schemas:
        validate_schema(schema[part], types_ds)



def validate_generate(generate: str, types_ds):
    if types_ds is None:
        return
    
    split_generate: list[str]
    for value in generate:
        if not "=" in value:
            logger.error("Value is missing =")
            raise TypeError("Value is missing =")
        split_generate = value.split("=")
        count = split_generate[1].strip()
        if split_generate[0].strip() not in types_ds or not split_generate[1].strip().isdigit() and count != "auto":
            logger.error(f"5. Uknown type or invalid count: {value}")
            raise TypeError(f"5. Uknown type or invalid count: {value}")



def validate_include(includes: str):
    if not all([value in AVAILABLE_INCLUDES for value in includes]):
        logger.error(f"Include not part of available includes")
        raise TypeError("Include not part of available includes")


def validate_constrains(constrains: str, types_ds):
    if types_ds is None:
        return
    logger.debug(f"Constraints: {constrains}")
    for constraint in constrains:
        constraint_split = constraint.split(" ")
        if len(constraint_split) < 3:
            logger.error(f"Invalid constraint format: {constraint}")
            continue
        typename = constraint_split[0]
        operator = constraint_split[1]
        value = constraint_split[2]
        regex = r'[-+]?(?:\d+(?:\.\d*)?|\.\d+)'
        if (typename.split(".")[0] not in types_ds) or (operator not in ["=", "!=", "<", ">", "<=", ">="] or (not bool(re.match(regex, value)) and value.split(".")[0] not in types_ds)):
            logger.error(f"Invalid constraint: {constraint}")
            raise TypeError(f"Invalid constraint: {constraint}")


def save_yaml(stream: str):
    yaml_string = yaml.dump(stream, default_flow_style=False, indent=4, width=80, sort_keys=False)
    with open("dataster_config.yaml", "w") as f:
        f.write(yaml_string)

       