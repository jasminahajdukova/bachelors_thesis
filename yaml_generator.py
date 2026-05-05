from jsonschema import validate
import yaml
import re 


includes = None

# TO DO
# POZOR CO AK INCLUDE NIE JE PRVE


def validate_yaml(yaml_str: str):
    try:
        global includes
        stream = yaml.safe_load(yaml_str)
        stream_keys: list[str] = list(stream.keys())

        if not all(key in stream_keys for key in ["types", "schema", "generate"]):
            print("error") # pridanie errors
        for key in stream_keys:
            if key == "include":
                validate_include(stream[key])   
                includes = stream[key]
            elif key == "types":
                iterate_types(stream[key])
            elif key == "schema":
                validate_schema(stream[key])
            elif key == "generate":
                validate_generate(stream[key])
            elif key == "constrains":
                validate_constrains(stream[key])
            else:
                print("error") # pridanie errors
    except yaml.YAMLError as exc:
        print(exc)
    
    

def validate_types(each_type: str):
    basic_types: list[str] = ["int", "bool", "string", "float", "bigInt"]
    param_types: list[str] = ["seq", "interval", "dinterval", "finterval", "str_len", "regex"]
    dataset_types: list[str] = includes

    for value in list(each_type.values()):
        if value in basic_types:
            pass
        elif any(value.startswith(whatever) for whatever in param_types):
            pass
        elif dataset_types is not None and value in dataset_types:
            pass
        
        else:
            print("error")



def iterate_types(types: str):
    list_of_types: list[dict[str, str]] = list(types.keys())
    for part in list_of_types:
        validate_types(types[part])

def validate_schema(schema: str):
    pass


def validate_generate(generate: str):
    pass


def validate_include(includes: str):
    pass


def validate_constrains(constrains: str):
    pass
