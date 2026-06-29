import argparse
import getpass
import db_connector
import data_sampler
import llm_processor
import schema_extractor
import yaml_generator
import logging
import colorlog
import ollama
import time
import httpx
import logger_setup


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

    is_composite_key = len(prime_keys) > 1

    for column in columns:
        column_name = column[0]

        if column_name not in prime_keys:
            template = data_sampler.data_samples_template(table_name, column_name, limit)
            result = schema_extractor.execute_sql(server, template) 
            cl_rows = [row[0] for row in result if row and len(row) > 0 and row[0] is not None]
            count_distinct_in_sample = len(set(cl_rows))
            samples[table_name][column_name] = {"is_pk": False, "distinct_count_in_sample": count_distinct_in_sample, "samples": cl_rows[:10]}

            continue

        if is_composite_key:
            samples[table_name][column_name] = {"is_pk": True, "is_composite": True, "data_type": "composite-link", "note": "This column is part of a composite primary key (M:N relationship)."}
            generate_count[table_name] = row_count
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
            samples[table_name][column_name] = {"is_pk": True, "data_type": "numeric", "seq": f"seq({min_val}, {max_val}, 1)"}
            generate_count[table_name] = max_val - min_val + 1


        except (ValueError, TypeError):
            sample_template = data_sampler.data_samples_template(table_name, column_name, limit)
            raw_samples = schema_extractor.execute_sql(server, sample_template)

            cl_samples = [row[0] for row in raw_samples if row and len(row) > 0 and row[0] is not None]


            samples[table_name][column_name] = {"is_pk": True, "data_type": "non-numeric", "samples": cl_samples[:10]}
            generate_count[table_name] = row_count
    
        except Exception as e:
            logger_setup.logger.error(f"Failed to process table {table_name}: {e}", exc_info=True)
    
            
    return samples, generate_count

def go_over_foreign_keys(fk_result, fk_map, table_name):
    for row in fk_result:
        local_col = row[0]
        ref_table = row[1]
        ref_col   = row[2]

        if ref_table is None:
            continue

        fk_map[table_name][local_col] = (ref_table, ref_col)

    return fk_map



def get_result(db_name, table_name, server, sql_type):
    schema_extractor.error_check(sql_type, table_name)
    template = schema_extractor.mysql_query_templates(sql_type)
    sql_query = llm_processor.generate_sql_query(template,  db_name, table_name)
    result = schema_extractor.execute_sql(server, sql_query)

    if sql_type == "tables" and len(result) == 0:
        logger_setup.logger.error("Db has no data. Cannot generate YAML.")
        return

    return result

def main():

    
    start_time  = time.time()
    args        = parse_arguments()
    host        = args.host
    user        = args.user
    db_name     = args.db
    no_password = args.no_password
    

 
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
        if tables is None:
            return
        
        logger_setup.logger.info(f"Found {len(tables)} table(s) => {[table[0] for table in tables]}, ")
        samples = {}
        fk_map = {}
        generate_count = {}


        for table in tables:
            table_name = table[0]
            
            try:
                samples[table_name] = {}

                logger_setup.logger.info(f"table: {table_name}")
                
                columns = get_result(db_name, table_name, server, "columns")

                fk_result = get_result(db_name, table_name, server, "foreign_keys")

                fk_map[table_name] = {}
                
                fk_map = go_over_foreign_keys(fk_result, fk_map, table_name)

                logger_setup.logger.debug(f"Found columns in {table_name}: {[c[0] for c in columns]}")
                prime_keys = []

                
                count_result = get_result(db_name, table_name, server, "count")
                prime_key = get_result(db_name, table_name, server, "prime_keys")

                if not count_result or not count_result[0]:
                    logger_setup.logger.warning(f"Could not get row count for table {table_name}")
                    continue

                row_count = count_result[0][0]
                limit = data_sampler.calculate_limit(row_count)

                logger_setup.logger.debug("Entering second column loop")

                prime_keys += go_over_prime_keys(prime_key)
                samples, generate_count = go_over_columns(columns, table_name, limit, server, prime_keys, samples, generate_count, db_name, row_count)

            except (IndexError, ValueError, KeyError):
                logger_setup.logger.error(f"Failed to process table {table_name}")
                continue
            except Exception:
                logger_setup.logger.error(f"Unexpected error in table {table_name}")
                continue


        if not samples:
            logger_setup.logger.error("Could not get samples from any tables")
        else:
            logger_setup.logger.debug(f"Sending samples to LLM for YAML generation \n{samples}")

            yaml_str = llm_processor.generate_yaml(samples, "MySQL", fk_map, generate_count)
            logger_setup.logger.debug(f"Generated YAML:\n{yaml_str}")
            
            errors = []
            errors = yaml_generator.validate_yaml(db_name, yaml_str)
            yaml_generator.save_csv(errors, db_name)

    except (RuntimeError, IndexError) as exc:
        logger_setup.logger.error(f"Error: {exc}")
        
    finally:
        db_connector.disconnect_from_mysql(server)
    
    elapsed = time.time() - start_time
    minutes = int(elapsed // 60)
    seconds = int(elapsed % 60)
    logger_setup.logger.info("Done")
    logger_setup.logger.info(f"Total execution time: {minutes}m {seconds}s")
    

if __name__ == "__main__":
    main()

