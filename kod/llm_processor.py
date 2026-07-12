import csv
from datetime import datetime, timedelta
import os
import re
import yaml_generator
import ollama
import httpx
import prompts
import logger_setup

class CyclicDependencyError(ValueError):
    pass

AVAILABLE_INCLUDES = [
    "psc_cs",               # postal codes of cities in Czech Republic
    "first_names_cs",       # first names that are used in Czech Republic
    "cities_cs",            # names of cities in Czech Republic
    "animals_blocks_en",     # some animal kinds in English language
    "last_names_cs",        # last names that are used in Czech Republic
    "colors_blocks_en",      # basic color names in English language
    "countries_cs"          # names of counties (in Czech language)
]

client = ollama.Client(timeout=600.0)

def get_response(type_name: str, prompt: str, model: str, thinking: bool = False):
    try: 
        response = client.generate(model=model,
                           prompt=prompt,
                           think=thinking,
                            options={ "num_predict": 4096, "num_ctx": 8192})
        if isinstance(response, dict):
            prompt_tokens   = response.get('prompt_eval_count', 'N/A')
            response_tokens = response.get('eval_count', 'N/A')
        else:
            prompt_tokens   = getattr(response, 'prompt_eval_count', 'N/A')
            response_tokens = getattr(response, 'eval_count', 'N/A') 

        logger_setup.logger.info(f"[{type_name.upper()}] Prompt tokens: {prompt_tokens}, Response tokens: {response_tokens}")
        return response
    except (httpx.TimeoutException, httpx.ReadTimeout) as exc:
        logger_setup.logger.error(f"Ollama timed out after 600s during {type_name} generation {exc}") 
        raise RuntimeError(f"{type_name} generation timed out {exc}")
    except ollama.ResponseError as exc:
        logger_setup.logger.error(f"Ollama model error: {exc}")
        raise RuntimeError(f"{type_name} was not generated: {exc}") from exc
    except httpx.ConnectError as exc:
        logger_setup.logger.error(f"Ollama is not running: {exc}")
        raise RuntimeError(f"Ollama is not running: {exc}") from exc

def generate_sql_query(template, db_name, table_name):
    query = template.format(db_name=db_name, table_name=table_name)
    return query

def strip_markdown(content: str) -> str:
    if not content:
        return ""
    content = content.strip()
    if content.startswith("```"):
        first_newline = content.find("\n")
        if first_newline != -1:
            content = content[first_newline + 1:]
        else:
            content = content[3:]
    if content.endswith("```"):
        content = content[:-3]
    return content.strip()

def generate_yaml_prompt(samples, types_section, sql_server_type, model, section):
    logger_setup.logger.info(f"Generating YAML '{section}' section")
    if section == "schema":
        prompt = prompts.build_schema_prompt(types_section, sql_server_type)
    elif section == "types":
        prompt = prompts.build_types_prompt(samples, sql_server_type)
    elif section == "generate":
        prompt = prompts.build_generate_prompt(types_section, sql_server_type)
    elif section == "constraints":
        prompt = prompts.build_constraints_prompt(types_section, sql_server_type)
    else: 
        raise ValueError(f"Unknown section: {section}")

    response = get_response(f"YAML {section}", prompt, model)
    generated_yaml = strip_markdown(response.response)
    return generated_yaml

def generate_yaml_include(type_content):

    if not type_content:
        return "include: []"
    cl_content = type_content
    for char in [":", "[", "]", "(", ")", ",", "-", "\n", "\r", "'", "\""]:
        cl_content = cl_content.replace(char, " ")

    words_in_content = []
    for word in cl_content.split():
        if word not in words_in_content:
            words_in_content.append(word)

    includes = []
    for dataset in AVAILABLE_INCLUDES:
        if dataset in words_in_content:
            includes.append(dataset)
    if includes:
        items = "\n".join([f"  - {d}" for d in includes])
        return f"include:\n{items}"
    else:
        return "include: []"

def filter_constraints(constraints_yaml, samples, db_table_names, columns_in_tables, repair_counts):

    if not constraints_yaml:
        return "constraints: []"
    lines = constraints_yaml.split('\n')
    filtered = []
    invalid_operators = ['~', '=~', '!~', 'match', 'regex', 'is not null', 'is null', "in", "is"]

    for line in lines:
        if line is None:
            continue

        if line.strip() == "constraints: []":
            filtered.append(line)
            continue

        stripped_line = line.split()
        if '-' in stripped_line:
            stripped_line.remove('-')

        if not stripped_line or line.strip().endswith(":"):
            filtered.append(line)
            continue


        if len(stripped_line) < 3:
            logger_setup.logger.warning(f"Removing invalid constraint: {line.strip()}")
            repair_counts["invalid_constraint_removed"] += 1 
            continue

        left_side = stripped_line[0].strip("'\"")
        operator = stripped_line[1].lower()
        right_side = " ".join(stripped_line[2:]).strip("'\"") 

        if (operator.strip() in invalid_operators) or (re.search(r"\b\d{4}-\d{2}-\d{2}\b", line)):
            logger_setup.logger.warning(f"Removing invalid constraint: {line.strip()}")
            repair_counts["invalid_constraint_removed"] += 1 
            continue

        is_valid_constraint = True

        if "." in left_side:
            left_table, left_column = left_side.split(".", 1)

            if left_table.title() in samples:
                left_table = left_table.title()
            
            elif left_table.lower() in db_table_names:
                left_table = db_table_names[left_table.lower()]

            left_table_lower = left_table.lower()
            if left_table_lower in columns_in_tables:
                left_column_lower = left_column.lower()
                if left_column_lower in columns_in_tables[left_table_lower]:

                    correct_column = columns_in_tables[left_table_lower][left_column_lower]
                    if correct_column != left_column:
                        left_column = correct_column
                        repair_counts["schema_value_casing"] += 1
                
                else:
                    logger_setup.logger.warning(f"Removing invalid constraint: {line.strip()}")
                    repair_counts["invalid_constraint_removed"] += 1 
                    is_valid_constraint = False

            else:
                logger_setup.logger.warning(f"Removing invalid constraint: {line.strip()}")
                repair_counts["invalid_constraint_removed"] += 1 
                is_valid_constraint = False

            left_side = f"{left_table}.{left_column}"
        
        if not is_valid_constraint:
            continue
        
        is_numeric = bool(re.match(r'^[-+]?(?:\d+(?:\.\d*)?|\.\d+)$', right_side))

        if "." in right_side and not is_numeric:
            right_table, right_column = right_side.split(".", 1)

            if right_table.title() in samples:
                right_table = right_table.title()
            
            elif right_table.lower() in db_table_names:
                right_table = db_table_names[right_table.lower()]

            right_table_lower = right_table.lower()
            if right_table_lower in columns_in_tables:
                right_column_lower = right_column.lower()
                if right_column_lower in columns_in_tables[right_table_lower]:
                    correct_column = columns_in_tables[right_table_lower][right_column_lower]
                    if correct_column != right_column:
                        right_column = correct_column
                        repair_counts["schema_value_casing"] += 1


                else:
                    logger_setup.logger.warning(f"Removing invalid constraint: {line.strip()}")
                    repair_counts["invalid_constraint_removed"] += 1 
                    is_valid_constraint = False

            else:
                logger_setup.logger.warning(f"Removing invalid constraint: {line.strip()}")
                repair_counts["invalid_constraint_removed"] += 1 
                is_valid_constraint = False

            right_side = f"{right_table}.{right_column}"
        
        if not is_valid_constraint:
            continue
        
        if left_side == right_side:
            logger_setup.logger.warning(f"Removing self-referencing constraint: {line.strip()}")
            repair_counts["invalid_constraint_removed"] += 1 
            continue

        
        is_col_ref = '.' in right_side and len(right_side.split('.')) == 2

        if not is_numeric and not is_col_ref:
            repair_counts["invalid_constraint_removed"] += 1 
            logger_setup.logger.warning(f"Removing invalid constraint: {line.strip()}")
            continue
        
        line = f"  - {left_side} {operator} {right_side}"
        filtered.append(line)


    result = '\n'.join(filtered)
    if result.strip() == 'constraints:':
        return 'constraints: []'
    
    return result

def apply_fk_to_schema(schema_yaml: str, fk_map: dict, repair_counts: dict) -> str:
    lines = schema_yaml.split('\n')
    result = []
    current_table = None
    
    for line in lines:
        if not line.strip() or line.strip().startswith("schema:"):
            result.append(line)
            continue
        table_match = re.match(r"^(\s+)([a-zA-Z0-9_-]+):\s*$", line)
        if table_match:
            current_table = table_match.group(2)
            result.append(line)
            continue
        col_match = re.match(r"^(\s+)([a-zA-Z0-9_-]+):\s*(.*)", line)
        if current_table and col_match and current_table in fk_map:
            indent             = col_match.group(1)
            column_name        = col_match.group(2)
            if column_name in fk_map[current_table]:
                ref_table, ref_col = fk_map[current_table][column_name]
                result.append(f"{indent}{column_name}: FROM {ref_table}.{ref_col}")   
                repair_counts["foreign_key_schema"] +=1                
                continue
        result.append(line)
    return "\n".join(result)

def sort_tables_multi_level(fk_map):
    remaining_tables = list(fk_map.keys())
    sorted_tables = []  
    while remaining_tables:
        made_progress = False
        for table in list(remaining_tables):
            fk_details = fk_map[table]
            parent_tables = [
                parent_table for parent_table, _ in fk_details.values() if parent_table is not None 
                and parent_table != table
            ]
            if all(parent in sorted_tables for parent in parent_tables):
                sorted_tables.append(table)
                remaining_tables.remove(table)
                made_progress = True  
        if not made_progress:
            raise CyclicDependencyError("Cyclic dependency or missing parent table detected")
    return sorted_tables

def go_over_generate(gen_count, samples, generate_content, repair_counts):
    generate_content = generate_content.split("\n")
    new_generate = []

    columns = {}

    for line in generate_content:
        if line == "generate:" or not line.strip() or line == "":
            new_generate.append(line)
            continue
        line_split = line.split("=")
        try:
            table_name = line_split[0].replace("-", "").replace(" ", "").replace("'", "")
            num_value = int(line_split[1].replace("'", "").replace(" ",""))
            columns = samples.get(table_name, {})
            pk_column = {}
            for column_name, column_values in columns.items():
                if column_values.get("is_pk", False) == True:
                    pk_column = column_values
                    break

        except (ValueError, IndexError):
            logger_setup.logger.error("cannot convert to number")
            new_generate.append(line)
            continue

        if table_name not in gen_count:
            new_generate.append(line)
            continue
        
        target_value = gen_count[table_name]
        is_changed = False

        if pk_column and pk_column.get("data_type") == "numeric":

            sequence = pk_column.get("seq", "")
            if sequence and sequence.startswith("seq("):
                try:
                    seq_numbers = re.findall(r"\d+", sequence)

                    if len(seq_numbers) >= 2:
                        min_num = int(seq_numbers[0])
                        max_num = int(seq_numbers[1])
                        step    = int(seq_numbers[2]) if len(seq_numbers) == 3 else 1


                        # count how many numbers inside seq
                        seq_len = (max_num - min_num) // step + 1

                        if target_value > seq_len or num_value > seq_len:
                            target_value = min(target_value, seq_len)
                            is_changed   = True
                            
                except (ValueError, IndexError, ZeroDivisionError) as viz:
                    logger_setup.logger.error(f"Seq expected number. Got {sequence}: {viz}")
            elif sequence:
                logger_setup.logger.warning(f"Wrong sequence format for table {table_name}: {sequence}")

        if num_value != target_value:
            if is_changed:
                logger_setup.logger.warning(f"[Repair] Number to generate for table '{table_name}' greater than sequence. Generate number adjusted to satisfy seq")
            new_generate.append(f"- '{table_name} = {target_value}'")
            repair_counts["generate_row_count_fix"] += 1
        else:
                new_generate.append(line)

    return "\n".join(new_generate)
    
def fix_regex_quoting(types_yaml, repair_counts):

    re_pattern = r"regex\(\s*['\"]?(.*?)['\"]?\s*\)"
    dinterval_pattern = r"dinterval\(\s*''?(.*?)''?\s*\,\s*''?(.*?)''?\s*\)"
    results = []
    lines = types_yaml.splitlines()

    for line in lines:
        if "regex(" not in line and "dinterval(" not in line:
            results.append(line)
            continue
        re_match = re.search(re_pattern, line)
        dinterval_match = re.search(dinterval_pattern, line)

        if re_match:
            inner = re_match.group(1)

            inner = inner.replace("\\'", "'")
            inner = inner.replace("'", "''")

            start, end = re_match.span()
            fixed_line = line[:start] + f"regex('{inner}')" + line[end:]
            results.append(fixed_line)
            if fixed_line != line:
                repair_counts["regex_quoting_fix"] +=1

        elif dinterval_match:
            date1 = dinterval_match.group(1)
            date2 = dinterval_match.group(2)

            date1_clean = re.sub(r"['\"]?", "", date1).replace("T", " ").strip()
            date2_clean = re.sub(r"['\"]?", "", date2).replace("T", " ").strip()

            start, end = dinterval_match.span()

            fixed_line = line[:start] + f"dinterval({date1_clean}, {date2_clean})" + line[end:]
            results.append(fixed_line)
            if date1_clean != date1 or date2_clean != date2:
                repair_counts["regex_quoting_fix"] +=1
        else:
            results.append(line)
    return "\n".join(results)

def go_over_schema(schemas, samples, repair_counts):
    current_table = ""
    new_schema = []           
    schemas_split = schemas.split("\n")
    checked_samples = []

    db_table_names = {table.lower(): table for table in samples.keys()}

    for line in schemas_split:

        if line == "schema:" or not line.strip():
            new_schema.append(line)
            continue
        line_split = line.strip().split(" ")

        table_name = line_split[0].strip(":")


        if len(line_split) == 1:
            if table_name in samples:
                current_table = table_name
                new_schema.append(line)
                continue
            else:
                if table_name.title() in samples:
                    table_name = table_name.title()
                    current_table = table_name
                    indent = line[:line.find(line_split[0])]
                    new_schema.append(f"{indent}{table_name}:")
                    repair_counts["schema_table_fix"] += 1
                    continue

                elif table_name.lower() in db_table_names:
                    table_name = db_table_names[table_name.lower()]
                    current_table = table_name
                    indent = line[:line.find(line_split[0])]
                    new_schema.append(f"{indent}{table_name}:")
                    repair_counts["schema_table_fix"] += 1
                    continue

                logger_setup.logger.warning(f"{table_name} is not part of {samples.keys()}")
                repair_counts["invalid_schema_removed"] += 1
                continue
       
        schema_name = line_split[0].strip(":")
        if not current_table:
            continue
        
        checked_samples = list(value for value in samples[current_table])
        if schema_name not in checked_samples:
            if schema_name.title() in checked_samples:
                org_schema = schema_name
                schema_name = schema_name.title()
                indent = line[:line.find(line_split[0])]
                rest_of_line = line[line.find(line_split[0]) + len(org_schema):]
                line = f"{indent}{schema_name}{rest_of_line}"
                repair_counts["schema_column_fix"] += 1
            else:
                logger_setup.logger.warning(f"This schema_name does not belong = {schema_name}")
                repair_counts["invalid_schema_removed"] += 1
                continue

        new_schema.append(line)

    new_schema = '\n'.join(new_schema)
 
    return new_schema

def append_email_domains(repaired_lines: list, found_domains: list, has_email_domain_in_types: bool):
    if found_domains and not has_email_domain_in_types:
        repaired_lines.append("    email_domains:")
        repaired_lines.append("      - BLOCKS")

        unique_domains = []

        for domain in found_domains:
            if domain not in unique_domains:
                unique_domains.append(domain)

        for domain in unique_domains:
            repaired_lines.append(f"      - {domain}")
    

def is_domain_valid(domain: str) -> bool:
    pattern = r"^[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)+$"

    if not re.match(pattern, domain):
        return False

    if domain.endswith("."):
        return False
    
    top_lvl_dom = domain.split(".")[-1]
    if len(top_lvl_dom) < 2:
        return False
    
    return True

def fix_references(line: str, stripped: str, current_table: str, samples: dict, repaired_lines: list, found_domains: list, repair_counts: dict, state: dict):
    # get raw value by removing whispaces and quotes
    raw_value = stripped[1:].strip().strip("'\"")
    indent = line[:line.find("-")]

    # if inside block, copy line and move on
    if state.get("in_blocks_list", False):
        
        if stripped.startswith("-"):
            
            fixed_value = yaml_bool(raw_value, repair_counts)
            if fixed_value != raw_value:
                line = f"{indent}- {fixed_value}"

        repaired_lines.append(line)
        return
    
    # if only blocks, skip and increment fix count
    if raw_value.upper() == "BLOCKS":
        repair_counts["email_duplication_fix"] += 1
        return

    # looking for parent to the list of values
    parent_col = None
    for prev_line in reversed(repaired_lines):
        prev_stripped = prev_line.strip()
        # if line starts with - => not a parent 
        if ":" in prev_stripped and not prev_stripped.startswith("-"):
            parent_col = prev_stripped.split(":", 1)[0].strip()
            break
    
    
    if parent_col == "email_domains":
        repaired_lines.append(line)
        return

    # references to email_domains
    if "email_domains" in raw_value:
        if parent_col and parent_col != "email_domains":
            # insert reference only once per block to prevent duplication
            if not state.get("has_refs_in_block", False):
                line = f"{indent}- {current_table}.email_domains"
                state["has_refs_in_block"] = True
                repaired_lines.append(line)
            else:
                # if reference already exists incement repair count
                repair_counts["email_duplication_fix"] += 1
                return repaired_lines
        else:
            repaired_lines.append(line)
        return

    # fix unfinished column references ( - name -> - Table.name)
    if "." not in raw_value and not raw_value.endswith("_cs") and not raw_value.endswith("_en"):
        # check if reference is valid and exists 
        is_valid_col = (current_table in samples and raw_value in samples[current_table])
        if is_valid_col:
            # if valid -> fix it
            line = f"{indent}- {current_table}.{raw_value}"
            repair_counts["unfinished_reference_fix"] += 1
            logger_setup.logger.warning(f"[Repair] Fixed unqualified reference: '{raw_value}' -> '{current_table}.{raw_value}'")

    # handle domain names
    elif "." in raw_value and not raw_value.endswith("_cs") and not raw_value.endswith("_en") and not raw_value.startswith(f"{current_table}."):
        # if table_name in samples move on
        potential_table = raw_value.split(".", 1)[0]
        if potential_table in samples:
            repaired_lines.append(line)
            return

        # check if domain is valid
        domain_clean = raw_value.replace("@", "").strip()
        is_valid_domain = is_domain_valid(domain_clean)
        
        if not is_valid_domain:
            repaired_lines.append(line)
            return

        # add to list of found domain
        found_domains.append(domain_clean)
        # if reference not inside block, put it inside 
        if not state.get("has_refs_in_block", False):
            line = f"{indent}- {current_table}.email_domains"
            state["has_refs_in_block"] = True
            # increment repair_count
            repair_counts["email_format_fix"] += 1
            logger_setup.logger.warning(f"[Repair] Found domain '{domain_clean}' and injected template reference.")
            repaired_lines.append(line)
        else:
            #increment repair_count
            repair_counts["email_format_fix"] += 1
            return
        return

    repaired_lines.append(line)
    return repaired_lines

def fix_blocks(lines: list, i: int, line: str, stripped: str, current_table: str, samples: dict, repaired_lines: list, repair_counts: dict, state: dict) -> tuple[int, bool]:
    
    # not a column -> skip
    if ":" not in stripped:
        # return orignal index count, and False (as in no change)
        return i, False
    
    # if there is a value after column name ( example: column_name: value)
    # split it and get column_name and value
    if not stripped.endswith(":"):
        parts = stripped.split(":", 1)
        column_name = parts[0].strip()
        value = parts[1].strip()
    else:
        # else value is empty
        column_name = stripped[:-1].strip()
        value = ""
  
    # get indent
    indent = line[:line.find(column_name)]
    # if its just BLOCKS
    is_just_blocks = (value == "BLOCKS")
    # if BLOCKS and other values under BLOCKS in one line
    is_just_one_line_blocks = ("BLOCKS" in value and "-" in value)

    if not is_just_blocks and not is_just_one_line_blocks and value == "":
        next_index = i + 1
        dash_items = []


        while next_index < len(lines) and lines[next_index].strip().startswith("-"):
            dash_items.append((next_index, lines[next_index].strip()[1:].strip().strip("'\"")))
            next_index += 1

        if len(dash_items) == 1:
            line_index, item_value = dash_items[0]
            if item_value in AVAILABLE_INCLUDES:
                repaired_lines.append(f"{indent}{column_name}: {item_value}")
                repair_counts["single_item_list_fix"] += 1
                logger_setup.logger.warning(f"[Repair] Moved single item list for {current_table}.{column_name}")
                return next_index, True


    # if none of these -> skip and return index and False
    if not (is_just_blocks or is_just_one_line_blocks):
        return i, False

    values_under_blocks = []
    if is_just_one_line_blocks:
        match = re.match(r"^BLOCKS\s*-\s*(.*)$", value, re.IGNORECASE) or re.match(r"^BLOCKS\s*-(.*)$", value, re.IGNORECASE)
        # get all values after BLOCKS
        if match:
            values = match.group(1).split("-")
            for value in values:
                clean_value = value.strip().strip("'\"")
                if clean_value:
                    values_under_blocks.append(clean_value)

    next_index = i + 1
    # looks at next lines if they belong under BLOCKS and adds them to values_under_blocks
    while next_index < len(lines) and lines[next_index].strip().startswith("-"):
        dash_line = lines[next_index]
        raw_item = dash_line.strip()[1:].strip().strip("'\"")
        # skips BLOCKS
        if raw_item and raw_item.upper() != "BLOCKS":
            values_under_blocks.append(raw_item)
        next_index += 1

    # if any values that belong udner BLOCKS found -> fix the structure so its written correctly
    if values_under_blocks:
        repaired_lines.append(f"{indent}{column_name}:")
        repaired_lines.append(f"{indent}  - BLOCKS")
        for vals in values_under_blocks:
            fixed_val = yaml_bool(vals, repair_counts)
            repaired_lines.append(f"{indent}  - {fixed_val}")
        # increment repair_counts
        repair_counts["inline_blocks_fix"] += 1
        # return new idnex and True (as in something was changed)
        return next_index, True

    # in case there are no value under BLOCKS, it gets values from actual samples 
    if is_just_blocks and current_table and current_table in samples:
        # gets columns from current table inside samples
        col_lookup = {column.lower(): column for column in samples[current_table]}
        if column_name.lower() in col_lookup:
            actual_column_name = col_lookup[column_name.lower()]
            db_samples = samples[current_table][actual_column_name].get("samples", [])
            # if samples found, creates BLOCKS and writes samples underneath
            if db_samples:
                repaired_lines.append(f"{indent}{column_name}:")
                repaired_lines.append(f"{indent}  - BLOCKS")
                for sample_val in db_samples:
                    if sample_val is not None and str(sample_val).strip() != "":
                        fixed_sample = str(sample_val).strip()
                        fixed_sample = yaml_bool(fixed_sample, repair_counts)
                        repaired_lines.append(f"{indent}  - {fixed_sample}")
                # increments repair_counts
                repair_counts["filled_empty_blocks"] += 1
                # return new idnex and True (as in something was changed)
                return i + 1, True
    return i, False

def fix_types_and_schema(line: str, stripped: str, current_section: str, current_table: str, db_table_names: dict, samples: dict, columns_in_tables: dict, repair_counts: dict) -> str:

    # not a column_name: value -> skip
    if ":" not in stripped:
        return line
    
    # if there is a value after column name ( example: column_name: value)
    # split it and get column_name and value
    if not stripped.endswith(":"):
        parts = stripped.split(":", 1)
        column_name = parts[0].strip()
        value = parts[1].strip()
    else:
        # else value is empty
        column_name = stripped[:-1].strip()
        value = ""

    # get indent
    indent = line[:line.find(column_name)]

    ### SECTION TYPES ###

    # if LLM generated text (with/out) quotes
    if current_section == "types" and value and re.match(r"^['\"]?text['\"]?$", value.strip(), re.IGNORECASE):
        # increment repari_count
        repair_counts["text_to_string_fix"] += 1
        # fix data type to string
        return f"{indent}{column_name}: string"
    
    # kontrola
    if current_section == "types" and value:
        if column_name.lower() in ["format", "values"]:
            return line
        # remove quotes
        val_clean = value.strip().strip("'\"")
        if (val_clean.lower() not in ["string", "blocks"] and val_clean not in AVAILABLE_INCLUDES and "(" not in val_clean):
            repair_counts["invalid_dataset_fix"] += 1
            logger_setup.logger.warning(f"[Repair] Hallucinated dataset '{val_clean}' at '{current_table}.{column_name}'. Will try to guess appropriate data type")

            fixed_data_type = guess_type_from_db(current_table, column_name, samples)
            return f"{indent}{column_name}: {fixed_data_type}"

    ### SECTION SCHEMA ###

    if current_section == "schema" and value:
        # if reference to foreign key
        is_from = value.upper().startswith("FROM ")

        # if foreign key -> get referenced value (starts from 5 because FROM 4 letter + one space) 
        # strip from white space and quotes 
        ref_text = value[5:].strip().strip("'\"") if is_from else value.strip().strip("'\"")

        # if dot (or table.column)
        if "." in ref_text:
            ref_table, ref_column = ref_text.split(".", 1)
            target_table_correct = None
            # if referenced table exists in sample

            # this checks and fixes table name in case the name is correct but capitalization is not
            if ref_table.title() in samples:
                target_table_correct = ref_table.title()
            elif ref_table.lower() in db_table_names:
                target_table_correct = db_table_names[ref_table.lower()]

            target_column_correct = ref_column

            # if correct name is found and doesnt match referenced table name -> fix
            if target_table_correct:
                table_name_lower = target_table_correct.lower()

                if table_name_lower in columns_in_tables:
                    column_name_lower = ref_column.lower()
                    if column_name_lower in columns_in_tables[table_name_lower]:
                        target_column_correct = columns_in_tables[table_name_lower][column_name_lower]

                if target_table_correct != ref_table or target_column_correct != ref_column:
                    if is_from:
                        new_value = f"FROM {target_table_correct}.{target_column_correct}"
                    else:
                        new_value = f"{target_table_correct}.{target_column_correct}"

                    repair_counts["schema_value_casing"] += 1
                    # return fixed line
                    return f"{indent}{column_name}: {new_value}"
                
            if target_table_correct is None and current_table and not is_from:
                current_table_lower = current_table.lower()
                if current_table_lower in columns_in_tables:
                    column_lower = ref_column.lower()
                    if column_lower in columns_in_tables[current_table_lower]:
                        target_column_correct = columns_in_tables[current_table_lower][column_lower]
                
                new_value = f"{current_table}.{target_column_correct}"
                # increment repair count
                repair_counts["schema_value_casing"] += 1
                # return fixed line
                return f"{indent}{column_name}: {new_value}"
            
    # line went through all those checks nothing was fixed 
    # so unchanged line is returned
    return line

def go_over_found_columns(lines_list: list, samples: dict) -> dict:
    
    # creates empty list for every table in samples
    found_columns = {table: [] for table in samples.keys()}
    curr_table = None


    for line in lines_list:

        stripped_line = line.strip()
        # get indent
        indent = len(line) - len(line.lstrip())

        # checks if name of table
        if stripped_line.endswith(":") and not stripped_line.startswith("-") and indent == 2:
            
            table = stripped_line[:-1]
            if table in samples:
                curr_table = table

        # checks if column inside table (without value)
        elif stripped_line.endswith(":") and not stripped_line.startswith("-") and indent == 4 and curr_table:
            column = stripped_line[:-1]
            # if column not in list of found_columns for the current table -> add to the list
            if column not in found_columns[curr_table]:
                found_columns[curr_table].append(column)

        # checks if column inside table (with value) -> example: [age: int]
        elif ":" in stripped_line and not stripped_line.startswith("-") and indent == 4 and curr_table:
            # if column not in list of found_columns for the current table -> add to the list
            column = stripped_line.split(":", 1)[0].strip()
            if column not in found_columns[curr_table]:
                found_columns[curr_table].append(column)
    # returned filled dict with found columns for every table
    return found_columns

def check_format(yaml_str: str, samples: dict, repair_counts: dict) -> str:
    
    # splits YAML into line
    lines = yaml_str.splitlines()
    output_lines = []
    
    current_section = None
    current_table = None
    
    found_columns = {table: [] for table in samples.keys()}
    temp_section = None
    temp_table = None

    for line in lines:
        section = line.strip()
        indent = len(line) - len(line.lstrip())
        # if line is one of YAML sections
        if section in ["types:", "schema:", "generate:", "constraints:", "include:"]:
            temp_section = section[:-1]
            continue
        
        # if in types and found table name
        if temp_section == "types" and section.endswith(":") and not section.startswith("-") and indent == 2:
            # check if table exists in samples
            if section[:-1] in samples:
                temp_table = section[:-1]
            else:
                temp_table = None

        # if in types and found column
        elif temp_section == "types" and temp_table and indent == 4 and ":" in section and not section.startswith("-"):
            found_column_name = section.split(":", 1)[0].strip()
            if found_column_name not in found_columns[temp_table]:
                found_columns[temp_table].append(found_column_name)

    i = 0
    # go over line again
    while i < len(lines):
        line = lines[i]
        stripped = line.strip()
        indent = len(line) - len(line.lstrip())
        
        # if one of YAML sections
        if stripped in ["types:", "schema:", "generate:", "constraints:", "include:"]:
            # get current section, append to output and move on
            current_section = stripped[:-1]
            output_lines.append(line)
            i += 1
            continue
        
        # if section types and found table name
        if current_section == "types" and stripped.endswith(":") and not stripped.startswith("-") and indent == 2:
            # get table, append ilne to output and move on
            current_table = stripped[:-1]
            output_lines.append(line)
            i += 1
            continue

        # if section types and found column name
        if current_section == "types" and current_table and indent == 4 and stripped.endswith(":") and not stripped.startswith("-"):
            # save name of column
            column_name = stripped[:-1]
            
            has_format_block = False
            format_content = ""
            format_line_index = -1
            values_line_index = -1
            
            # look at next line
            check_index = i + 1
            # if next line if format

            if check_index < len(lines) and lines[check_index].strip().startswith("format:"):
                format_line_index = check_index
                format_content = lines[check_index].strip().split(":", 1)[1].strip()
                # check if next line is values
                check_index += 1
                if check_index < len(lines) and lines[check_index].strip() == "values:":
                    values_line_index = check_index
                    # found format structure
                    has_format_block = True
            
            # if format structure
            if has_format_block:
                # go over values under 'values:'
                value_lines_indexes = []
                val_collect_index = values_line_index + 1
                # if any values found -> collect them and move onto the next one
                expected_indent = None
                if val_collect_index < len(lines) and lines[val_collect_index].strip().startswith("-"):
                    expected_indent = len(lines[val_collect_index]) - len(lines[val_collect_index].lstrip()) 
                
                has_weird_indents = False

                while val_collect_index < len(lines) and lines[val_collect_index].strip().startswith("-"):
                    current_indent = len(lines[val_collect_index]) - len(lines[val_collect_index].lstrip()) 

                    if expected_indent is not None:
                        if current_indent == expected_indent:
                            value_lines_indexes.append(val_collect_index)
                        elif current_indent > expected_indent:
                            has_weird_indents = True

                    val_collect_index += 1
                
                found_refs = []
                has_blocks_placeholder = False

                # go over found values under 'values:'
                for index in value_lines_indexes:
                    # remove any whitespaces and quotes
                    val_raw = lines[index].strip()[1:].strip().strip("'\"")
                    # ignore BLOCKS and add to list of oxtracted refs
                    if val_raw.upper() == "BLOCKS":
                        has_blocks_placeholder = True
                    elif val_raw != "":
                        found_refs.append(val_raw)
                
                num_format_filled = len(found_refs) + (1 if has_blocks_placeholder else 0)
                # count number of {} inside format
                exp_format_count = len(re.findall(r"\{\}", format_content))
                # check if number of {} and number of values under 'values:' match
                wrong_count = (exp_format_count > 0 and num_format_filled != exp_format_count) or has_weird_indents
                
                # go over every reference inside extracted refs
                invalid_refs_found = False
                for ref in found_refs:
                    # check if there is reference to table.column
                    if "." in ref:
                        table, column = ref.split(".", 1)
                        # if the reference is wrong
                        if table not in samples or (column not in samples[table] and column not in found_columns[table]):
                            invalid_refs_found = True
                            break
                    # if not a reference check if its include
                    # kontrola ci je to spravne
                    else:
                        
                        is_valid = (ref in AVAILABLE_INCLUDES) or (current_table in samples and ref in samples[current_table]) or (current_table in found_columns and ref in found_columns[current_table])
                        
                        if not is_valid:
                            invalid_refs_found = True
                            break
                
                # if wrong format found
                if wrong_count or invalid_refs_found:
                    # get indent
                    column_indent = len(line) - len(line.lstrip())
                    indent_str = line[:line.find(column_name)]

                    guessed_type = guess_type_from_db(current_table, column_name, samples)
                    output_lines.append(f"{indent_str}{column_name}: {guessed_type}")
                    # increment repair_count
                    repair_counts["wrong_format_structure"] += 1
                    logger_setup.logger.warning(f"[Repair] Wrong format structure at '{current_table}.{column_name}' (Arity mismatch: {wrong_count}, Invalid ref: {invalid_refs_found}). Changed to  guessed type {guessed_type}.")
                    
                    index = val_collect_index
                    while index < len(lines):
                        if not lines[index].strip():
                            index += 1
                            continue
                        current_indent = len(lines[index]) - len(lines[index].lstrip())
                        if current_indent > column_indent:
                            index += 1
                        else:
                            break
                    i = index
                    continue
        
        # if no errors found, add line to output and move on
        output_lines.append(line)
        i += 1
    
    # return YAML as one string
    return "\n".join(output_lines)


def add_new_line_to_table(lines: list, table: str, new_line: str) -> list:
    output_lines = []
    inserted = False
    for line in lines:
        output_lines.append(line)
        indent = len(line) - len(line.lstrip())
        
        # if new line not inserted yet and found table name
        if not inserted and line.strip() == f"{table}:" and indent == 2:
            output_lines.append(new_line)
            inserted = True
    
    # check if new line still not inserted
    if not inserted:
        output_lines.append(f"  {table}:")
        output_lines.append(new_line)

    # return updated lines
    return output_lines


def guess_type_from_db(table: str, columns: str, samples: dict) -> str:
    
    if table not in samples or columns not in samples[table]:
        return "string"

    column  = samples[table][columns]
    db_type = str(column["db_type"]).lower()
    column_samples = column["samples"] if "samples" in column else []
    is_prime_key = column["is_pk"]

    is_numeric = any(type_db in db_type for type_db in ["int", "decimal", "float", "double", "numeric"])
    
    # kontrola time
    is_just_time = "time" in db_type and "date" not in db_type
    is_date = "date" in db_type or "time" in db_type

    # in case its dealing with numeric prime keys
    if is_prime_key and is_numeric:
        if "seq" in column:
            sequence = column["seq"] if "seq" in column else None
        if sequence:
            return sequence
        logger_setup.logger.warning("Couldn't get seq for prime keys. Inserted seq(1, 10, 1). Change it so it fits your table")
        return "seq(1, 10, 1)"
    
    if is_just_time:
        logger_setup.logger.warning("Couldn't get the right values for time. Inserted regex to get 24H format time. Change it so it fits your table")
        return "regex('([0-1][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]')"

    # if data type numeric
    if is_numeric:
        num_samples = []
        # get numbs from samples
        for sample in column_samples:
            try:
                num_samples.append(float(sample))
            except (ValueError, TypeError):
                logger_setup.logger.warning(f"[FIX ERROR] Cannot convert sample {sample} to float for column '{table}.{columns}'. This value is skipped")
                pass

        if num_samples:
            min_value = min(num_samples)
            max_value = max(num_samples)

            if all(float(sample).is_integer() for sample in num_samples):
                min_value = int(min_value)
                max_value = int(max_value)

                if min_value == max_value:
                    max_value = min_value + 1

                return f"interval({min_value}, {max_value})"
            
            return f"finterval({min_value}, {max_value})"
        logger_setup.logger.warning("Couldn't get values for (f)interval. Inserted interval(1, 10). Change it so it fits your table")
        return "interval(1, 10)"

    # if its dealing with dates
    if is_date:
        date_samples = []
        # get date from samples
        for sample in column_samples:
            sample_str = str(sample).strip() if sample is not None else ""
            if not sample_str:
                continue

            date_time_match = re.search(r"^(\d{4}-\d{2}-\d{2})[ T](\d{2}:\d{2}:\d{2})", sample_str)
            if date_time_match:
                date_samples.append(f"{date_time_match.group(1)} {date_time_match.group(2)}")
                continue

            date_match = re.search(r"^(\d{4}-\d{2}-\d{2})", sample_str)
            if date_match:
                date_samples.append(date_match.group(1))

        if date_samples:
            min_date = min(date_samples)
            max_date = max(date_samples)

            if min_date == max_date:
                if " " in max_date:
                    new_max_date = datetime.strptime(max_date, "%Y-%m-%d %H:%M:%S")
                    max_date     = (new_max_date + timedelta(days=1)).strftime("%Y-%m-%d %H:%M:%S")

                else:
                    new_max_date = datetime.strptime(max_date, "%Y-%m-%d")
                    max_date     = (new_max_date + timedelta(days=1)).strftime("%Y-%m-%d") 
            return f"dinterval({min_date}, {max_date})"
        
        logger_setup.logger.warning("Couldn't get values for dinterval. Inserted dinterval(2026-06-01, 2026-06-30). Change it so it fits your table")
        return "dinterval(2026-06-01, 2026-06-30)"

    return "string"


def fill_in_missing_columns(yaml_str: str, samples: dict, repair_counts: dict) -> str:
    sections = {"include": [], "types": [], "schema": [], "generate": [], "constraints": []}
    current_section = None

    lines = yaml_str.splitlines()
    # go over lines in YAML
    for line in lines:
        stripped = line.strip()
        # if line in YAML sections
        if stripped in ["types:", "schema:", "generate:", "constraints:", "include:"]:
            current_section = stripped[:-1]
            sections[current_section].append(line)
            continue
        # if curr section set append lines to the current section the code is dealing with
        if current_section:
            sections[current_section].append(line)

    # if "types:" is missing in section types add it to the beginning
    if not any(line.strip() == "types:" for line in sections["types"]):
        sections["types"].insert(0, "types:")

    # if "schema:" is missing in section schema add it to the beginning
    if not any(line.strip() == "schema:" for line in sections["schema"]):
        sections["schema"].insert(0, "schema:")

    types_found = go_over_found_columns(sections["types"], samples)
    schema_found = go_over_found_columns(sections["schema"], samples)

    for table, columns in samples.items():
        for column in columns.keys():
            is_in_types = column in types_found[table]
            is_in_schema = column in schema_found[table]
            if is_in_types and is_in_schema:
                continue
            
            # increment repair_counts
            repair_counts["schema_missing_columns_fix"] += 1
            logger_setup.logger.warning(f"[Repair] Missing column {table}.{column}, inserting")
            # if column not found in types -> add it
            if not is_in_types:
                sections["types"] = add_new_line_to_table(sections["types"], table, f"    {column}: {guess_type_from_db(table, column, samples)}")

            # if column not found in schema -> add it 
            if not is_in_schema:
                sections["schema"] = add_new_line_to_table(sections["schema"], table, f"    {column}: {table}.{column}")

    # goes over changed sections, combines them   
    combined_sections = []
    for section_name in ["include", "types", "schema", "generate", "constraints"]:
        if sections[section_name]:
            combined_sections.append("\n".join(sections[section_name]))

    return "\n".join(combined_sections)

def remove_unused_types(yaml_str: str, samples: dict, repair_counts: dict) -> str:
    
    lines = yaml_str.splitlines()
    used_in_schema       = []
    used_in_values       = []
    used_in_constraints = []
    found_section = None

    operators = ["<=", ">=", "!=", "=", "<", ">"]

    # go over lines in YAML
    for line in lines:
        section = line.strip()

        if not section:
            continue

        if section in ["types:", "schema:", "generate:", "constraints:", "include:"]:
            found_section = section[:-1]
            continue

        if section.startswith("-") and "." in section:
            value = section[1:].strip().strip("'\"")
            if "." in value and value not in used_in_values:
                used_in_values.append(value)

        # if inside section and found column
        if found_section == "schema" and ":" in section and not section.startswith("-"):
            # split line and remove any white spaces and quotations
            value = section.split(":", 1)[1].strip().strip("'\"")
            
            # if referencing foreign key -> remove FROM
            if value.upper().startswith("FROM "):
                # value moved by 5 because FROM 4 letters + 1 space
                value = value[5:].strip()

            # if table.column saves into used_in_schema
            if "." in value and value not in used_in_schema:
                used_in_schema.append(value)
        
        elif found_section == "constraints" and section.startswith("-"):
            line_clean = section.strip("- ")

            values_in_constraints = []
            if not line_clean:
                continue

            for operator in operators:
                if operator in line_clean:
                    constraint_split = line_clean.split(operator, 1)
                    values_in_constraints = [constraint_split[0].strip(), constraint_split[1].strip()]
                    break

            
            if not values_in_constraints:
                continue

            for value in values_in_constraints:
                value_clean = value.strip("'\"")

                if "." in value_clean and value_clean not in used_in_constraints:
                    used_in_constraints.append(value_clean)


        elif found_section == "generate" and section.startswith("-"):
            value = section[1:].strip().strip("'\"")
            if "." in value and value not in used_in_values:
                used_in_values.append(value)


    output_lines = []
    current_section = None
    current_table = None
    i = 0
    while i < len(lines):
        line = lines[i]
        stripped = line.strip()
        indent = len(line) - len(line.lstrip())

        if not stripped:
            output_lines.append(line)
            i += 1
            continue

        if stripped in ["types:", "schema:", "generate:", "constraints:", "include:"]:
            current_section = stripped[:-1]
            output_lines.append(line)
            i += 1
            continue

        # if in types and found table -> add to output and move on
        if current_section == "types" and stripped.endswith(":") and not stripped.startswith("-") and indent == 2:
            current_table = stripped[:-1]
            output_lines.append(line)
            i += 1
            continue
        
        # if in types and found column
        if current_section == "types" and current_table and indent == 4 and ":" in stripped and not stripped.startswith("-"):
            # get column name
            column_name = stripped.split(":", 1)[0].strip()

            is_multiline = False
            next_index = i + 1
            while next_index < len(lines):
                # get next line 
                next_line = lines[next_index].strip()

                if not next_line:
                    next_index += 1
                    continue

                # check if there is format/-/values -> this is checked by another function
                if next_line.startswith("format:") or next_line.startswith("-") or next_line == "values:":
                    is_multiline = True

                break

            if not is_multiline:
                # does column exist in samples
                is_in_samples = (current_table in samples and column_name in samples[current_table])
                # does exist in schema
                is_in_schema = f"{current_table}.{column_name}" in used_in_schema
                # does exist in values or email domains
                is_in_refs = f"{current_table}.{column_name}" in used_in_values or column_name == "email_domains"

                is_in_constraints = f"{current_table}.{column_name}" in used_in_constraints

                if not is_in_samples and not is_in_schema and not is_in_refs and not is_in_constraints:
                    # increment repair_count
                    repair_counts["unused_types_removed"] += 1
                    logger_setup.logger.warning(f"[Repair] Removed redundant type: '{current_table}.{column_name}'")
                    # does not add to output lines and moves on
                    i += 1
                    continue

        output_lines.append(line)
        i += 1

    return "\n".join(output_lines)

def fix_pk_seq(yaml_str: str, samples: dict, fk_map: dict, repair_counts) -> str:
    output_lines = []
    current_section = None
    current_table = None

    lines = yaml_str.splitlines()

    for line in lines:
        stripped = line.strip()
        indent = len(line) - len(line.lstrip())

        # if in one of YAML sections
        if stripped in ["types:", "schema:", "generate:", "constraints:", "include:"]:
            current_section = stripped[:-1]
            output_lines.append(line)
            continue

        # if in types and found table
        if current_section == "types" and indent == 2 and stripped.endswith(":"):
            current_table = stripped[:-1]
            output_lines.append(line)
            continue
        
        #if in types and found column
        if current_section == "types" and current_table and indent == 4 and ":" in stripped and not stripped.startswith("-"):
            column = stripped.split(":", 1)[0].strip()

            # get information from samples
            column_info = samples[current_table][column] if (current_table in samples and column in samples[current_table]) else {}
            # check if foreign_key
            is_fk = (column in fk_map[current_table]) if current_table in fk_map else False
            #check if primary_key
            is_pk = column_info["is_pk"] if "is_pk" in column_info else False
            # get sequence
            sequence = column_info["seq"] if "seq" in column_info else ""

            if is_pk and not is_fk and sequence:
                value = stripped.split(":", 1)[1].strip().strip("'\"")
                if not value.startswith("seq"):
                    repair_counts["fix_pk_seq"] += 1
                    logger_setup.logger.warning(f"[Repair] PK {current_table}.{column}: {value} -> {sequence}")
                    output_lines.append(f"    {column}: {sequence}")
                    continue
            
        output_lines.append(line)
    
    return "\n".join(output_lines)


def fix_generated_yaml(yaml_str: str, samples: dict, columns_in_tables, repair_counts) -> tuple[str, dict[str, int]]:
    # if no YAML was generated
    if not yaml_str:
        return yaml_str, repair_counts

    # remove yaml comments
    yaml_str = strip_yaml_comments(yaml_str)

    lines = yaml_str.splitlines()
    repaired_lines: list = []
    
    current_section = None
    current_table = None
    found_domains = []
    db_table_names = {table.lower(): table for table in samples.keys()}
    has_email_domain_in_types = False
    is_skipping_invalid_domain = False
    
    state = {"has_refs_in_block": False, "in_blocks_list": False}

    i = 0
    # go over lines in YAML
    while i < len(lines):
        line = lines[i]
        stripped = line.strip()
        indent_len = len(line) - len(line.lstrip())

        if stripped in ["types:", "schema:", "generate:", "constraints:", "include:"]:
            # if in types -> go voer and check email domains
            if current_section == "types":
                append_email_domains(repaired_lines, found_domains, has_email_domain_in_types)
            
            found_domains = []
            has_email_domain_in_types = False
            current_section = stripped[:-1]
            repaired_lines.append(line)
            i += 1
            is_skipping_invalid_domain = False
            continue
        
        # ignore empty lines and move on
        if not stripped:
            repaired_lines.append(line)
            i += 1
            continue
        
        # if in types/schema and found table
        if current_section in ["types", "schema"] and stripped.endswith(":") and not stripped.startswith("-") and indent_len == 2:
            # if in types -> go over and check email domains
            if current_section == "types":
                append_email_domains(repaired_lines, found_domains, has_email_domain_in_types)
            
            found_domains = []
            has_email_domain_in_types = False
            current_table_raw = stripped[:-1]
            # if table name in samples
            if current_table_raw in samples:
                current_table = current_table_raw

            # check if table exist with different capitalization    
            elif current_table_raw.title() in samples:
                current_table = current_table_raw.title()
            
            elif current_table_raw.lower() in db_table_names:
                current_table = db_table_names[current_table_raw.lower()]
            
            is_skipping_invalid_domain = False

        # check if BLOCKS next
        if current_section == "types" and ":" in stripped and not stripped.startswith("-"):
            state["has_refs_in_block"] = False
            state["in_blocks_list"] = ("- BLOCKS" in stripped or (i + 1 < len(lines) and lines[i+1].strip() == "- BLOCKS"))

        # check for email domain
        if current_section == "types" and indent_len == 4 and "email_domains" in stripped:
            line = f"{line[:line.find(stripped)]}email_domains:"
            stripped = "email_domains:"
            has_email_domain_in_types = True


        if current_section == "types" and current_table:
            # check if email domain somewhere where they should not be
            if stripped.startswith("email_domains:") and indent_len > 4:
                is_skipping_invalid_domain = True
                # increment repair count
                repair_counts["bad_domain_blocks_removed"] += 1
                i += 1
                continue
            
            # gets domains
            if is_skipping_invalid_domain and stripped.startswith("-"):
                raw_domain = stripped[1:].strip().strip("'\"")
                # skips BLOCKS
                if raw_domain.upper() != "BLOCKS":
                    # removes @ -> @google.com ---> google.com
                    domain_clean = raw_domain.replace("@", "").strip() 

                    # checks if domain looks okay and saves it into found_domains
                    domain_pattern = r"^[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)+$"
                    match = bool(re.match(domain_pattern, domain_clean))
                    if  match and not domain_clean.endswith("."):
                        found_domains.append(domain_clean)
                i += 1
                continue
            
            # invalid block is over 
            if is_skipping_invalid_domain and not stripped.startswith("-") and indent_len <= 4:
                is_skipping_invalid_domain = False
        # if in types and inside table -> check references and fix them
        if current_section == "types" and current_table and stripped.startswith("-"):
            fix_references(line, stripped, current_table, samples, repaired_lines, found_domains, repair_counts, state)
            i += 1
            continue

        # if in types -> fix blocks
        if current_section == "types":
            new_index, was_processed = fix_blocks(lines, i, line, stripped, current_table, samples, repaired_lines, repair_counts, state)
            # if processed -> move on
            if was_processed:
                i = new_index
                continue
        
        # if not fixed aboove -> send to fix_types_and_schema
        line = fix_types_and_schema(line, stripped, current_section, current_table, db_table_names, samples, columns_in_tables, repair_counts)   
        repaired_lines.append(line)
        i += 1

    # connect lines into one YAML
    cleaned_yaml = "\n".join(repaired_lines)
    
    # send to check format
    validated_yaml = check_format(cleaned_yaml, samples, repair_counts)
    # send to fill in missing columns
    completed_yaml = fill_in_missing_columns(validated_yaml, samples, repair_counts)
    # send to remove unused types
    final_yaml = remove_unused_types(completed_yaml, samples, repair_counts)
    
    # return final_yaml and repair_counts
    return final_yaml, repair_counts



def fix_interval_number(types_yaml, repair_counts):

    result = []
    lines = types_yaml.splitlines()

    param_pattern = r"(dinterval|finterval|interval|seq|str_len)\(([^)]*)\)"

    for line in lines:
        # go over lines and split the by :
        line_match = re.search(param_pattern, line)

        if not line_match:
            result.append(line)
            continue

        data_type_name = line_match.group(1)
        inside_nums = line_match.group(2)
        
        # if found d/f/interval, seq or strl_len data type to check


        # split numbers by , and remove whitespace
        args_split = [arg.strip() for arg in inside_nums.split(",") if arg.strip()]

        if len(args_split) < 1:
            result.append(line)
            continue

        is_valid = False
        step_value = ""
        min_value = args_split[0].strip("'\"")
        max_value = args_split[1].strip("'\"") if len(args_split) >= 2 else ""

            
        if data_type_name == "str_len":
            try:
                
                if len(args_split) == 1:
                    arg_raw = args_split[0].strip()

                    match = re.search(r"(\[[cCdsS\s]+\])", arg_raw)
                    prefix = match.group(1).replace(" ", "") if match else ""

                    value = re.sub(r"\[.*?\]", "", arg_raw).strip()

                    operator_match = re.search(r"(>=|>|<=|<)", value)
                    operator = operator_match.group(1) if operator_match else ""

                    digit_match = re.search(r"(\d+)", value)
                    if digit_match:
                        number = digit_match.group(1)
                        if prefix:
                            full_value = f"{prefix} {operator}{number}".strip() 
                        else:
                            full_value = f"{operator}{number}"

                        min_value = full_value
                        is_valid = True
                    else:
                        min_value = "1"
                        is_valid = True
                
                elif len(args_split) > 1:
                    min_raw   = min_value.replace("[", "").replace("]", "").strip()
                    match  = re.match(r"^([cCdsS ]+)", min_raw)
                    prefix = match.group(1).strip() if match else ""

                    min_value = re.sub(r"[^\d]", "", min_raw).strip()

                    max_raw   = max_value.replace("[", "").replace("]", "").strip()
                    max_value = re.sub(r"[^\d]", "", max_raw).strip()

                    if not min_value or not max_value:
                        logger_setup.logger.warning(f"No valid numbers found inside str_len. Replace with placeholder values str_len(1,10). Please replace them if needed")
                        min_value = "1"
                        max_value = "10"

                    if int(min_value) > int(max_value):
                        min_value, max_value = max_value, min_value
                    
                    is_valid = (int(min_value) <= int(max_value))
                    if prefix:
                        prefix = prefix.replace(" ", "")
                        if prefix:
                            min_value = f"[{prefix}]{min_value}"
                    
            except ValueError:
                is_valid = False 

        elif data_type_name == "seq":
            step_value = args_split[2] if len(args_split) >= 3 else "1"
            try:

                if len(args_split) == 1:
                    max_value = str(int(min_value) + 1)

                if (int(min_value) > int(max_value)):
                    min_value, max_value = max_value, min_value

                if (int(step_value) <= 0):
                    step_value = "1"
                is_valid = (int(min_value) < int(max_value)) and int(step_value) > 0

            except ValueError:
                is_valid = False
        # if dates -> get min max values, compare them
            
        elif data_type_name == "dinterval":

            if len(args_split) == 1:
                try:
                    date = datetime.strptime(min_value, "%Y-%m-%d")
                    max_value = (date + timedelta(days = 1)).strftime("%Y-%m-%d")
                    is_valid = True
                except ValueError:
                    is_valid = False
            else:
                min_value = re.sub(r"[T]", " ", min_value)
                max_value = re.sub(r"[T]", " ", max_value)
                is_valid = True

            if is_valid:
                if min_value > max_value:
                    min_value, max_value = max_value, min_value
                is_valid = (min_value < max_value)
        
        #if int -> convert to int, get min max value and compare them    
        elif data_type_name == "interval":
            try:
                if len(args_split) == 1:
                    max_value = str(int(min_value) + 1)
            
                if (int(min_value) > int(max_value)):
                    min_value, max_value = max_value, min_value
    
                is_valid = (int(min_value) < int(max_value))
            except ValueError:
                time_pattern = r"^([0-1]?[0-9]|2[0-3]):[0-5][0-9](:[0-5][0-9])?$"

                is_min_time = bool(re.match(time_pattern, min_value))
                is_max_time = bool(re.match(time_pattern, max_value)) if max_value else True

                if is_min_time and is_max_time:
                    time_regex = "'([0-1][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]'"
                    fixed_line = f"regex({time_regex})"
                    logger_setup.logger.warning(f"[Repair] Fixed hallucinated numbers inside {data_type_name}. Changed to time regex")
                    repair_counts["interval_num_fix"] += 1

                    start, end = line_match.span()
                    fixed_line = line[:start] + fixed_line + line[end:]
                    result.append(fixed_line)
                    continue
                else:
                    result.append(line)
                    continue
        #if float -> convert to int, get min max value and compare them

        else:
            try:
                if len(args_split) == 1:
                    max_value = str(float(min_value) + 1.0)
                if (float(min_value) > float(max_value)):
                    min_value, max_value = max_value, min_value
                is_valid = (float(min_value) < float(max_value))

            except ValueError:
                is_valid = False
        # if conversion passed or min < max add fixed line to the rest of lines
        if is_valid:
            args_list = [value for value in [min_value, max_value, step_value] if value != ""]
            # mention repairs only if it is worth mentioning (removal of whtespaces is not)
            if args_split != args_list:
                logger_setup.logger.warning(f"[Repair] Fixed invalid numbers inside {data_type_name}")
                repair_counts["interval_num_fix"] += 1
            
            start, end = line_match.span()
            fixed_line = f"{data_type_name}({','.join(args_list)})"
            fixed_line = line[:start] + fixed_line + line[end:]
            result.append(fixed_line)
            continue
        else:
            result.append(line)
    

    return "\n".join(result)


def save_repair_report_to_csv(repair_counts: dict[str, int], db_name: str):

    file_path = f"results/csv/repair_stats-{db_name}.csv"
    is_empty = not os.path.exists(file_path) or os.path.getsize(file_path) == 0
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    with open(file_path, mode="a", newline="", encoding="utf-8") as file:
        writer = csv.writer(file)

        if is_empty:
            writer.writerow(["timestamp", "repair_type", "count"])

        for repair_type, count in repair_counts.items():
            writer.writerow([timestamp, repair_type, count])
    logger_setup.logger.info(f"Repair report summary successfully saved into {file_path}")

def strip_yaml_comments(yaml_str: str) -> str:

    clean_lines = []
    for line in yaml_str.splitlines():
        if line.strip().startswith("#"):
            continue
        if " #" in line:
            if "'" not in line and '"' not in line:
                line = line.split(" #")[0]
        clean_lines.append(line)
    return "\n".join(clean_lines)

def yaml_bool(value: str, repair_counts: dict) -> str:
    yaml_bool_keywords = ["y", "n", "yes", "no", "true", "false", "on", "off"]
    if value.lower() in yaml_bool_keywords:
        repair_counts["yaml_bool"] += 1
        value = value.strip("'\"")
        return f"'{value}'"
    return value

def generate_yaml(samples, sql_server_type, fk_map, gen_count, db_name):
    logger_setup.logger.info(f"FK_MAP = {fk_map}")
    sorted_table_names = sort_tables_multi_level(fk_map)
    sorted_samples = {table: samples[table] for table in sorted_table_names if table in samples}

    columns_in_tables = {} 
    for table_name, table_data in samples.items():
        columns_in_tables[table_name.lower()] = {column.lower(): column for column in table_data.keys()}

    db_table_names = {table.lower(): table for table in samples.keys()}

    repair_counts = {
        "include_generated": 0,
        "foreign_key_schema": 0,
        "schema_value_casing": 0,
        "inline_blocks_fix": 0,
        "filled_empty_blocks": 0,
        "text_to_string_fix": 0,
        "unfinished_reference_fix": 0,
        "email_duplication_fix": 0, 
        "email_format_fix": 0,
        "bad_domain_blocks_removed": 0,
        "schema_table_fix": 0,
        "schema_column_fix": 0,
        "generate_row_count_fix": 0,
        "regex_quoting_fix": 0,
        "invalid_constraint_removed": 0,
        "invalid_schema_removed": 0,
        "schema_missing_columns_fix": 0,
        "wrong_format_structure": 0,
        "unused_types_removed": 0,
        "invalid_dataset_fix": 0,
        "fix_pk_seq": 0,
        "interval_num_fix": 0,
        "yaml_bool": 0,
        "single_item_list_fix": 0    
    }

    types_raw       = generate_yaml_prompt(sorted_samples, None, sql_server_type, "yaml-generator-types", "types")
    include_raw     = generate_yaml_include(types_raw)
    schema_raw      = generate_yaml_prompt(None, types_raw, sql_server_type, "yaml-generator-schema", "schema")
    generate_raw    = generate_yaml_prompt(None, types_raw, sql_server_type, "yaml-generator-generate", "generate")
    constraints_raw = generate_yaml_prompt(None, types_raw, sql_server_type, "yaml-generator-constraints", "constraints")
    
    raw_yaml = (
        f"{include_raw}\n"
        f"{types_raw}\n"
        f"{schema_raw}\n"
        f"{generate_raw}\n"
        f"{constraints_raw}"
    )

    types_filtered = types_raw.replace(".format", "")
    types_filtered = fix_regex_quoting(types_filtered, repair_counts)
    types_filtered = fix_interval_number(types_filtered, repair_counts)
    include_filtered = generate_yaml_include(types_filtered)

    if "include:" in include_filtered and "include: []" not in include_filtered:
        for include in include_filtered.splitlines():
            if "-" in include:
                repair_counts["include_generated"] += 1

    schema_filtered      = apply_fk_to_schema(schema_raw, fk_map, repair_counts)
    schema_filtered      = go_over_schema(schema_filtered, samples, repair_counts)
    generate_filtered    = go_over_generate(gen_count, samples, generate_raw, repair_counts)
    constraints_filtered = filter_constraints(constraints_raw, samples, db_table_names, columns_in_tables, repair_counts)
    
    filtered_yaml = (
        f"{include_filtered}\n"
        f"{types_filtered}\n"
        f"{schema_filtered}\n"
        f"{generate_filtered}\n"
        f"{constraints_filtered}"
    )

    fixed_yaml, repair_counts = fix_generated_yaml(filtered_yaml, samples, columns_in_tables, repair_counts)

    fixed_yaml = fix_regex_quoting(fixed_yaml, repair_counts)
    fixed_yaml = fix_interval_number(fixed_yaml, repair_counts)
    
    fixed_yaml = fix_pk_seq(fixed_yaml, samples, fk_map, repair_counts)
    
    yaml_generator.save_original_yaml(raw_yaml, db_name)
    save_repair_report_to_csv(repair_counts, db_name)

    return fixed_yaml