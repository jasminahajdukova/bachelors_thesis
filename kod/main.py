import argparse
import getpass
import db_connector
import data_sampler
import llm_processor
import schema_extractor
import yaml_generator
import ollama
import time
import httpx
import logger_setup
import os
from llm_processor import CyclicDependencyError
from prompts import json_decimal
def parse_arguments():
    parser = argparse.ArgumentParser(
        description="Generates Dataster YAML configuration using LLM"
    )

    parser.add_argument("--host", required=True, help="Database host")
    parser.add_argument("--user", required=True, help="Database user")
    parser.add_argument("--db", required=True, help="Database name")
    parser.add_argument("--no-password", action="store_true", help="Connect without password")
    parser.add_argument("--password", default=None, help="Database password")
    return parser.parse_args()
    


def check_ollama_models():
    try:
        response = ollama.list()        
    except (httpx.ConnectError, httpx.ConnectTimeout) as err:
        logger_setup.logger.error(f"{err}")
        return False
    if not hasattr(response, "models") or not response.models:
        logger_setup.logger.error("Ollama has no models")
        return False

    found_models = [(model.model).split(":")[0] for model in response.models]

    required_models = ["yaml-generator-types", "yaml-generator-constraints", "yaml-generator-schema", "yaml-generator-generate"]



    missing_models = [ model for model in required_models if model not in found_models]
    if missing_models:
        logger_setup.logger.error(f"Ollama is missing one of required models: {missing_models}")
        return False
    
    logger_setup.logger.info("Ollama is running with all required models")
    return True 

def go_over_prime_keys(p_keys: list[tuple]):
    extracted_pks = []
    req_length = 2
    for pk in p_keys:
        if not isinstance(pk, (tuple, list)):
            logger_setup.logger.error(f"Unexpected data type for prime keys {type(pk)}")
            continue

        if len(pk) == 1:
            if isinstance(pk[0], str):
                extracted_pks.append(pk[0])
            else:
                logger_setup.logger.error(f"Unexpected format of prime keys: {pk}")
            continue

        if len(pk) < req_length: 
            logger_setup.logger.error(f"Unexpected tuple length for prime keys")
            continue
        
        key_name = pk[0]
        column_name = pk[1]

        if key_name == "PRIMARY":
            extracted_pks.append(column_name)
            logger_setup.logger.info("Successful extraction of prime key")
        else:
            logger_setup.logger.warning(f"Unexpected prime key information {pk}")

    return extracted_pks


def go_over_columns(columns, table_name, limit, server, prime_keys, samples, generate_count, db_name, row_count):
    

    for column in columns:
        column_name  = column[0]
        db_data_type = column[1] if len(column) > 1 else "unknown"

        if column_name not in prime_keys:
            template = data_sampler.data_samples_template(table_name, column_name, limit)
            result = schema_extractor.execute_sql(server, template) 
            cl_rows = [json_decimal(row[0]) for row in result if row and len(row) > 0 and row[0] is not None]
            count_distinct_in_sample = len(set(cl_rows))
            samples[table_name][column_name] = {"is_pk": False, "db_type": db_data_type, "distinct_count_in_sample": count_distinct_in_sample, "samples": cl_rows[:10]}

            continue

        pk_template = data_sampler.prime_keys_template(table_name, column_name)
        pk_result   = schema_extractor.execute_sql(server, pk_template)

        if not pk_result or not pk_result[0]:
            logger_setup.logger.warning(f"No primary key for table {table_name}")
            continue

        min_val = pk_result[0][0]
        max_val = pk_result[0][1]
        
        if min_val is None or max_val is None:
            logger_setup.logger.warning(f"Table {table_name} appears to be empty.")
            continue

        try:
            min_val = int(min_val)
            max_val = int(max_val)
            samples[table_name][column_name] = {"is_pk": True, "db_type": db_data_type, "data_type": "numeric", "seq": f"seq({min_val}, {max_val}, 1)"}
            generate_count[table_name] = max_val - min_val + 1


        except (ValueError, TypeError):
            sample_template = data_sampler.data_samples_template(table_name, column_name, limit)
            raw_samples = schema_extractor.execute_sql(server, sample_template)

            cl_samples = [json_decimal(row[0]) for row in raw_samples if row and len(row) > 0 and row[0] is not None]


            samples[table_name][column_name] = {"is_pk": True, "db_type": db_data_type, "data_type": "non-numeric", "samples": cl_samples[:10]}
            generate_count[table_name] = row_count
    
        except Exception as e:
            logger_setup.logger.error(f"Failed to process table {table_name}: {e}", exc_info=True)
    
            
    return samples, generate_count

def go_over_foreign_keys(fk_result, fk_map, table_name, valid_tables):
    for row in fk_result:
        local_col = row[0]
        ref_table = row[1]
        ref_col   = row[2]

        if ref_table is None:
            continue

        if valid_tables is not None and ref_table not in valid_tables:
            logger_setup.logger.warning(f"Ignoring FK from {table_name}.{local_col} to exclude table {ref_table}")
            continue

        fk_map[table_name][local_col] = (ref_table, ref_col)

    return fk_map



def get_result(db_name, table_name, server, sql_type):
    schema_extractor.error_check(sql_type, table_name)
    template = schema_extractor.mysql_query_templates(sql_type)
    
    sql_query = llm_processor.generate_sql_query(template=template, db_name=db_name, table_name=table_name, )
    
 
    result = schema_extractor.execute_sql(server, sql_query)

    if sql_type == "tables" and len(result) == 0:
        logger_setup.logger.error("Db has no data. Cannot generate YAML.")
        return []

    return result

def main():

    
    start_time  = time.time()
    args        = parse_arguments()
    host        = args.host
    user        = args.user
    db_name     = args.db
    no_password = args.no_password
    errors = []

    os.makedirs("results/dataster", exist_ok=True)
    os.makedirs("results/original_yaml", exist_ok=True)
    os.makedirs("results/csv", exist_ok=True)
    os.makedirs("results/logs", exist_ok=True)
 
    if not check_ollama_models():
        return
    

    if args.password is not None:
        password = args.password
    elif no_password:
        password = ""
    else:
        password = getpass.getpass("Enter password: ")

        
    server = db_connector.connect_to_mysql(host,user,password, db_name)
    if server is None:
        raise RuntimeError("Couldn't connect to server")
    

    try:
        tables = get_result(db_name, None, server, "tables")
        if not tables:
            errors.append(yaml_generator.YAML_result(db_name, "preprocessing", "empty_database", 1, "Database has no tables to process"))
            yaml_generator.save_csv(errors, db_name)
            return
        
        logger_setup.logger.info(f"Found {len(tables)} table(s) => {[table[0] for table in tables]}, ")
        samples = {}
        fk_map = {}
        generate_count = {}

        valid_tables = set()
        table_pk = {}

        for table in tables:
            t_name = table[0]
            try:
                pk_buff = get_result(db_name, t_name, server, "prime_keys")
                prime_keys = go_over_prime_keys(pk_buff)
                table_pk[t_name] = prime_keys

                if len(prime_keys ) <= 1:
                    valid_tables.add(t_name)
            except Exception as  exc:
                logger_setup.logger.error(f"Prepass failed for table: {t_name}: {exc}")
                errors.append(yaml_generator.YAML_result(db_name, f"prepass:{t_name}", "table_prepass_failed", 2, f"Prepass failed for table: {t_name}: {exc}"))
                continue

        for table in tables:
            table_name = table[0]
            
            try:

                prime_keys = table_pk[table_name]

                fk_map[table_name] = {}

                if len(prime_keys) > 1:
                    logger_setup.logger.warning( f"""Table {table_name} has composite pk {prime_keys} \n
                                                This is excluded from generating as it is ouut of scope""")
                    
                    errors.append(yaml_generator.YAML_result(db_name, "preprocessing", "composite_pk", 2, f"""Table {table_name} has composite pk {prime_keys}. This is excluded from generating as it is ouut of scope""" ))
                    continue
                

                samples[table_name] = {}
                

                logger_setup.logger.info(f"table: {table_name}")
                
                columns = get_result(db_name, table_name, server, "columns")
                fk_result = get_result(db_name, table_name, server, "foreign_keys")

                for row in fk_result:
                    if row[1] and row[1] not in valid_tables:
                        errors.append(yaml_generator.YAML_result(db_name, "preprocessing", "excluded_dependency", 2, f"Table {table_name} references out of scope table {row[1]}"))

                fk_map = go_over_foreign_keys(fk_result, fk_map, table_name, valid_tables)

                logger_setup.logger.debug(f"Found columns in {table_name}: {[c[0] for c in columns]}")

                count_result = get_result(db_name, table_name, server, "count")
                if not count_result or not count_result[0]:
                    logger_setup.logger.warning(f"Could not get row count for table {table_name}")
                    continue

                row_count = count_result[0][0]
                limit = data_sampler.calculate_limit(row_count)

                logger_setup.logger.debug("Entering second column loop")

                
                samples, generate_count = go_over_columns(columns, table_name, limit, server, prime_keys, samples, generate_count, db_name, row_count)


            except (IndexError, ValueError, KeyError) as ivke:
                logger_setup.logger.error(f"Failed to process table {table_name}: {ivke}")
                errors.append(yaml_generator.YAML_result(db_name, "preprocessing", "table_processing", 1, f"Failed to process table {table_name}: {ivke}"))
                continue
            except Exception as e:
                logger_setup.logger.error(f"Unexpected error in table {table_name}: {e}")
                errors.append(yaml_generator.YAML_result(db_name, "preprocessing", "unexpected_table_error", 1, f"Unexpected error in table {table_name}: {e}"))
                continue
        
        yaml_was_generated = False

        if not samples:
            if not errors:
                errors.append(yaml_generator.YAML_result(db_name, "preprocessing", "invalid_samples", 1, "Could not get samples from any tables"))
            else:
                logger_setup.logger.warning("All tables skipped or resulted in composite/invalid samples. Skipped llm generation")
                errors.append(yaml_generator.YAML_result(db_name, "pipeline", "generation_skipped", 2, "All tables skipped or resulted in composite/invalid samples. Skipped llm generation"))

        else:
            logger_setup.logger.info(f"Sending samples to LLM for YAML generation \n{samples}")

            try:
                yaml_str = llm_processor.generate_yaml(samples, "MySQL", fk_map, generate_count, db_name)
                logger_setup.logger.debug(f"Generated YAML:\n{yaml_str}")   
                errors += yaml_generator.validate_yaml(db_name, yaml_str, samples)
                yaml_was_generated = True
            except CyclicDependencyError as cde:
                logger_setup.logger.error(f"Cylic FK dependency detected: {cde}")
                errors.append(yaml_generator.YAML_result(db_name, "preprocessing", "cyclic_fk", 1, f"Cylic FK dependency detected: {cde}" ))
            except ValueError as ve:
                logger_setup.logger.error(f"Internal generation errror: {ve}")
                errors.append(yaml_generator.YAML_result(db_name, "pipeline", "generation_error", 1, f"Internal generation errror: {ve}"))
            
        if yaml_was_generated and not any(e.severity == 1 for e in errors):
            errors.append(yaml_generator.YAML_result(db_name, "pipeline", "success", 0, "Successfully generated and validated YAML"))
        

        elif not yaml_was_generated and not any(e.severity == 1 for e in errors):
            errors.append(yaml_generator.YAML_result(db_name, "pipeline", "partial_skip", 0, "Pipeline skipped without any generation"))


        yaml_generator.save_csv(errors, db_name)

    except (RuntimeError, IndexError) as exc:
        logger_setup.logger.error(f"Error: {exc}")
        yaml_generator.save_csv([yaml_generator.YAML_result(db_name, "critical_collapse", "pipeline_crash", 1, str(exc))], db_name)
        
    finally:
        db_connector.disconnect_from_mysql(server)
    
    elapsed = time.time() - start_time
    minutes = int(elapsed // 60)
    seconds = int(elapsed % 60)
    logger_setup.logger.info("Done")
    logger_setup.logger.info(f"Total execution time: {minutes}m {seconds}s")
    

if __name__ == "__main__":
    main()

