import os

import yaml
import re
import logging
import colorlog
from llm_processor import AVAILABLE_INCLUDES
from dataclasses import dataclass
from datetime import datetime
import csv
handler = colorlog.StreamHandler()
# handler.setFormatter(colorlog.ColoredFormatter(
# 	'%(asctime)s %(log_color)s %(levelname)s: %(name)s:%(message)s',
#     datefmt='%Y-%m-%d %H:%M:%S'))

handler.setFormatter(colorlog.ColoredFormatter(
	'%(asctime)s %(log_color)s %(message)s',
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
    
    save_original_yaml(yaml_str, db_name)

    try:
        stream = yaml.safe_load(yaml_str)
        if stream:
            stream_keys: list[str] = list(stream.keys())
        else:
            logger.error("HEERE")
            raise RuntimeError("Loaded empty YAML file")
    except (yaml.YAMLError, RuntimeError):
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
        errors += validate_constraints(db_name, stream["constraints"], types_ds)
    
    if all(result.severity != 1 for result in errors):
        save_yaml(yaml_str, db_name)
    else:
        logger.error(f"Found critical error")    
    logger.warning(f"ERRORS = {errors}")
    return errors

def validate_seq(db_name, generate, types) -> list[YAML_result]:
    errors = []

    for part in generate:
        if "=" not in part:
            continue

        part_split = part.split("=")
        gen_name = part_split[0].strip()

        if gen_name not in types:
            logger.error(f"Generate tried to generate part {part_split} not included in TYPES section {list(types.keys())}")
            errors.append(YAML_result(db_name, "generate", "invalid_generate", 1, f"Generate tried to generate part {part_split} not included in TYPES section {list(types.keys())}"))
            continue

        types_value = list(types[gen_name].values())
        
        for value in types_value:
           
            value = str(value)
        
            if not value.startswith("seq"):
                continue

            nums = re.findall(r"\d+", value)

            try:
                if len(nums) >= 2:
                    gen_num = int(part_split[1].strip())
                    min_num = int(nums[0])
                    max_num = int(nums[1])
                    step    = int(nums[2]) if len(nums) >=3 else 1
                    seq_len = (max_num - min_num) // step + 1
                else:
                    raise ValueError
                
            except (ValueError, IndexError, ZeroDivisionError):
                logger.error(f"Generate or Seq expected number: generate = {part_split[1]} seq = {value}")
                errors.append(YAML_result(db_name, "generate", "invalid_generate", 1, f"Generate or Seq expected number: generate = {part_split[1]} seq = {value}"))
                continue

            if gen_num > seq_len:
                logger.error(f"Number of generate for {part_split[0]} > seq len: seq_len {seq_len} generate: {part_split[1]}")
                errors.append(YAML_result(db_name, "generate", "invalid_generate", 1, f"Number of generate for {part_split[0]} > seq len: seq_len {seq_len} generate: {part_split[1]}"))

    return errors
    
    
def check_param(db_name, value) -> list[YAML_result]:
    # dopln dinterval + strlen
    errors = []
    value_split = re.split(r"\s*[\(\),]\s*", value)

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
            
            min_val = args[0].strip() if args else ""
            max_val = args[1].strip()  if len(args) > 1 else ""

            if not min_val:
                raise ValueError
            
            "-------------MIN VAL-------------"
            min_re = re.search(r"(\d+)\s*$", min_val)
            if not min_re:
                raise ValueError
            
            value1 = int(min_re.group(1))


            if not max_val:
                if value1 < 0:
                    errors.append(YAML_result(db_name, "types", "invalid_types", 1, f"Invalid value inside str_len. Got {args}"))

            else:
                "-------------MAX VAL-------------"
                max_re = re.search(r"(\d+)\s*$", max_val)

                if not max_re:
                    raise ValueError

                value2 = int(max_re.group(1))
                if value1 > value2 or value1 < 0:
                    errors.append(YAML_result(db_name, "types", "invalid_types", 1, f"Invalid value inside str_len. Got {args}"))


        except ValueError:
            errors.append(YAML_result(db_name, "types", "invalid_types", 1, f"Invalid str_len value. Got {args}"))
            return errors
        
        

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

    if not isinstance(each_type, dict): # 
        logger.error(f"Expected dict for table types got {type(each_type)}")
        errors.append(YAML_result(db_name, "types", "invalid_types", 1, f"Expected dict for table types got {type(each_type)}"))
        return errors
    
    for column_name, value in each_type.items():
    
        if value is None:
            logger.error(f"Column {column_name} has null type")
            errors.append(YAML_result(db_name, "types", "invalid_types", 1, f"Column {column_name} has null type"))
            continue

        if isinstance(value, (list, dict)):
            continue
        
        if not isinstance(value, str):
            logger.error(f"Invalid type format for column '{column_name}': {value} (expected string, got {type(value)})")
            errors.append(YAML_result(db_name, "types", "invalid_types", 1, f"Invalid type format for column '{column_name}': {value} (expected string, got {type(value)})"))
            continue
            
        if value in basic_types:
            continue
    
        elif any(value.startswith(whatever) for whatever in param_types):
            errors += check_param(db_name, value)
            continue
            
        elif value in dataset_types:
            continue
        else:
            logger.error(f"Unknown type {value} for column {column_name}")
            errors.append(YAML_result(db_name, "types", "invalid_types", 1, f"Unknown type {value} for column {column_name}"))

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
    
    if not isinstance(each_schema, dict): # 
        logger.error(f"Expected dict for table types got {type(each_schema)}")
        errors.append(YAML_result(db_name, "schema", "invalid_schema", 1, f"Expected dict for table types got {type(each_schema)}"))
        return errors

    for column_name, value in each_schema.items():

        if value is None:
            logger.error(f"Schema column {column_name} contains null value")
            errors.append(YAML_result(db_name, "schema", "invalid_schema", 1, f"Schema column {column_name} contains null value"))
            continue

        if isinstance(value, str) and value.startswith("FROM "):
            continue

        if isinstance(value, (list, dict)):
            continue

        if not isinstance(value, str):
            logger.error(f"Invalid schema format for column '{column_name}': {value} (expected string, got {type(value)})")
            errors.append(YAML_result(db_name, "schema", "invalid_schema", 1, f"Invalid schema format for column '{column_name}': {value} (expected string, got {type(value)})"))
            continue

        split_fiction = value.split(".")

        if len(split_fiction) != 2:
            logger.error(f"Invalid schema reference format {value} for column '{column_name}' (expected table.column)")
            errors.append(YAML_result(db_name, "schema", "invalid_schema", 1, f"Invalid schema reference format {value} for column '{column_name}' (expected table.column)"))
            continue
            
        table_ref = split_fiction[0]
        col_ref   = split_fiction[1]

        if table_ref not in types_ds:
            logger.error(f"Unknown table reference {table_ref} in schema for column {column_name}")
            errors.append(YAML_result(db_name, "schema", "invalid_schema", 1, f"Unknown table reference {table_ref} in schema for column {column_name}"))
            continue
        
        if col_ref not in types_ds[table_ref]:
            logger.error(f"Unknown column reference {col_ref} in schema for column {column_name}")
            errors.append(YAML_result(db_name, "schema", "invalid_schema", 1, f"Unknown column reference {col_ref} in schema for column {column_name}"))
            continue

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
    
    if not isinstance(generate, list): # 
        logger.error(f"Expected list for table types got {type(generate)}")
        errors.append(YAML_result(db_name, "generate", "invalid_generate", 1, f"Expected list for table types got {type(generate)}"))
        return errors
    
    for value in generate:

        if not isinstance(value, str):
            logger.error(f"Invalid type format in generate section {value} (expected string)")
            errors.append(YAML_result(db_name, "generate", "invalid_generate", 1, f"Invalid type format in generate section {value} (expected string)"))
            continue

        value = value.strip()
        if not value:
            continue

        if "=" not in value:
            logger.error(f"Value is missing = operator {value}")
            errors.append(YAML_result(db_name, "generate", "invalid_generate", 1, f"Value is missing = operator {value}"))
            continue

        split_generate = value.split("=", 1)
        table_name     = split_generate[0].strip()
        count          = split_generate[1].strip()

        if table_name not in types_ds:
            logger.error(f"Unknown table reference {table_name} in generate section")
            errors.append(YAML_result(db_name, "generate", "invalid_generate", 1, f"Unknown table reference {table_name} in generate section"))
            continue

        if not count.isdigit() and count.lower() != "auto":
            logger.error(f"Invalid count value {count} for table {table_name} (expected digits or auto)")
            errors.append(YAML_result(db_name, "generate", "invalid_generate", 1, f"Invalid count value {count} for table {table_name} (expected digits or auto)"))
            continue

    return errors

def validate_include(db_name, includes: str) -> list[YAML_result]:
    errors = []

    invalid_includes = [value for value in includes if value not in AVAILABLE_INCLUDES]
    if invalid_includes:
        logger.error(f"{invalid_includes} not part of available includes {AVAILABLE_INCLUDES}")
        errors.append(YAML_result(db_name, "include", "invalid_include", 1, f"{invalid_includes} not part of available includes {AVAILABLE_INCLUDES}"))

    return errors



def validate_in(db_name, constraints, typename, types_ds):
    errors = []
    typename_parts = typename.split(".")

    if len(typename_parts) != 2 or typename_parts[0] not in types_ds or typename_parts[1] not in types_ds[typename_parts[0]]:
        logger.error(f"Invalid 'in' constraint (type does not exist): {typename}")
        errors.append(YAML_result(db_name, "constraints", "invalid_constraint", 2, f"Constraint type does not exist in types section, {typename}"))
        return errors

    actual_type = types_ds[typename_parts[0]][typename_parts[1]]

    if isinstance(actual_type, list):
        return errors
    
    if not isinstance(actual_type, str) or not (actual_type.startswith("enum") or "BLOCKS" in actual_type):
        logger.error(f"Invalid type for 'in' operator: {typename} is {actual_type}. Expected enum or BLOCKS.")
        errors.append(YAML_result(db_name, "constraints", "invalid_constraint", 2, f"Invalid type for 'in' operator: {typename} is {actual_type}."))
        return errors
    
    return errors


def validate_rel_result(db_name, constraint, con_split, types_ds):
    errors = []
    typename = con_split[0].split(".")
    table_name = typename[0]
    operator = con_split[1]
    value = con_split[2]

    
    if (table_name not in types_ds):
        logger.error(f"Invalid constraint: {constraint}")
        errors.append(YAML_result(db_name, "constraints", "invalid_constraint", 1, f"Invalid constraint {constraint}"))
        return errors
    
    if operator not in ["=", "!=", "<", ">", "<=", ">="]:
        logger.error(f"Invalid operator {operator}: {constraint}")
        errors.append(YAML_result(db_name, "constraints", "invalid_constraint", 1, f"Invalid constraint {constraint}"))
        return errors
    
    num_re = r"^-?\d+(\.\d+)?$"
    is_num = bool(re.match(num_re, str(value)))
    value_num_re = r'[-+]?(?:\d+(?:\.\d*)?|\.\d+)'
    value_bool = bool(re.match(value_num_re, str(value)))
    value_split = str(value).split(".") if ("." in str(value) and not is_num) else []

    if not is_num and not value_bool and not value_split:
        logger.error(f"Invalid constraint value: {constraint}")
        errors.append(YAML_result(db_name, "constraints", "invalid_constraint", 1, f"Invalid constraint value: {constraint}"))
        return errors
     
    if typename[1] not in types_ds[table_name]:
        logger.error(f"Constraint type {typename[1]} does not exist in types section")
        errors.append(YAML_result(db_name, "constraints", "invalid_constraint", 2, f"1. Constraint type {typename[1]} does not exist in types section"))
        return errors
    
    if value_split and len(value_split) > 1:
        val_table = value_split[0]
        val_col   = value_split[1]

        if val_table not in types_ds or val_col not in types_ds[val_table]:
            logger.error(f"Constraint type {val_table}.{val_col} does not exist in types section")
            errors.append(YAML_result(db_name, "constraints", "invalid_constraint", 2, f"Constraint type {val_table}.{val_col} does not exist in types section"))
            return errors
    
    typename_value = types_ds[table_name][typename[1]]

    value_val = types_ds[value_split[0]][value_split[1]] if value_split else ""
   

    if not isinstance(typename_value, str):
        errors.append(YAML_result(db_name, "constraints", "invalid_constraints", 1, "Not a string"))
        return errors
    
    is_fk_equality = (operator == "=" and bool(value_split) and not is_num)

    if not typename_value.startswith(("int", "bigint", "float", "interval", "finterval", "dinterval", "bool")):
        severity = 2 if typename_value.startswith("seq") else 1
        if not is_fk_equality:
            logger.error(f"Invalid type of constraint: {typename} is {typename_value}.")
            errors.append(YAML_result(db_name, "constraints", "invalid_constraint", severity, f"Invalid type of constraint: {typename} is {typename_value}."))
            return errors

    if not is_fk_equality and value_val and not value_val.startswith(("int", "bigint", "float", "interval", "finterval", "dinterval", "bool")):
        severity = 2 if value_val.startswith("seq") else 1
        logger.error(f"Invalid type of constraint: {value} is {value_val}.")
        errors.append(YAML_result(db_name, "constraints", "invalid_constraint", severity, f"Invalid type of constraint: {value} is {value_val}."))
        return errors
    
    return errors


def validate_constraints(db_name, constraints: str, types_ds) -> list[YAML_result]:

    errors = []

    if not constraints or types_ds is None:
        return []
    
    for constraint in constraints:

        constraint = constraint.strip()
        if not constraint:
            continue

        constraint_split = constraint.split(" ", 2)
        if len(constraint_split) >= 3 and constraint_split[1].lower() == "in":
            errors += validate_in(db_name, constraint, constraint_split[0], types_ds)
            continue
        
        constraint_split = constraint.split(" ")

        if len(constraint_split) < 3:
            logger.error(f"Invalid constraint format: {constraint}")
            errors.append(YAML_result(db_name, "constraints","invalid_constraint", 2, f"Invalid constraints format {constraint}"))
            continue

        errors += validate_rel_result(db_name, constraint, constraint_split, types_ds)
        
    return errors

def save_yaml(yaml_string: str, db_name: str):
    with open(f"results/dataster/dataster_config-{db_name}.yaml", "a") as f:
        f.write(yaml_string)
        f.write("\n----------------------------------------------------------------------\n")
    
    logger.info(f"Final yaml saved into results/dataster/dataster_config-{db_name}.yaml")


def save_original_yaml(yaml_string: str, db_name: str):
    with open(f"results/original_yaml/dataster_config-{db_name}.yaml", "a") as f:
        f.write(yaml_string)
        f.write("\n----------------------------------------------------------------------\n")

    logger.info(f"Original yaml saved into results/original_yaml/dataster_config-{db_name}.yaml")


def save_csv(errors: list[YAML_result], db_name: str):
    field_names = ["database", "section", "error_type", "severity", "detail"]

    writer_header = not os.path.exists(f"results/results-{db_name}.csv") or os.path.getsize(f"results/results-{db_name}.csv") == 0

    with open(f"results/csv/results-{db_name}.csv", mode="a", newline="", encoding="utf-8") as file:
        writer = csv.writer(file)
        if writer_header:
            writer.writerow(field_names)

        for error in errors:
            writer.writerow([error.database, error.section, error.error_type, error.severity, error.detail])
        
    
    logger.info("Results saved into results/csv/results.csv")