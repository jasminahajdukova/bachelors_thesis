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


### UniqueKeyLoader ###
class UniqueKeyLoader(SafeLoader):
    def construct_mapping(self, node, deep = False):
        mapping = {}
        for key_node, value_node in node.value:
            key = self.construct_object(key_node, deep=deep)
            if key in mapping:
                raise ValueError(f"Duplicit key detected in YAML configuration: {key}")
            mapping[key] = self.construct_object(value_node, deep=deep)
        
        return mapping

### load_yaml ###

def load_yaml(yaml_str, db_name):
    errors = []
    try:
        loaded_yaml = yaml.load(yaml_str, Loader=UniqueKeyLoader)
    except ValueError as ve:
        logger_setup.logger.error(f"YAML Duplicate Error: {str(ve)}")
        errors.append(YAML_result(db_name, "YAML", "invalid_yaml", 1, f"YAML Duplicate Error: {str(ve)}"))
        return None, errors
    except Exception as e:
        logger_setup.logger.error(f"YAML Syntax Error: {str(e)}")
        errors.append(YAML_result(db_name, "YAML", "invalid_yaml", 1, f"YAML Syntax Error: {str(e)}"))
        return None, errors
    
    return loaded_yaml, errors


### check_yaml  ###

def check_yaml(loaded_yaml, db_name):
    # check is loaded YAML is a dictionary
    errors = []
    if not isinstance(loaded_yaml, dict):
        logger_setup.logger.error(f"Expected dict. Got {type(loaded_yaml)}")
        errors.append(YAML_result(db_name, "YAML", "invalid_yaml", 1, f"Expected dict. Got {type(loaded_yaml)}"))
        return errors

    # check if YAML has all mandatory sections
    if not all(section in loaded_yaml for section in ["types", "schema", "generate"]):
        logger_setup.logger.error("YAML contains invalid parts")
        errors.append(YAML_result(db_name, "YAML", "invalid_yaml", 1, "YAML contains invalid parts"))
    
    return errors


### validate_yaml ### 

def validate_yaml(db_name: str, yaml_str: str, samples: dict) -> list[YAML_result]:
    errors = []
    logger_setup.logger.warning(f"Validating YAML for database: {db_name}")
    
    # loads YAML
    loaded_yaml, errors = load_yaml(yaml_str, db_name)
    if loaded_yaml is None:
        return errors
    
    # checks yaml type and if it containts all necessarry sections
    errors += check_yaml(loaded_yaml, db_name) 
    if any(result.severity == 1 for result in errors):
        return errors
    
    # checks if includes exist in yaml and validates it
    includes      = []
    types_section = {}
    if "include" in loaded_yaml:
        includes = loaded_yaml["include"]
        errors  += validate_include(db_name, loaded_yaml["include"])   

    # checks if types exists in yaml
    if "types" in loaded_yaml:
        types_section = loaded_yaml["types"] 
        # checks existance of tables inside types + BLOCKS + format/values
        errors  += check_types(db_name, types_section, samples)
        # goes over types and checks certain data types
        errors  += iterate_types(db_name, types_section, includes)

    # checks if schema exists in yaml
    if "schema" in loaded_yaml:
        schema_section = loaded_yaml["schema"]
        # goes over schema and checks if types and columns inside tables match
        errors  += iterate_schemas(db_name, schema_section, types_section)
    
    # checks if generate exists in yaml
    if "generate" in loaded_yaml:
        generate_section = loaded_yaml["generate"]
        # kontrola
        errors  += validate_generate(db_name, generate_section, types_section)
        # checks if numbers inside seq match number if generate table
        errors  += validate_seq(db_name, generate_section, types_section)

    # checks if constraints exists in yaml and validates constraints
    if "constraints" in loaded_yaml:
        constraints_section = loaded_yaml["constraints"]
        errors += validate_constraints(db_name, constraints_section, types_section)
    
    # if no major errors occured during the validation -> yaml is saved
    if all(result.severity != 1 for result in errors):
        save_yaml(yaml_str, db_name)
    else:
        logger_setup.logger.error(f"Found critical error(s)")    

    return errors


### check_types ###

def check_types(db_name, types_section, samples):

    err = []

    if not isinstance(types_section, dict):
        logger_setup.logger.error(f"Section 'types' is not a dictionary. Got {type(types_section)}")
        err.append(YAML_result(db_name, "types", "invalid_types", 1, f"Section 'types' is not a dictionary. Got {type(types_section)}"))
    
    else:
        sample_tables = list(samples.keys())
        generated_tables = list(types_section.keys())

        match = False
        for table in generated_tables:
            if table in sample_tables:
                match = True
                break
        if not match and generated_tables:
            logger_setup.logger.error("Generated tables contain no actual from samples")
            err.append(YAML_result(db_name, "types", "invalid_tables", 1, "Generated tables contain no actual from samples"))


    if isinstance(types_section, dict):

        for table_name, columns in types_section.items():
            if not isinstance(columns, dict):
                continue

            for column_name, column_def in columns.items():

                if isinstance(column_def, list):
                    if not column_def or column_def[0] != "BLOCKS":
                        logger_setup.logger.error(f"List in {table_name}.{column_name} must start with 'BLOCKS'")
                        err.append(YAML_result(db_name, "types", "invalid_types", 1, f"List in {table_name}.{column_name} must start with 'BLOCKS'"))
                    for item in column_def[1:]:
                        if isinstance(item, (list, dict)):
                            logger_setup.logger.error(f"Invalid values inside BLOCKS for {table_name}.{column_name}")
                            err.append(YAML_result(db_name, "types", "invalid_types", 1, f"Invalid values inside BLOCKS for {table_name}.{column_name}"))

                elif isinstance(column_def, str):
                    if column_def in ["format", "value"]:
                        continue
                    val_clean = column_def.strip().strip("'\"")
                    if (val_clean.lower() not in ["string", "blocks"] and val_clean not in AVAILABLE_INCLUDES and "(" not in val_clean):
                        logger_setup.logger.error(f"Invalid type {val_clean} in {table_name}.{column_def}")
            
                elif isinstance(column_def, dict):
                    keys = []
                    for key in column_def.keys():
                        if key not in keys:
                            keys.append(key)
                    keys.sort()
                    if keys != ["format", "values"]:
                        logger_setup.logger.error(f"Format structure {table_name}.{column_name} must have format and values")
                        err.append(YAML_result(db_name, "types", "invalid_types", 1, f"Format structure {table_name}.{column_name} must have format and values"))
                        continue
                    
                    format_str = column_def["format"]
                    values = column_def["values"]
                    
                    if not isinstance(format_str, str) or not isinstance(values, list):
                        logger_setup.logger.error(f"Invalid types for format (str) or values (list) in {table_name}.{column_name}")
                        err.append(YAML_result(db_name, "types", "invalid_types", 1, f"Invalid types for format (str) or values (list) in {table_name}.{column_name}"))
                        continue
                    
                        
                    format_count = len(re.findall(r'\{\}', format_str))
                    if format_count != len(values):
                        logger_setup.logger.error(f"Wrong number of {{}} in {table_name}.{column_name}: format has {format_count} {{}} but values has {len(values)}")
                        err.append(YAML_result(db_name, "types", "invalid_types", 1, f"Wrong number of {{}} in {table_name}.{column_name}: format has {format_count} {{}} but values has {len(values)}"))
                    
                
                    for value in values:
                        if not isinstance(value, str):
                            logger_setup.logger.error(f"Wrong type for Value inside {table_name}.{column_name}. Got {type(value)}")
                            err.append(YAML_result(db_name, "types", "invalid_types", 1, f"Wrong type for Value inside {table_name}.{column_name}. Got {type(value)}"))
                            continue
                        
        
                        if value not in AVAILABLE_INCLUDES:
                            if "." not in value:
                                logger_setup.logger.error(f"Wrong type of Value '{value}' inside {table_name}.{column_name}. Got {type(value)}")
                                err.append(YAML_result(db_name, "types", "invalid_types", 1, f"Wrong type of Value '{value}' inside {table_name}.{column_name}. Got {type(value)}"))
                            
                            else:
                                table_ref, column_ref = value.split(".", 1)
                                if table_ref not in types_section or column_ref not in types_section[table_ref]:
                                    logger_setup.logger.error(f"Wrong table reference in Value '{value}' iniside {table_name}.{column_name}")
                                    err.append(YAML_result(db_name, "types", "invalid_types", 1, f"Wrong table reference in Value '{value}' iniside {table_name}.{column_name}"))

    return err


### validate_seq ###

def validate_seq(db_name, generate, types) -> list[YAML_result]:
    errors = []

    if types is None:
        return []

    for part in generate:
        # if part does not include = -> skip
        if "=" not in part:
            continue

        part_split = part.split("=")
        table_name = part_split[0].strip()

        # checks if table exists
        if table_name not in types:
            logger_setup.logger.error(f"Generate tried to generate part {part_split} not included in TYPES section")
            errors.append(YAML_result(db_name, "generate", "invalid_generate", 1, f"Generate tried to generate part {part_split} not included in TYPES section"))
            continue

        # checks if dict
        if not isinstance(types[table_name], dict):
            logger_setup.logger.error(f"Expected dict for table types got {type(types[table_name])}")
            errors.append(YAML_result(db_name, "types", "invalid_types", 1, f"Expected dict for table types got {type(types[table_name])}"))
            continue
        
        # gets values
        types_value = list(types[table_name].values())
        
        # goes over extracted values
        for value in types_value:

            value = str(value)

            # if it does not start with seq -> skip
            if not value.startswith("seq"):
                continue

            # with help of re get all numbers inside seq
            nums = re.findall(r"[-+]?\d+", value)

            try:
                if len(nums) >= 2:
                    # get number for generating
                    gen_num = int(part_split[1].strip())
                    # convert numbers inside seq to int
                    min_num = int(nums[0])
                    max_num = int(nums[1])
                    step    = int(nums[2]) if len(nums) >=3 else 1
                    # count how many numbers inside seq
                    seq_len = (max_num - min_num) // step + 1
                else:
                    raise ValueError
                
            except (ValueError, IndexError, ZeroDivisionError):
                logger_setup.logger.error(f"Generate or Seq expected number: generate = {part_split[1]} seq = {value}")
                errors.append(YAML_result(db_name, "generate", "invalid_generate", 1, f"Generate or Seq expected number: generate = {part_split[1]} seq = {value}"))
                continue
            
            # if number inside generate is higher this would cause an error inside dataster -> huge error HUGE
            if gen_num > seq_len:
                logger_setup.logger.error(f"Number of generate for {part_split[0]} > seq len: seq_len {seq_len} generate: {part_split[1]}")
                errors.append(YAML_result(db_name, "generate", "invalid_generate", 1, f"Number of generate for {part_split[0]} > seq len: seq_len {seq_len} generate: {part_split[1]}"))

    return errors


### check_param ###    
    
def check_param(db_name, value) -> list[YAML_result]:
    errors = []
    # splits value by commas and brackets
    value_split = re.split(r"\s*[\(\),]\s*", value)

    # sets function name and args
    function_name = value_split[0]
    args = value_split[1:]
    args = [arg for arg in args if arg.strip()]

    if function_name == "regex":
        try:
            # checks if at if there is at least one arg
            if not args or not args[0].strip():
                raise IndexError
            
            #removes quotes from pattern
            regex_pattern = args[0].strip("'\"")

            #validates pattern -> in case its wrong an error is thrown
            re.compile(regex_pattern)
        
        except (re.error, IndexError):
            logger_setup.logger.error(f"Invalid regex pattern inside regex. Got: {args}")
            errors.append(YAML_result(db_name, "types", "invalid_types", 1, f"Invalid regex pattern inside regex. Got: {args}" ))
            return errors

    # interval(min, max)
    elif function_name == "interval":
        # get all arguments and skip " " 
        
        if len(args) != 2:
            logger_setup.logger.error(f"Interval got more arguments than expected. Got {len(args)}: {args}. Expected 2.")
            errors.append(YAML_result(db_name, "types", "invalid_types", 1, f"Interval got more arguments than expected. Got {len(args)}: {args}. Expected 2.")) 
        try:
            # checks if its a float or table.column
            if any("." in str(arg) for arg in  args):
                logger_setup.logger.error(f"Interval contains float: {args}")
                errors.append(YAML_result(db_name, "types", "invalid_types", 1, f"Interval contains float: {args}"))
                return errors
            
            # converts to int -> error is thrown if it cannot be converted
            value1 = int(args[0])
            value2 = int(args[1])
        except (ValueError, IndexError):
            logger_setup.logger.error(f"Interval expects two integers. Instead got {args}")
            errors.append(YAML_result(db_name, "types", "invalid_types", 1, f"Interval expects two integers. Instead got {args}"))
            return errors
        
        # in case interval(min, max), where min is greater than max
        if value1 >= value2:
            logger_setup.logger.error("Min value of interval exceeds the max value")
            errors.append(YAML_result(db_name, "types", "invalid_types", 1, "Min value of interval exceeds the max value"))

    # finterval(min, max)
    elif function_name == "finterval":
        if len(args) != 2:
            logger_setup.logger.error(f"Finterval got more arguments than expected. Got {len(args)}: {args}. Expected 2.")
            errors.append(YAML_result(db_name, "types", "invalid_types", 1, f"Finterval got more arguments than expected. Got {len(args)}: {args}. Expected 2.")) 
        try:
            # converts to float -> error is thrown if it cannot be converted
            value1 = float(args[0])
            value2 = float(args[1])
        except (ValueError, IndexError):
            errors.append(YAML_result(db_name, "types", "invalid_types", 1, f"Finterval expects two floats. Instead got {args}"))
            return errors
        
        # in case finterval(min, max), where min is greater than max
        if value1 >= value2:
            errors.append(YAML_result(db_name, "types", "invalid_types", 1, "Min value of finterval exceeds the max value"))
    
    # seq(min, max, step)
    elif function_name == "seq":
        if len(args) != 3:
            logger_setup.logger.error(f"Seq got more arguments than expected. Got {len(args)}: {args}. Expected 3.")
            errors.append(YAML_result(db_name, "types", "invalid_types", 1, f"Seq got more arguments than expected. Got {len(args)}: {args}. Expected 3.")) 
        try:
            # converts to int -> error is thrown if it cannot be converted
            value1 = int(args[0])
            value2 = int(args[1])
            value3 = int(args[2]) if len(args) > 2 else 1
        except (ValueError, IndexError):
            errors.append(YAML_result(db_name, "types", "invalid_types", 1, f"Seq expects three integers. Instead got {args}"))
            return errors
        # in case seq(min, max, step), where min is greater than max or step is a negative number
        if value1 >= value2 or value3 <= 0:
            errors.append(YAML_result(db_name, "types", "invalid_types", 1, f"Invalid value inside seq(x,y,z). Got {args}"))

    #str_len([...] min, max)
    elif function_name == "str_len":
        if len(args) < 1 or len(args) > 2:
            logger_setup.logger.error(f"Str_len got more arguments than expected. Got {len(args)}: {args}. Expected 2.")
            errors.append(YAML_result(db_name, "types", "invalid_types", 1, f"Str_len got more arguments than expected. Got {len(args)}: {args}. Expected 2.")) 
            return errors
        
        try:
            bracket_match = re.search(r"\[(.*?)\]", args[0])

            if bracket_match:
                categories = bracket_match.group(1)
                if re.search(r"[^cCsSd]", categories):
                    raise ValueError(f"Invalid chars inside categoru inside []. Only c, C, d, s, S allowed")


            min_clean = re.sub(r"\[.*?\]", "", args[0])
            min_clean = re.sub(r"[><=]", "", min_clean)
            min_clean = min_clean.strip()

            if not min_clean.isdigit():
                raise ValueError(f"Min values inside str_len must be a positive integer. Got {min_clean}")
            # extracts value if args empty -> both values also empty (error)
            min_val = min_clean
            max_val = ""
            
            if len(args) == 2:

                if re.search(r"[<>=]", args[0]):
                    raise ValueError(f"Operators >, <, >=, <= are not allowed inside str_len with min, max values")

                max_val = args[1].strip() 

                if not max_val.isdigit():
                    raise ValueError(f"Second value of str_len must be a positive integer. Got {max_val}")
                
            
            if max_val != "" and (int(min_val) > int(max_val)):
                raise ValueError(f"Min value: {min_val} of str_len is greater than max value: {max_val}")

        except ValueError as ve:
            logger_setup.logger.error(f"Invalid str_len value. Got {args}: {ve}")
            errors.append(YAML_result(db_name, "types", "invalid_types", 1, f"Invalid str_len value. Got {args}: {ve}"))
            return errors
        
        
    #dinterval(min, max)
    elif function_name == "dinterval":
        if len(args) != 2:
            logger_setup.logger.error(f"Dinterval got more arguments than expected. Got {len(args)}: {args}. Expected 2.")
            errors.append(YAML_result(db_name, "types", "invalid_types", 1, f"Dinterval got more arguments than expected. Got {len(args)}: {args}. Expected 2.")) 
        try:
            # convert to date
            date1 = datetime.strptime(args[0].strip("'"), "%Y-%m-%d")
            date2 = datetime.strptime(args[1].strip("'"),"%Y-%m-%d")
        except ValueError:
            errors.append(YAML_result(db_name, "types", "invalid_types", 1, f"Invalid value inside dinterval. Got {args}"))
            return errors
        # if first date is later than the second date or the same date
        if date1 >= date2:
            errors.append(YAML_result(db_name, "types", "invalid_types", 1, f"Invalid value inside dinterval. Got {args}"))

    return errors

### validate_types ###

def validate_types(db_name, each_type: dict, includes) -> list[YAML_result]:
    errors                     = []
    # types without parameters
    basic_types: list[str]     = ["int", "bool", "string", "float", "bigint"]
    # types with parameters
    param_types: list[str]     = ["seq", "interval", "dinterval", "finterval", "str_len", "regex"]
    loaded_includes: list[str] = includes

    # check if each_type is correct type
    if not isinstance(each_type, dict): 
        logger_setup.logger.error(f"Expected dict for table types got {type(each_type)}")
        errors.append(YAML_result(db_name, "types", "invalid_types", 1, f"Expected dict for table types got {type(each_type)}"))
        return errors
    
    for column_name, value in each_type.items():
        # if some have value has no value inside -> error
        if value is None:
            logger_setup.logger.error(f"Column {column_name} has null type")
            errors.append(YAML_result(db_name, "types", "invalid_types", 1, f"Column {column_name} has null type"))
            continue

        # skip this check -> this check happens in check_types
        if isinstance(value, (list, dict)):
            continue
        
        # if something else than list, dict, or str -> error
        if not isinstance(value, str):
            logger_setup.logger.error(f"Invalid type format for column '{column_name}': (expected string, got {type(value)})")
            errors.append(YAML_result(db_name, "types", "invalid_types", 1, f"Invalid type format for column '{column_name}': (expected string, got {type(value)})"))
            continue
        
        # this is okay (valid type) -> move on
        if value in basic_types:
            continue
        
        # if it part of types with parameters -> go over and check it
        elif any(value.startswith(param) for param in param_types):
            errors += check_param(db_name, value)
            continue
        
        # if part of includes -> ok
        elif value in loaded_includes:
            continue

        # if anything else -> unknown type
        else:
            logger_setup.logger.error(f"Unknown type {value} for column {column_name}")
            errors.append(YAML_result(db_name, "types", "invalid_types", 1, f"Unknown type {value} for column {column_name}"))

    return errors

### iterate_types ###
def iterate_types(db_name, types: dict, includes) -> list[YAML_result]:
    errors = []

    # if types empty
    if types is None:
        return []
    
    for table_name, table_content in types.items():

        # checks if table content is dict
        if not isinstance(table_content, dict):
            logger_setup.logger.error(f"Expected dict for table types got {type(types)}")
            errors.append(YAML_result(db_name, "types", "invalid_types", 1, f"Expected dict for table {table_name} content. Got {type(table_content)}"))
            return errors
    
        # sends table content for validation
        errors += validate_types(db_name, table_content, includes)

    return errors

### validate_schema ###
def validate_schema(db_name, each_schema: dict, types_section) -> list[YAML_result]:
    errors = []

    if types_section is None:
        return []
    
    if not isinstance(each_schema, dict): 
        logger_setup.logger.error(f" 3 Expected dict for table types got {type(each_schema)}")
        errors.append(YAML_result(db_name, "schema", "invalid_schema", 1, f"Expected dict for table types got {type(each_schema)}"))
        return errors

    # go over schema
    for column_name, value in each_schema.items():

        # if value empty -> error
        if value is None:
            logger_setup.logger.error(f"Schema column {column_name} contains null value")
            errors.append(YAML_result(db_name, "schema", "invalid_schema", 1, f"Schema column {column_name} contains null value"))
            continue
        
        # if foreign key reference
        if isinstance(value, str) and value.startswith("FROM "):
            # remomve FROM an quotes
            target = value.replace("FROM ", "").strip("'\"")
            # split referenced value
            split_target = target.split(".")

            # if not format table.column -> error
            if len(split_target) != 2:
                logger_setup.logger.error(f"Wrong FROM format {value} for column {column_name}")
                errors.append(YAML_result(db_name, "schema", "invalid_schema", 1, f"Wrong FROM format {value} for column {column_name}"))
                continue
            

            target_table, target_column = split_target[0], split_target[1]
            # check if table name is in types and that column also exits in referenced table
            if target_table not in types_section or target_column not in types_section[target_table]:
                logger_setup.logger.error(f"Trying to get FROM with non existent value {target_table}.{target_column}")
                errors.append(YAML_result(db_name, "schema", "invalid_schema", 1, f"Trying to get FROM with non existent value {target_table}.{target_column}"))
            continue

        if isinstance(value, (list, dict)):
            continue
        
        # if not str, list or dict -> error
        if not isinstance(value, str):
            logger_setup.logger.error(f"Invalid schema format for column '{column_name}': {value} (expected string, got {type(value)})")
            errors.append(YAML_result(db_name, "schema", "invalid_schema", 1, f"Invalid schema format for column '{column_name}': {value} (expected string, got {type(value)})"))
            continue

        split_fiction = value.split(".")

        # if not format table.column
        if len(split_fiction) != 2:
            logger_setup.logger.error(f"Invalid schema reference format {value} for column '{column_name}' (expected table.column)")
            errors.append(YAML_result(db_name, "schema", "invalid_schema", 1, f"Invalid schema reference format {value} for column '{column_name}' (expected table.column)"))
            continue
            
        table_ref    = split_fiction[0]
        column_ref   = split_fiction[1]
        # checks if table exits
        if table_ref not in types_section:
            logger_setup.logger.warning(f"Unknown table reference {table_ref} in schema for column {column_name}")
            errors.append(YAML_result(db_name, "schema", "invalid_schema", 1, f"Unknown table reference {table_ref} in schema for column {column_name}"))
            continue
        # checks if column exists
        if column_ref not in types_section[table_ref]:
            logger_setup.logger.error(f"Unknown column reference {column_ref} in schema for column {column_name}")
            errors.append(YAML_result(db_name, "schema", "invalid_schema", 1, f"Unknown column reference {column_ref} in schema for column {column_name}"))
            continue

    return errors

### iterate_schemas ###
def iterate_schemas(db_name, schema: dict, types_section) -> list[YAML_result]:
    errors = []

    if types_section is None:
        return []
    
    if not isinstance(schema, dict):
        logger_setup.logger.error(f"4 SCHEMA = {schema} \n Expected dict  got {type(schema)}")
        errors.append(YAML_result(db_name, "schema", "invalid_schema", 1, f"Expected dict for table types got {type(schema)}"))
        return errors
    
    for table_name, table_content in schema.items():

        # checks if table content is dict
        if not isinstance(table_content, dict):
            logger_setup.logger.error(f"Expected dict for table types got {type(schema)}")
            errors.append(YAML_result(db_name, "types", "invalid_types", 1, f"Expected dict for table {table_name} content. Got {type(table_content)}"))
            return errors
    
        # sends table content for validation
        errors += validate_schema(db_name, table_content, types_section)
    
    return errors

### validate_generate ###

def validate_generate(db_name, generate: list, types_section) -> list[YAML_result]:
    
    errors = []
    
    if types_section is None:
        return []
    
    if not isinstance(generate, list): 
        logger_setup.logger.error(f"Expected list for generate section got {type(generate)}")
        errors.append(YAML_result(db_name, "generate", "invalid_generate", 1, f"Expected list for generate section types got {type(generate)}"))
        return errors
    
    for value in generate:
        # if not str
        if not isinstance(value, str):
            logger_setup.logger.error(f"Invalid type format in generate section {value} (expected string)")
            errors.append(YAML_result(db_name, "generate", "invalid_generate", 1, f"Invalid type format in generate section {value} (expected string)"))
            continue

        value = value.strip()
        # if empty row in generate
        if not value:
            errors.append(YAML_result(db_name, "generate", "invalid_generate", 1, "Generate section contains an empty row"))
            continue
        
        # if = missing inside generate, error is noted and moves on
        if "=" not in value:
            logger_setup.logger.error(f"Value is missing = operator {value}")
            errors.append(YAML_result(db_name, "generate", "invalid_generate", 1, f"Value is missing = operator {value}"))
            continue

        # split value into to table_name = int -> [table_name, int]
        split_generate = value.split("=", 1)
        table_name     = split_generate[0].strip()
        count          = split_generate[1].strip()

        # checks if table exists 
        if table_name not in types_section:
            logger_setup.logger.error(f"Unknown table reference {table_name} in generate section")
            errors.append(YAML_result(db_name, "generate", "invalid_generate", 1, f"Unknown table reference {table_name} in generate section"))
            continue
        
        # checks if number for generate is a digit or auto
        if not count.isdigit() and count.lower() != "auto":
            logger_setup.logger.error(f"Invalid count value {count} for table {table_name} (expected digits or auto)")
            errors.append(YAML_result(db_name, "generate", "invalid_generate", 1, f"Invalid count value {count} for table {table_name} (expected digits or auto)"))
            continue

    return errors

def validate_include(db_name, includes: list[str]) -> list[YAML_result]:
    errors = []

    # checks if there are any invalid includes
    invalid_includes = [value for value in includes if value not in AVAILABLE_INCLUDES]
    if invalid_includes:
        logger_setup.logger.error(f"{invalid_includes} not part of available includes {AVAILABLE_INCLUDES}")
        errors.append(YAML_result(db_name, "include", "invalid_include", 1, f"{invalid_includes} not part of available includes {AVAILABLE_INCLUDES}"))

    return errors



def validate_rel_result(db_name, constraint, con_split, types_section):
    errors = []
    

    typename = con_split[0].split(".")
    # expected table.column
    if len(typename) < 2:
        logger_setup.logger.error(f"Malformed constraint column format (missing dot): {constraint}")
        errors.append(YAML_result(db_name, "constraints", "invalid_constraint", 1, f"Malformed constraint target: {constraint}"))
        return errors
    

    table_name  = typename[0]
    column_name = typename[1] 
    operator    = con_split[1]
    value       = str(con_split[2]).strip() 

    # check if table exists
    if table_name not in types_section:
        logger_setup.logger.error(f"Invalid constraint: table '{table_name}' not found in types section.")
        errors.append(YAML_result(db_name, "constraints", "invalid_constraint", 1, f"Invalid constraint {constraint}"))
        return errors

    #check if operator is valid
    if operator not in ["=", "!=", "<", ">", "<=", ">="]:
        logger_setup.logger.error(f"Invalid operator {operator}: {constraint}")
        errors.append(YAML_result(db_name, "constraints", "invalid_constraint", 1, f"Invalid constraint {constraint}"))
        return errors

    # checks if value is num
    num_pattern = r"^[-+]?\d+(?:\.\d+)?$"
    is_num      = bool(re.match(num_pattern, value))
    # if not its probably another table.column
    value_split = value.split(".") if ("." in value and not is_num) else []

    # if neither num or table.column
    if not is_num and not value_split:
        logger_setup.logger.error(f"Invalid constraint value (neither number nor column reference): {constraint}")
        errors.append(YAML_result(db_name, "constraints", "invalid_constraint", 1, f"Invalid constraint value: {constraint}"))
        return errors
     
    # check if column inside table
    if column_name not in types_section[table_name]:
        logger_setup.logger.error(f"Constraint column {column_name} does not exist in types section")
        errors.append(YAML_result(db_name, "constraints", "invalid_constraint", 2, f"Constraint column {column_name} does not exist in types section"))
        return errors

    # if other value was table.column
    if value_split:
        # but the format is not table.column
        if len(value_split) != 2:
            logger_setup.logger.error(f"Malformed column reference in constraint value: {value}")
            errors.append(YAML_result(db_name, "constraints", "invalid_constraint", 1, f"Malformed reference: {value}"))
            return errors
        
        # get table and column
        val_table = value_split[0]
        val_col   = value_split[1]

        # and check if table exists and column is inside talbe
        if val_table not in types_section or val_col not in types_section[val_table]:
            logger_setup.logger.error(f"Referenced constraint column {val_table}.{val_col} does not exist in types section")
            errors.append(YAML_result(db_name, "constraints", "invalid_constraint", 2, f"Constraint type {val_table}.{val_col} does not exist in types section"))
            return errors
    

    # checks if type is correct
    typename_value = types_section[table_name][column_name]
    
    # if not string -> error
    if not isinstance(typename_value, str):
        errors.append(YAML_result(db_name, "constraints", "invalid_constraints", 1, "Target column type definition is not a string"))
        return errors
    
    # is operator = and right side is not a number --> column equality
    is_column_equality = (operator == "=" and bool(value_split) and not is_num)


    valid_prefixes = ("int", "bigint", "float", "interval", "finterval", "dinterval", "bool")
    # valid types that can be compared
    # checks if left side type has correct data type
    if not typename_value.startswith(valid_prefixes):
        # is seq severity = 2 (as it generates nums)
        severity = 2 if typename_value.startswith("seq") else 1
        # if it is comparison (=) of two columns, then data type can be what ever
        if not is_column_equality:
            logger_setup.logger.error(f"Invalid type of constraint: {table_name}.{column_name} is {typename_value}.")
            errors.append(YAML_result(db_name, "constraints", "invalid_constraint", severity, f"Invalid type of constraint: {table_name}.{column_name} is {typename_value}."))
            return errors

    # if not equality and right side not number
    if not is_column_equality and value_split:
        # get data type from right side
        value_val = types_section[value_split[0]][value_split[1]]
        # if not valid data type
        if not value_val.startswith(valid_prefixes):
            # is seq severity = 2 (as it generates nums)
            severity = 2 if value_val.startswith("seq") else 1

            logger_setup.logger.error(f"Invalid type of constraint: {value} is {value_val}.")
            errors.append(YAML_result(db_name, "constraints", "invalid_constraint", severity, f"Invalid type of constraint: {value} is {value_val}."))
            return errors
    
    return errors

def validate_constraints(db_name, constraints: str, types_section) -> list[YAML_result]:

    errors = []
    supported_op = {"=", "!=", "<", ">", "<=", ">="}

    if not constraints or types_section is None:
        return []
    
    # go over constraints
    for constraint in constraints:

        constraint = constraint.strip()
        # if empty line -> continue
        if not constraint:
            continue
        
        constraint_split = constraint.split()
        # if constraint does not have 3 parts it cannot be valid
        if len(constraint_split) != 3 or constraint_split[1] not in supported_op:
            logger_setup.logger.error(f"Invalid constraint format: {constraint}")
            errors.append(YAML_result(db_name, "constraints", "invalid_constraint", 1, f"Invalid constraints format {constraint}"))
            continue
        
        # go over and validate
        errors += validate_rel_result(db_name, constraint, constraint_split, types_section)
        
    return errors

def save_yaml(yaml_string: str, db_name: str):
    filepath = f"results/dataster/dataster_config-{db_name}.yaml"
    with open(filepath, "a") as f:
        f.write(yaml_string)
        # f.write("\n----------------------------------------------------------------------\n")
    
    logger_setup.logger.info(f"Final yaml saved into {filepath}")


def save_original_yaml(yaml_string: str, db_name: str):
    filepath = f"results/original_yaml/dataster_config-{db_name}.yaml" 
    with open(filepath, "a") as f:
        f.write(yaml_string)
        # f.write("\n----------------------------------------------------------------------\n")

    logger_setup.logger.info(f"Original yaml saved into {filepath}")


def save_csv(errors: list[YAML_result], db_name: str):
    filepath = f"results/csv/results-{db_name}.csv"
    field_names = ["database", "section", "error_type", "severity", "detail"]

    writer_header = not os.path.exists(filepath) or os.path.getsize(filepath) == 0

    with open(filepath, mode="a", newline="", encoding="utf-8") as file:
        writer = csv.writer(file)
        if writer_header:
            writer.writerow(field_names)

        for error in errors:
            writer.writerow([error.database, error.section, error.error_type, error.severity, error.detail])
        
    
    logger_setup.logger.info(f"Results saved into {filepath}")