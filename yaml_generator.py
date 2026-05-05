from jsonschema import validate
import yaml


def validate_yaml(yaml_str: str):
    try:
        stream = yaml.safe_load(yaml_str)
        stream_keys: list[str] = list(stream.keys())

        if not all(key in stream_keys for key in ["types", "schema", "generate"]):
            print("error") # pridanie errors
        for key in stream_keys:
            if key == "include":
                validate_include()
            elif key == "types":
                validate_type()
            elif key == "schema":
                validate_schema()
            elif key == "generate":
                validate_generate()
            elif key == "constrains":
                validate_constrains()
            else:
                print("error") # pridanie errors
    except yaml.YAMLError as exc:
        print(exc)
    
    


def validate_type():
    pass

def validate_schema():
    pass


def validate_generate():
    pass


def validate_include():
    pass


def validate_constrains():
    pass
