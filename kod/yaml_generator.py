import yaml
import re
import logging
import colorlog
from llm_processor import AVAILABLE_INCLUDES
from dataclasses import dataclass
from datetime import datetime
import csv
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

@dataclass
class YAML_result:
    database: str
    section: str
    error_type: str
    severity: int
    detail: str



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

def validate_yaml(db_name: str, yaml_str: str) -> list[YAML_result]:
    
    errors = []
    yaml_str = yaml_str.strip()
    
    
    yaml_str = remove_markdown(yaml_str)
    logger.debug(f"YAML STR: \n {yaml_str}")
    try:
        stream = yaml.safe_load(yaml_str)
        if stream:
            stream_keys: list[str] = list(stream.keys())
        else:
            raise yaml.YAMLError
    except yaml.YAMLError:
        logger.error("Failed to load YAML")
        errors.append(YAML_result(db_name, "YAML load", "yaml_load", 1, "Failed to load YAML"))
        return errors
    includes = None
    types_ds = None
    if not all(key in stream_keys for key in ["types", "schema", "generate"]):
        logger.error("Schema containes invalid parts")
        errors.append(YAML_result(db_name, "YAML", "invalid_section", 1, "YAML contains invalid parts"))
    
    if "include" in stream_keys:
        errors += validate_include(db_name, stream["include"])   
        includes = stream["include"]

    if "types" in stream_keys:
        errors += iterate_types(db_name, stream["types"], includes)
        types_ds = stream["types"]

    if "schema" in stream_keys:
        errors += iterate_schemas(db_name, stream["schema"], types_ds)
    
    if "generate" in stream_keys:
        generate = stream["generate"]
        errors += validate_generate(db_name, generate, types_ds)
        errors += validate_seq(db_name, generate, types_ds)

    if "constraints" in stream_keys:
        errors += validate_constrains(db_name, stream["constraints"], types_ds)
    
    # if all(result.severity != 1 for result in errors):
    #     save_yaml(stream, db_name)
    # else:
    #     logger.error(f"Found critical error")    
    save_yaml(yaml_str, db_name)
    logger.info(f"ERRORS = {errors}")
    return errors

def validate_seq(db_name, generate, types) -> list[YAML_result]:
    errors = []
    logger.info(f"list(types.keys()) = {list(types.keys())}")
    for part in generate:
        part_split = part.split("=")
        logger.info(f"parts_split = {part_split}")
        gen_name = part_split[0].strip()
        if gen_name not in list(types.keys()):
            logger.error(f"Generate tried to generate part {part_split} not included in TYPES section {list(types.keys())}")
            errors.append(YAML_result(db_name, "generate", "invalid_generate", 1,f"Generate tried to generate part {part_split} not included in TYPES section {list(types.keys())}"))
            continue
        types_value = list(types[gen_name].values())
        logger.info(f"TYPES_VALUE = {types_value}")

        
        for value in types_value:
            logger.info(f"seq {value} type {type(value)}")
           
            value = str(value)
            logger.info(f"seq {value} type {type(value)}")
        
            if not value.startswith("seq"):
                continue
            seq = re.split(r"\s*[\(\),]\s*", value)
            logger.info(f"SEQ = {seq}")
            try:
                if len(seq) >= 3:
                    gen_num = int(part_split[1])
                    seq_len = (int(seq[2]) - int(seq[1])) // int(seq[3]) + 1
                else:
                    raise ValueError
            except ValueError:
                logger.error(f"Generate or Seq expected number: generate = {part_split[1]} seq = {seq}")
                errors.append(YAML_result(db_name, "generate", "invalid_generate", 1, f"Generate or Seq expected number: generate = {part_split[1]} seq = {seq}"))
                continue

            if gen_num > seq_len:
                logger.error(f"Number of generate for {part_split[0]} > seq len: seq_len {seq_len} generate: {part_split[1]}")
                errors.append(YAML_result(db_name, "generate", "invalid_generate", 1, f"Number of generate for {part_split[0]} > seq len: seq_len {seq_len} generate: {part_split[1]}"))
            if gen_num < seq_len:
                logger.error(f"Number of generate for {part_split[0]} < seq len: seq_len {seq_len} generate: {part_split[1]}")
                errors.append(YAML_result(db_name, "generate", "invalid_generate", 2, f"Number of generate for {part_split[0]} < seq len: seq_len {seq_len} generate: {part_split[1]}"))
            
    return errors
    
    
def check_param(db_name, value) -> list[YAML_result]:
    # dopln dinterval + strlen
    errors = []
    value_split = re.split(r"\s*[\(\),]\s*", value)
    logger.info(f"   VALUE SPLIT = {value_split}")

    function_name = value_split[0]
    args = value_split[1:]

    if function_name == "interval":
        try:
            value1 = int(args[0])
            value2 = int(args[1])
        except ValueError:
            errors.append(YAML_result(db_name, "types", "invalid_types", 1, f"Interval expects two integers. Instead got {args}"))
            return errors
        if value1 >= value2:
            errors.append(YAML_result(db_name, "types", "invalid_types", 1, "Min value of interval exceed the max value"))
        
    elif function_name == "finterval":
        try:
            value1 = float(args[0])
            value2 = float(args[1])
        except ValueError:
            errors.append(YAML_result(db_name, "types", "invalid_types", 1, f"Finterval expects two floats. Instead got {args}"))
            return errors
        
        if value1 >= value2:
            errors.append(YAML_result(db_name, "types", "invalid_types", 1, "Min value of finterval exceed the max value"))
    
    elif function_name == "seq":
        try:
            value1 = int(args[0])
            value2 = int(args[1])
            value3 = int(args[2])
        except ValueError:
            errors.append(YAML_result(db_name, "types", "invalid_types", 1, f"Seq expects three integers. Instead got {args}"))
            return errors
        if value1 >= value2 or value3 <= 0:
            errors.append(YAML_result(db_name, "types", "invalid_types", 1, f"Invalid value inside seq(x,y,z). Got {args}"))

    elif function_name == "str_len":
        try:
            logger.info(f"ARGS JAS = {args}")
            min_val = args[0].split()[-1] if args else ""
            logger.info(f"1 MIN VAL JAS = {min_val}")
            if "[cC]" in min_val:
                logger.info(f"2 MIN VAL JAS = {min_val}")
                min_val = min_val.replace("[cC]","").strip()

            value1 = int(min_val)
            value2 = int(args[1])
        except ValueError:
            errors.append(YAML_result(db_name, "types", "invalid_types", 1, f"Invalid str_len value. Got {args}"))
            return errors
        
        if value1 > value2 or value1 < 0:
            errors.append(YAML_result(db_name, "types", "invalid_types", 1, f"Invalid value inside str_len. Got {args}"))


    elif function_name == "dinterval":
        try:
            date1 = datetime.strptime(args[0].strip("'"), "%Y-%m-%d")
            date2 = datetime.strptime(args[1].strip("'"),"%Y-%m-%d")
        except ValueError:
            errors.append(YAML_result(db_name, "types", "invalid_types", 1, f"Invalid value inside dinterval. Got {args}"))
            return errors
        if date1 >= date2:
            errors.append(YAML_result(db_name, "types", "invalid_types", 1, f"Invalid value inside dinterval. Got {args}"))



    return errors

def validate_types(db_name, each_type: str, includes) -> list[YAML_result]:
    errors = []
    basic_types: list[str] = ["int", "bool", "string", "float", "bigint"]
    param_types: list[str] = ["seq", "interval", "dinterval", "finterval", "str_len", "regex"]
    dataset_types: list[str] = includes

    if isinstance(each_type, str): # tohto sa musim zbavit
        return []
    
    for value in list(each_type.values()):
    
        logger.info(f"VALUE = {value}")
    
        if value is None:
            logger.error("Column has null type")
            continue
        if isinstance(value, list):
            continue
        if isinstance(value,dict):
            continue
        if value in basic_types:
            continue
        elif any(value.startswith(whatever) for whatever in param_types):
            errors += check_param(db_name, value)
            continue
        elif dataset_types is not None and value in dataset_types:
            continue
        else:
            logger.error(f"2. Unknown type {value}")
            errors.append(YAML_result(db_name, "types", "invalid_types", 1, f"Unknown type {value}"))

    return errors


def iterate_types(db_name, types: str, includes) -> list[YAML_result]:
    errors = []

    list_of_types: list[dict[str, str]] = list(types.keys())
    for part in list_of_types:
        if isinstance(types[part], list):
            pass
        else:
            errors += validate_types(db_name, types[part], includes)

    return errors


def validate_schema(db_name, each_schema: str, types_ds) -> list[YAML_result]:
    errors = []
    if types_ds is None:
        return []
    
    if isinstance(each_schema, str): # tohto sa musim zbavit
        return []

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
            errors.append(YAML_result(db_name, "schema", "invalid_schema", 1, f"Uknown type {split_fiction[0]}"))
        elif len(split_fiction) < 2 :
            continue
        elif split_fiction[1] not in list(types_ds[split_fiction[0]].keys()):
            logger.error(f"4. Uknown type {split_fiction[1]}")
            errors.append(YAML_result(db_name, "schema", "invalid_schema", 1, f"Uknown type {value}"))

    return errors

def iterate_schemas(db_name, schema: str, types_ds) -> list[YAML_result]:
    errors = []
    list_of_schemas: list[dict[str, str]] = list(schema.keys())
    for part in list_of_schemas:
        errors += validate_schema(db_name, schema[part], types_ds)

    return errors


def validate_generate(db_name, generate: str, types_ds) -> list[YAML_result]:
    
    errors = []
    
    if types_ds is None:
        return []
    
    split_generate: list[str]
    for value in generate:
        if "=" not in value:
            logger.error("Value is missing =")
            errors.append(YAML_result(db_name, "generate", "invalid_generate", 1, f"Value ({value}) is missing ="))
        split_generate = value.split("=")
        count = split_generate[1].strip()
        if split_generate[0].strip() not in types_ds or not split_generate[1].strip().isdigit() and count != "auto":
            logger.error(f"5. Uknown type or invalid count: {value}")
            errors.append(YAML_result(db_name, "generate", "invalid_generate", 1, f"Unknown type or invalid count {value}"))

    return errors

def validate_include(db_name, includes: str) -> list[YAML_result]:
    errors = []

    invalid_includes = [value for value in includes if value not in AVAILABLE_INCLUDES]
    if invalid_includes:
        logger.error(f"{invalid_includes} not part of available includes {AVAILABLE_INCLUDES}")
        errors.append(YAML_result(db_name, "include", "invalid_include", 1, f"{invalid_includes} not part of available includes {AVAILABLE_INCLUDES}"))

    return errors


def validate_constrains(db_name, constrains: str, types_ds) -> list[YAML_result]:

    errors = []

    if types_ds is None:
        return []
    
    logger.info(f"Constraints: {constrains}")
    for constraint in constrains:
        logger.info(f"Constraint = {constraint}")

        constraint_split = constraint.split(" ", 2)
        if len(constraint_split) >= 3:
            typename = constraint_split[0]
            operator = constraint_split[1]

            if operator.lower() == "in":
                typename_parts = typename.split(".")

                if len(typename_parts) != 2 or typename_parts[0] not in types_ds or typename_parts[1] not in types_ds[typename_parts[0]]:
                    logger.error(f"Invalid 'in' constraint (type does not exist): {constraint}")
                    errors.append(YAML_result(db_name, "constraints", "invalid_constraint", 2, f"Constraint type does not exist in types section, {typename}"))
                    continue

                actual_type = types_ds[typename_parts[0]][typename_parts[1]]
                if isinstance(actual_type, list):
                    pass
                
                elif not isinstance(actual_type, str) or not (actual_type.startswith("enum") or "BLOCKS" in actual_type):
                    logger.error(f"Invalid type for 'in' operator: {typename} is {actual_type}. Expected enum or BLOCKS.")
                    errors.append(YAML_result(db_name, "constraints", "invalid_constraint", 2, f"Invalid type for 'in' operator: {typename} is {actual_type}."))
                    continue
                
                logger.info(f"Successfully validated 'in' constraint: {constraint}")
                continue
        
        constraint_split = constraint.split(" ")

        if len(constraint_split) < 3:
            logger.error(f"Invalid constraint format: {constraint}")
            errors.append(YAML_result(db_name, "constraints","invalid_constraint", 2, f"Invalid constraints format {constraint}"))
            continue
        typename = constraint_split[0]
        operator = constraint_split[1]
        value = constraint_split[2]
        regex = r'[-+]?(?:\d+(?:\.\d*)?|\.\d+)'
        if (typename.split(".")[0] not in types_ds) or (operator not in ["=", "!=", "<", ">", "<=", ">="] or (not bool(re.match(regex, value)) and value.split(".")[0] not in types_ds)):
            logger.error(f"Invalid constraint: {constraint}")
            errors.append(YAML_result(db_name, "constraints", "invalid_constraint", 1, f"Invalid constraint {constraint}"))
            continue 
        logger.info(f"typename = {typename}, operator = {operator}, value = {value}")
        num_re = r"^-?\d+(\.\d+)?$"

        is_num = bool(re.match(num_re, str(value)))
        typename = typename.split(".")

        value_split = str(value).split(".") if ("." in str(value)and not is_num) else ""
        logger.info(f"typename[1] = {typename[1]} types_ds[typename[0]] = {list(types_ds[typename[0]].keys())}")
        
        
        if typename[1] not in list(types_ds[typename[0]].keys()):
            logger.error(f"1. Constraint type {typename[1]} does not exitst in types section {list(types_ds[typename[0]].keys())}, ")
            errors.append(YAML_result(db_name, "constraints", "invalid_constraint", 2, f"Constraint type does not exitst in types section, {typename[1]}"))
            continue
        elif (value_split and len(value_split) > 1 and value_split[1] not in list(types_ds[value_split[0]].keys())):
            logger.error(f"2. Constraint type {value_split} does not exitst in types section {list(types_ds[value_split[0]].keys())}, ")
            errors.append(YAML_result(db_name, "constraints", "invalid_constraint", 2, f"2. Constraint type {".".join(value_split)} does not exitst in types section {list(types_ds[value_split[0]].keys())}"))
            continue
        
        typename_value = types_ds[typename[0]][typename[1]]
        logger.info(f"types_ds[typename[0]][typename[1]] = {typename_value}")
        value_val = types_ds[value_split[0]][value_split[1]] if value_split else ""
        logger.info(f"value_val = {value_val}")
        if not isinstance(typename_value, str):
            errors.append(YAML_result(db_name, "constraints", "invalid_constraints", 1, "Not a string"))
            continue
        
        is_fk_equality = (operator == "=" and value_split and not is_num)

        if not typename_value.startswith(("int", "bigint", "float", "interval", "finterval", "dinterval", "bool")):
            severity = 2 if typename_value.startswith("seq") else 1
            if not is_fk_equality:
                logger.error(f"Invalid type of constraint: {typename} is {typename_value}.")
                errors.append(YAML_result(db_name, "constraints", "invalid_constraint", severity, f"Invalid type of constraint: {typename} is {typename_value}."))
                continue

        if not is_fk_equality and value_val and not value_val.startswith(("int", "bigint", "float", "interval", "finterval", "dinterval", "bool")):
            severity = 2 if value_val.startswith("seq") else 1
            logger.error(f"Invalid type of constraint: {value_split} is {value_val}.")
            errors.append(YAML_result(db_name, "constraints", "invalid_constraint", severity, f"Invalid type of constraint: {value_split} is {value_val}."))
            continue

    return errors

def save_yaml(yaml_string: str, db_name: str):
    with open(f"results/dataster_config-{db_name}.yaml", "a") as f:
        f.write(yaml_string)
        f.write("\n----------------------------------------------------------------------\n")


def save_csv(errors: list[YAML_result], db_name: str):
    field_names = ["database", "section", "error_type", "severity", "detail"]

    with open(f"results/results-{db_name}.csv", mode="a", newline="", encoding="utf-8") as file:
        writer = csv.writer(file)
        writer.writerow(field_names)

        for error in errors:
            writer.writerow([error.database, error.section, error.error_type, error.severity, error.detail])
        
    
    logger.info("Results saved into results/results.csv")