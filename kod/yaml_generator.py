import os
import yaml
import re
import logger_setup
from dataclasses import dataclass
from datetime import datetime
import csv
from yaml.loader import SafeLoader


AVAILABLE_INCLUDES = [
    "psc_cs",               # postal codes of cities in Czech Republic
    "first_names_cs",       # first names that are used in Czech Republic
    "cities_cs",            # names of cities in Czech Republic
    "animals_blocks_en",     # some animal kinds in English language
    "last_names_cs",        # last names that are used in Czech Republic
    "colors_blocks_en",      # basic color names in English language
    "countries_cs"          # names of counties (in Czech language)
]

@dataclass
class YAML_result:
    database: str
    section: str
    error_type: str
    severity: int
    detail: str

class UniqueKeyLoader(SafeLoader):
    def construct_mapping(self, node, deep = False):
        mapping = {}
        for key_node, value_node in node.value:
            key = self.construct_object(key_node, deep=deep)
            if key in mapping:
                raise ValueError(f"Duplicit key detected in YAML configuration: {key}")
            mapping[key] = self.construct_object(value_node, deep=deep)
        
        return mapping

def remove_markdown(yaml_str):

    if "```" in yaml_str:
        yaml_part = yaml_str.split("```")
        yaml_str  = yaml_part[1].strip()
        if yaml_str.startswith("yaml\n") or yaml_str.startswith("yml\n"):
            yaml_str = yaml_str.split("\n", 1)[1] 
    if yaml_str.endswith("```"):
        yaml_str = yaml_str.split("```", 1)[0]

    if '---' in yaml_str:
        yaml_str = yaml_str.split("---")[0].strip()

    return yaml_str



def validate_yaml(db_name: str, yaml_str: str, samples: dict) -> list[YAML_result]:
    errors = []
    logger_setup.logger.warning(f"Validating YAML for database: {db_name}")
    
    yaml_str = remove_markdown(yaml_str)
    
    try:

        data = yaml.load(yaml_str, Loader=UniqueKeyLoader)
    except ValueError as ve:
        logger_setup.logger.error(f"YAML Duplicate Error: {str(ve)}")
        errors.append(YAML_result(db_name, "syntax", "duplicate_key", 1, str(ve)))
        return errors
    except Exception as e:
        logger_setup.logger.error(f"YAML Syntax Error: {str(e)}")
        errors.append(YAML_result(db_name, "syntax", "invalid_yaml", 1, str(e)))
        return errors

    if not isinstance(data, dict):
        errors.append(YAML_result(db_name, "pipeline", "invalid_structure", 1, "Expected top-level dict"))
        return errors

    if not all(key in data for key in ["types", "schema", "generate"]):
        logger_setup.logger.error("Schema containes invalid parts")
        errors.append(YAML_result(db_name, "YAML", "invalid_section", 1, "YAML contains invalid parts"))
    
    includes = data.get("include", [])
    if "include" in data:
        errors  += validate_include(db_name, data["include"])   

    types_sec = data.get("types", {})
    if not isinstance(types_sec, dict):
        errors.append(YAML_result(db_name, "types", "flat_types_collapse", 1, "Section 'types' collapsed or is not a dictionary"))
    else:
        real_tables = set(samples.keys())
        generated_tables = set(types_sec.keys())
        

        if not generated_tables.intersection(real_tables) and generated_tables:
            errors.append(YAML_result(db_name, "types", "flat_types_collapse", 1, "Top-level keys in 'types' do not match any real database tables. Flat collapse suspected."))

    if isinstance(types_sec, dict):
        for table_name, columns in types_sec.items():
            if not isinstance(columns, dict):
                continue
            for col_name, col_def in columns.items():
                
   
                if isinstance(col_def, list):
                    if not col_def or col_def[0] != "BLOCKS":
                        errors.append(YAML_result(db_name, "types", "invalid_blocks", 1, f"List in {table_name}.{col_name} must start with 'BLOCKS'"))
                    for item in col_def[1:]:
                        if isinstance(item, (list, dict)):
                            errors.append(YAML_result(db_name, "types", "invalid_blocks_element", 1, f"BLOCKS element in {table_name}.{col_name} must be a scalar value, found complex structure"))

              
                elif isinstance(col_def, dict):
                    keys = set(col_def.keys())
                    if keys != {"format", "values"}:
                        errors.append(YAML_result(db_name, "types", "invalid_dict_keys", 1, f"Dictionary in {table_name}.{col_name} must contain exactly 'format' and 'values' keys"))
                        continue
                    
                    fmt_str = col_def["format"]
                    val_list = col_def["values"]
                    
                    if not isinstance(fmt_str, str) or not isinstance(val_list, list):
                        errors.append(YAML_result(db_name, "types", "invalid_dict_types", 1, f"Invalid sub-types for format (str) or values (list) in {table_name}.{col_name}"))
                        continue
                    
               
                    placeholder_count = len(re.findall(r'\{\}', fmt_str))
                    if placeholder_count != len(val_list):
                        errors.append(YAML_result(db_name, "types", "arity_mismatch", 1, f"Arity mismatch in {table_name}.{col_name}: format has {placeholder_count} placeholders but values has {len(val_list)} elements"))
                    
                 
                    for val in val_list:
                        if not isinstance(val, str):
                            errors.append(YAML_result(db_name, "types", "invalid_value_literal", 1, f"Value in {table_name}.{col_name} must be a string reference, found literal/number"))
                            continue
                        
         
                        if val not in AVAILABLE_INCLUDES:
                            if "." not in val:
                                errors.append(YAML_result(db_name, "types", "invalid_reference", 1, f"Value '{val}' in {table_name}.{col_name} is neither a built-in dataset nor a table.column reference"))
                            else:
                                ref_t, ref_c = val.split(".", 1)
                                if ref_t not in types_sec or ref_c not in types_sec[ref_t]:
                                    errors.append(YAML_result(db_name, "types", "broken_reference", 1, f"Value '{val}' in {table_name}.{col_name} references non-existent table or column in types"))


    
    
    if "types" in data:
        errors  += iterate_types(db_name, data["types"], includes)


    if "schema" in data:
        errors  += iterate_schemas(db_name, data["schema"], types_sec)
    
    if "generate" in data:
        generate = data["generate"]
        errors  += validate_generate(db_name, generate, types_sec)
        errors  += validate_seq(db_name, generate, types_sec)

    if "constraints" in data:
        errors += validate_constraints(db_name, data["constraints"], types_sec)
    
    if all(result.severity != 1 for result in errors):
        save_yaml(yaml_str, db_name)
    else:
        logger_setup.logger.error(f"Found critical error(s)")    

    return errors

def validate_seq(db_name, generate, types) -> list[YAML_result]:
    errors = []

    if types is None:
        return []

    for part in generate:
        if "=" not in part:
            continue

        part_split = part.split("=")
        gen_name = part_split[0].strip()

        if gen_name not in types:
            logger_setup.logger.error(f"Generate tried to generate part {part_split} not included in TYPES section")
            errors.append(YAML_result(db_name, "generate", "invalid_generate", 1, f"Generate tried to generate part {part_split} not included in TYPES section"))
            continue

        if not isinstance(types[gen_name], dict):
            logger_setup.logger.error(f"Expected dict for table types got {type(types[gen_name])}")
            errors.append(YAML_result(db_name, "types", "invalid_types", 1, f"Expected dict for table types got {type(types[gen_name])}"))
            continue

        types_value = list(types[gen_name].values())
        
        for value in types_value:

            value = str(value)
        
            if not value.startswith("seq"):
                continue

            nums = re.findall(r"[-+]?\d+", value)

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
                logger_setup.logger.error(f"Generate or Seq expected number: generate = {part_split[1]} seq = {value}")
                errors.append(YAML_result(db_name, "generate", "invalid_generate", 1, f"Generate or Seq expected number: generate = {part_split[1]} seq = {value}"))
                continue

            if gen_num > seq_len:
                logger_setup.logger.error(f"Number of generate for {part_split[0]} > seq len: seq_len {seq_len} generate: {part_split[1]}")
                errors.append(YAML_result(db_name, "generate", "invalid_generate", 1, f"Number of generate for {part_split[0]} > seq len: seq_len {seq_len} generate: {part_split[1]}"))

    return errors
    
    
def check_param(db_name, value) -> list[YAML_result]:
    errors = []
    value_split = re.split(r"\s*[\(\),]\s*", value)

    function_name = value_split[0]
    args = value_split[1:]

    if function_name == "regex":
        try:
            if not args or not args[0].strip():
                raise IndexError
            
            regex_pattern = args[0].strip("'\"")

            re.compile(regex_pattern)
        
        except (re.error, IndexError):
            logger_setup.logger.error(f"Invalid regex pattern inside regex. Got: {args}")
            errors.append(YAML_result(db_name, "types", "invalid_types", 1, f"Invalid regex pattern inside regex. Got: {args}" ))
            return errors

    elif function_name == "interval":
        try:
            if "." in [args[0], args[1]]:
                raise ValueError
            
            value1 = int(args[0])
            value2 = int(args[1])
        except (ValueError, IndexError):
            errors.append(YAML_result(db_name, "types", "invalid_types", 1, f"Interval expects two integers. Instead got {args}"))
            return errors
        if value1 >= value2:
            errors.append(YAML_result(db_name, "types", "invalid_types", 1, "Min value of interval exceed the max value"))
        
    elif function_name == "finterval":
        try:
            value1 = float(args[0])
            value2 = float(args[1])
        except (ValueError, IndexError):
            errors.append(YAML_result(db_name, "types", "invalid_types", 1, f"Finterval expects two floats. Instead got {args}"))
            return errors
        
        if value1 >= value2:
            errors.append(YAML_result(db_name, "types", "invalid_types", 1, "Min value of finterval exceed the max value"))
    
    elif function_name == "seq":
        try:
            value1 = int(args[0])
            value2 = int(args[1])
            value3 = int(args[2]) if len(args) > 2 else 1
        except (ValueError, IndexError):
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
            
            min_re = re.search(r"(\d+)\s*$", min_val)
            if not min_re:
                raise ValueError
            
            value1 = int(min_re.group(1))


            if not max_val:
                if value1 < 0:
                    errors.append(YAML_result(db_name, "types", "invalid_types", 1, f"Invalid value inside str_len. Got {args}"))

            else:
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

def validate_types(db_name, each_type: dict, includes) -> list[YAML_result]:
    errors                   = []
    basic_types: list[str]   = ["int", "bool", "string", "float", "bigint"]
    param_types: list[str]   = ["seq", "interval", "dinterval", "finterval", "str_len", "regex"]
    dataset_types: list[str] = includes

    if not isinstance(each_type, dict): 
        logger_setup.logger.error(f"Expected dict for table types got {type(each_type)}")
        errors.append(YAML_result(db_name, "types", "invalid_types", 1, f"Expected dict for table types got {type(each_type)}"))
        return errors
    
    for column_name, value in each_type.items():
        if value is None:
            logger_setup.logger.error(f"Column {column_name} has null type")
            errors.append(YAML_result(db_name, "types", "invalid_types", 1, f"Column {column_name} has null type"))
            continue

        if isinstance(value, (list, dict)):
            continue
        
        if not isinstance(value, str):
            logger_setup.logger.error(f"Invalid type format for column '{column_name}': (expected string, got {type(value)})")
            errors.append(YAML_result(db_name, "types", "invalid_types", 1, f"Invalid type format for column '{column_name}': (expected string, got {type(value)})"))
            continue
            
        if value in basic_types:
            continue
    
        elif any(value.startswith(whatever) for whatever in param_types):
            errors += check_param(db_name, value)
            continue
        

        elif value in dataset_types:
            continue
        else:
            logger_setup.logger.error(f"Unknown type {value} for column {column_name}")
            errors.append(YAML_result(db_name, "types", "invalid_types", 1, f"Unknown type {value} for column {column_name}"))

    return errors


def iterate_types(db_name, types: dict, includes) -> list[YAML_result]:
    errors = []

    if types is None:
        return []
    
    if not isinstance(types, dict):
        logger_setup.logger.error(f"Expected dict for table types got {type(types)}")
        errors.append(YAML_result(db_name, "types", "invalid_types", 1, f"Expected dict for table types got {type(types)}"))
        return errors
    
    list_of_types: list[str] = list(types.keys())
    for part in list_of_types:
        if not isinstance(types[part], list):
            errors += validate_types(db_name, types[part], includes)

    return errors


def validate_schema(db_name, each_schema: dict, types_sec) -> list[YAML_result]:
    errors = []

    if types_sec is None:
        return []
    
    if not isinstance(each_schema, dict): 
        logger_setup.logger.error(f" 3 Expected dict for table types got {type(each_schema)}")
        errors.append(YAML_result(db_name, "schema", "invalid_schema", 1, f"Expected dict for table types got {type(each_schema)}"))
        return errors

    for column_name, value in each_schema.items():

        if value is None:
            logger_setup.logger.error(f"Schema column {column_name} contains null value")
            errors.append(YAML_result(db_name, "schema", "invalid_schema", 1, f"Schema column {column_name} contains null value"))
            continue

        if isinstance(value, str) and value.startswith("FROM "):
            target = value.replace("FROM ", "").strip("'\"")
            split_target = target.split(".")

            if len(split_target) != 2:
                logger_setup.logger.error(f"Wrong FROM format {value} for column {column_name}")
                errors.append(YAML_result(db_name, "schema", "invalid_schema", 1, f"Wrong FROM format {value} for column {column_name}"))
                continue

            target_table, target_column = split_target[0], split_target[1]

            if target_table not in types_sec or target_column not in types_sec[target_table]:
                logger_setup.logger.error(f"Trying to get FROM with non existent value {target_table}.{target_column}")
                errors.append(YAML_result(db_name, "schema", "invalid_schema", 1, f"Trying to get FROM with non existent value {target_table}.{target_column}"))
            continue

        if isinstance(value, (list, dict)):
            continue

        if not isinstance(value, str):
            logger_setup.logger.error(f"Invalid schema format for column '{column_name}': {value} (expected string, got {type(value)})")
            errors.append(YAML_result(db_name, "schema", "invalid_schema", 1, f"Invalid schema format for column '{column_name}': {value} (expected string, got {type(value)})"))
            continue

        split_fiction = value.split(".")

        if len(split_fiction) != 2:
            logger_setup.logger.error(f"Invalid schema reference format {value} for column '{column_name}' (expected table.column)")
            errors.append(YAML_result(db_name, "schema", "invalid_schema", 1, f"Invalid schema reference format {value} for column '{column_name}' (expected table.column)"))
            continue
            
        table_ref = split_fiction[0]
        col_ref   = split_fiction[1]

        if table_ref not in types_sec:
            logger_setup.logger.warning(f"Unknown table reference {table_ref} in schema for column {column_name}")
            errors.append(YAML_result(db_name, "schema", "invalid_schema", 1, f"Unknown table reference {table_ref} in schema for column {column_name}"))
            continue
        
        if col_ref not in types_sec[table_ref]:
            logger_setup.logger.error(f"Unknown column reference {col_ref} in schema for column {column_name}")
            errors.append(YAML_result(db_name, "schema", "invalid_schema", 1, f"Unknown column reference {col_ref} in schema for column {column_name}"))
            continue

    return errors

def iterate_schemas(db_name, schema: dict, types_sec) -> list[YAML_result]:
    errors = []

    if types_sec is None:
        return []
    
    if not isinstance(schema, dict):
        logger_setup.logger.error(f"4 SCHEMA = {schema} \n Expected dict  got {type(schema)}")
        errors.append(YAML_result(db_name, "schema", "invalid_schema", 1, f"Expected dict for table types got {type(schema)}"))
        return errors
    
    list_of_schemas: list[dict[str, str]] = list(schema.keys()) 
    for part in list_of_schemas:
        errors += validate_schema(db_name, schema[part], types_sec)

    return errors


def validate_generate(db_name, generate: dict, types_sec) -> list[YAML_result]:
    
    errors = []
    
    if types_sec is None:
        return []
    
    if not isinstance(generate, list): 
        logger_setup.logger.error(f"Expected list for table types got {type(generate)}")
        errors.append(YAML_result(db_name, "generate", "invalid_generate", 1, f"Expected list for table types got {type(generate)}"))
        return errors
    
    for value in generate:

        if not isinstance(value, str):
            logger_setup.logger.error(f"Invalid type format in generate section {value} (expected string)")
            errors.append(YAML_result(db_name, "generate", "invalid_generate", 1, f"Invalid type format in generate section {value} (expected string)"))
            continue

        value = value.strip()
        if not value:
            errors.append(YAML_result(db_name, "generate", "invalid_generate", 1, "Generate section contains an empty row"))
            continue

        if "=" not in value:
            logger_setup.logger.error(f"Value is missing = operator {value}")
            errors.append(YAML_result(db_name, "generate", "invalid_generate", 1, f"Value is missing = operator {value}"))
            continue

        split_generate = value.split("=", 1)
        table_name     = split_generate[0].strip()
        count          = split_generate[1].strip()

        if table_name not in types_sec:
            logger_setup.logger.error(f"Unknown table reference {table_name} in generate section")
            errors.append(YAML_result(db_name, "generate", "invalid_generate", 1, f"Unknown table reference {table_name} in generate section"))
            continue

        if not count.isdigit() and count.lower() != "auto":
            logger_setup.logger.error(f"Invalid count value {count} for table {table_name} (expected digits or auto)")
            errors.append(YAML_result(db_name, "generate", "invalid_generate", 1, f"Invalid count value {count} for table {table_name} (expected digits or auto)"))
            continue

    return errors

def validate_include(db_name, includes: str) -> list[YAML_result]:
    errors = []

    invalid_includes = [value for value in includes if value not in AVAILABLE_INCLUDES]
    if invalid_includes:
        logger_setup.logger.error(f"{invalid_includes} not part of available includes {AVAILABLE_INCLUDES}")
        errors.append(YAML_result(db_name, "include", "invalid_include", 1, f"{invalid_includes} not part of available includes {AVAILABLE_INCLUDES}"))

    return errors



def validate_in(db_name, constraints, typename, types_sec):
    errors = []
    typename_parts = typename.split(".")

    if len(typename_parts) != 2 or typename_parts[0] not in types_sec or typename_parts[1] not in types_sec[typename_parts[0]]:
        logger_setup.logger.error(f"Invalid 'in' constraint (type does not exist): {typename}")
        errors.append(YAML_result(db_name, "constraints", "invalid_constraint", 2, f"Constraint type does not exist in types section, {typename}"))
        return errors

    actual_type = types_sec[typename_parts[0]][typename_parts[1]]

    if isinstance(actual_type, list):
        return errors
    
    if not isinstance(actual_type, str) or not (actual_type.startswith("enum") or "BLOCKS" in actual_type):
        logger_setup.logger.error(f"Invalid type for 'in' operator: {typename} is {actual_type}. Expected enum or BLOCKS.")
        errors.append(YAML_result(db_name, "constraints", "invalid_constraint", 2, f"Invalid type for 'in' operator: {typename} is {actual_type}."))
        return errors
    
    return errors


def validate_rel_result(db_name, constraint, con_split, types_sec):
    errors = []
    

    typename = con_split[0].split(".")
    if len(typename) < 2:
        logger_setup.logger.error(f"Malformed constraint column format (missing dot): {constraint}")
        errors.append(YAML_result(db_name, "constraints", "invalid_constraint", 1, f"Malformed constraint target: {constraint}"))
        return errors

    table_name  = typename[0]
    column_name = typename[1] 
    operator    = con_split[1]
    value       = str(con_split[2]).strip() 


    if table_name not in types_sec:
        logger_setup.logger.error(f"Invalid constraint: table '{table_name}' not found in types section.")
        errors.append(YAML_result(db_name, "constraints", "invalid_constraint", 1, f"Invalid constraint {constraint}"))
        return errors

    if operator not in ["=", "!=", "<", ">", "<=", ">="]:
        logger_setup.logger.error(f"Invalid operator {operator}: {constraint}")
        errors.append(YAML_result(db_name, "constraints", "invalid_constraint", 1, f"Invalid constraint {constraint}"))
        return errors

    num_pattern = r"^[-+]?\d+(?:\.\d+)?$"
    is_num      = bool(re.match(num_pattern, value))
    value_split = value.split(".") if ("." in value and not is_num) else []


    if not is_num and not value_split:
        logger_setup.logger.error(f"Invalid constraint value (neither number nor column reference): {constraint}")
        errors.append(YAML_result(db_name, "constraints", "invalid_constraint", 1, f"Invalid constraint value: {constraint}"))
        return errors
     
 
    if column_name not in types_sec[table_name]:
        logger_setup.logger.error(f"Constraint column {column_name} does not exist in types section")
        errors.append(YAML_result(db_name, "constraints", "invalid_constraint", 2, f"Constraint column {column_name} does not exist in types section"))
        return errors

    if value_split:
        if len(value_split) != 2:
            logger_setup.logger.error(f"Malformed column reference in constraint value: {value}")
            errors.append(YAML_result(db_name, "constraints", "invalid_constraint", 1, f"Malformed reference: {value}"))
            return errors
            
        val_table = value_split[0]
        val_col   = value_split[1]

        if val_table not in types_sec or val_col not in types_sec[val_table]:
            logger_setup.logger.error(f"Referenced constraint column {val_table}.{val_col} does not exist in types section")
            errors.append(YAML_result(db_name, "constraints", "invalid_constraint", 2, f"Constraint type {val_table}.{val_col} does not exist in types section"))
            return errors
    

    typename_value = types_sec[table_name][column_name]
    
    if not isinstance(typename_value, str):
        errors.append(YAML_result(db_name, "constraints", "invalid_constraints", 1, "Target column type definition is not a string"))
        return errors
    

    is_fk_equality = (operator == "=" and bool(value_split) and not is_num)


    valid_prefixes = ("int", "bigint", "float", "interval", "finterval", "dinterval", "bool")

    if not typename_value.startswith(valid_prefixes):
        severity = 2 if typename_value.startswith("seq") else 1
        if not is_fk_equality:
            logger_setup.logger.error(f"Invalid type of constraint: {table_name}.{column_name} is {typename_value}.")
            errors.append(YAML_result(db_name, "constraints", "invalid_constraint", severity, f"Invalid type of constraint: {table_name}.{column_name} is {typename_value}."))
            return errors

    if not is_fk_equality and value_split:
        value_val = types_sec[value_split[0]][value_split[1]]
        if not value_val.startswith(valid_prefixes):
            severity = 2 if value_val.startswith("seq") else 1
            logger_setup.logger.error(f"Invalid type of constraint: {value} is {value_val}.")
            errors.append(YAML_result(db_name, "constraints", "invalid_constraint", severity, f"Invalid type of constraint: {value} is {value_val}."))
            return errors
    
    return errors

def validate_constraints(db_name, constraints: str, types_sec) -> list[YAML_result]:

    errors = []

    if not constraints or types_sec is None:
        return []
    
    for constraint in constraints:

        constraint = constraint.strip()
        if not constraint:
            continue

        constraint_split = constraint.split(" ", 2)
        if len(constraint_split) >= 3 and constraint_split[1].lower() == "in":
            errors += validate_in(db_name, constraint, constraint_split[0], types_sec)
            continue
        
        constraint_split = constraint.split(" ")

        if len(constraint_split) < 3:
            logger_setup.logger.error(f"Invalid constraint format: {constraint}")
            errors.append(YAML_result(db_name, "constraints","invalid_constraint", 2, f"Invalid constraints format {constraint}"))
            continue

        errors += validate_rel_result(db_name, constraint, constraint_split, types_sec)
        
    return errors

def save_yaml(yaml_string: str, db_name: str):
    with open(f"results/dataster/dataster_config-{db_name}.yaml", "a") as f:
        f.write(yaml_string)
        f.write("\n----------------------------------------------------------------------\n")
    
    logger_setup.logger.info(f"Final yaml saved into results/dataster/dataster_config-{db_name}.yaml")


def save_original_yaml(yaml_string: str, db_name: str):
    with open(f"results/original_yaml/dataster_config-{db_name}.yaml", "a") as f:
        f.write(yaml_string)
        f.write("\n----------------------------------------------------------------------\n")

    logger_setup.logger.info(f"Original yaml saved into results/original_yaml/dataster_config-{db_name}.yaml")


def save_csv(errors: list[YAML_result], db_name: str):
    field_names = ["database", "section", "error_type", "severity", "detail"]

    writer_header = not os.path.exists(f"results/csv/results-{db_name}.csv") or os.path.getsize(f"results/csv/results-{db_name}.csv") == 0

    with open(f"results/csv/results-{db_name}.csv", mode="a", newline="", encoding="utf-8") as file:
        writer = csv.writer(file)
        if writer_header:
            writer.writerow(field_names)

        for error in errors:
            writer.writerow([error.database, error.section, error.error_type, error.severity, error.detail])
        
    
    logger_setup.logger.info(f"Results saved into results/csv/results-{db_name}.csv")