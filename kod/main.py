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
from yaml_generator import YAML_result

handler = colorlog.StreamHandler()
handler.setFormatter(colorlog.ColoredFormatter(
	'%(asctime)s %(log_color)s %(message)s',
    datefmt='%Y-%m-%d %H:%M:%S'))


logging.getLogger("mysql.connector").setLevel(logging.WARNING)
logging.getLogger("psycopg2").setLevel(logging.WARNING)

logger = logging.getLogger("MAIN")
logger.addHandler(handler)
logger.setLevel(logging.INFO)
logger.propagate = False



def parse_arguments():
    parser = argparse.ArgumentParser(
        description="Generates Dataster YAML configuration using LLM"
    )

    parser.add_argument("-d", "--db_server", required=True, help="Database server (mysql/postgresql)")
    parser.add_argument("--host", required=True, help="Database host")
    parser.add_argument("--user", required=True, help="Database user")
    parser.add_argument("--db", required=True, help="Database name")
    parser.add_argument("--no-password", action="store_true", help="Connect without password")
    parser.add_argument("--password", default=None, help="Database password")
    return parser.parse_args()
    



def check_if_server_exists(db_server):
    if db_server not in ("MySQL", "mysql", "PostgreSQL", "postgresql"):
        db_connector.logger.error("Server not recognized")
        return False
    return True


def choose_server(db_server, host, user, db_name, password):
    if db_server in ("MySQL", "mysql"):
        return db_connector.connect_to_mysql(host,user,password, db_name)  
    elif db_server in ("PostgreSQL", "postgresql"):
        return db_connector.connect_to_postgresql(db_name, host, user, password)


def disconnect(db_server,server):
    if db_server in ("MySQL", "mysql"):
        return db_connector.disconnect_from_mysql(server)
    elif db_server in ("PostgreSQL", "postgresql"):
        return db_connector.disconnect_from_postgresql(server)


def check_ollama_models():
    try:
        response = ollama.list()        
    except (httpx.ConnectError, httpx.ConnectTimeout) as err:
        logger.error(f"{err}")
        return False
    if not hasattr(response, "models") or not response.models:
        logger.error("Ollama has no models")
        return False

    found_models = [(model.model).split(":")[0] for model in response.models]

    required_models = ["yaml-generator-types", "yaml-generator-constraints", "yaml-generator-schema", "yaml-generator-generate", "yaml-generator-sql"]

    missing_models = [ model for model in required_models if model not in found_models]
    if missing_models:
        logger.error(f"Ollama is missing one of required models: {missing_models}")
        return False
    
    logger.info("Ollama is running with all required models")
    return True 

def go_over_prime_keys(p_keys: list[tuple]):
    extracted_pks = []
    for pk in p_keys:
        if not isinstance(pk, (tuple, list)) or len(pk) < 5:
            if len(pk) == 1 and isinstance(pk[0], str):
                extracted_pks.append(pk[0])
            else:
                logger.error(f"Unexpected format of prime keys: {pk}")
            continue
        if pk[2] == "PRIMARY":
            extracted_pks.append(pk[4])
            logger.info("Successful extraction of prime key")
        else:
            logger.warning(f"Unexpected prime key information {pk}")

    return extracted_pks


def go_over_columns(columns, table_name, limit, server, prime_keys, samples, generate_count, db_name, row_count):

    is_compostie_key = len(prime_keys) > 1

    for column in columns:
        column_name = column[0]

        if column_name in prime_keys:
            logger.debug(f"2nd column loop: prime key: {column_name}")

            if is_compostie_key:
                samples[table_name][column_name] = {"is_pk": True, "is_composite": True, "data_type": "composite-link", "note": "This column is part of a composite primary key (M:N relationship)."}
                generate_count[table_name] = row_count
                logger.info(f"Compiste prime key samples[table_name][column_name] = {samples[table_name][column_name]}")
            else:
                pk_template = data_sampler.prime_keys_template(table_name, column_name)
                pk_result   = schema_extractor.execute_sql(server, pk_template)
                min_val = pk_result[0][0]
                max_val = pk_result[0][1]

                try:
                    min_val = int(min_val)
                    max_val = int(max_val)
                    samples[table_name][column_name] = {"is_pk": True, "data_type": "numeric", "seq": f"seq({min_val}, {max_val}, 1)"}
                    generate_count[table_name] = max_val - min_val + 1

                    logger.debug(f"samples[table_name][column_name] = {samples[table_name][column_name]}")
                except (ValueError, TypeError):

                    sample_template = data_sampler.data_samples_templates(table_name, column_name, limit)
                    raw_samples = schema_extractor.execute_sql(server, sample_template)

                    cl_samples = [row[0] for row in raw_samples if row[0] is not None]

                    samples[table_name][column_name] = {"is_pk": True, "data_type": "non-numeric", "samples": cl_samples[:10]}
                    generate_count[table_name] = row_count
                
        else:
            template = data_sampler.data_samples_templates(table_name, column_name, limit)
            result = schema_extractor.execute_sql(server, template) 
            cl_rows = [row[0] for row in result if row[0] is not None]
            count_distinct_in_sample = len(set(cl_rows))
            samples[table_name][column_name] = {"is_pk": False, "distinct_count_in_sample": count_distinct_in_sample, "samples": cl_rows[:10]}

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



def get_result(db_server, db_name, table_name, server, sql_type):
    schema_extractor.error_check(sql_type, table_name)
    template = schema_extractor.mysql_query_templates(sql_type)
    sql_query = llm_processor.generate_sql_query(template, db_server, db_name, table_name)
    result = schema_extractor.execute_sql(server, sql_query)

    if sql_type == "tables" and len(result) == 0:
        logger.error("Db has no data. Cannot generate YAML.")
        return

    return result

def main():

    
    start_time  = time.time()
    args        = parse_arguments()
    db_server   = args.db_server
    host        = args.host
    user        = args.user
    db_name     = args.db
    no_password = args.no_password
    errors      = []
 
    if not check_if_server_exists(db_server):
        return
    
    if not check_ollama_models():
        return
    

    if args.password is not None:
        password = args.password
    elif no_password:
        password = ""
    else:
        password = getpass.getpass("Enter password: ")
        
    server   = choose_server(db_server, host, user, db_name, password)

    if server is None:
        raise RuntimeError("Couldn't connect to server")
    
    if db_server in ("MySQL", "mysql"):
        try:
            tables = get_result(db_server, db_name, None, server, "tables")
            if tables is None:
                return
            logger.info(f"Found {len(tables)} table(s) => {[table[0] for table in tables]}, ")
            samples = {}
            fk_map = {}
            generate_count = {}
            i = 0
            for table in tables:
                i+=1
                table_name = table[0]
                samples[table_name] = {}
                logger.info(f"{i} Processing table: {table_name}")
                
                columns = get_result(db_server, db_name, table_name, server, "columns")

                fk_result = get_result(db_server, db_name, table_name, server, "foreign_keys")

                fk_map[table_name] = {}
                
                fk_map = go_over_foreign_keys(fk_result, fk_map, table_name)

                logger.debug(f"Found columns in {table_name}: {[c[0] for c in columns]}")
                prime_keys = []

                
                count_result = get_result(db_server, db_name, table_name, server, "count")
                
                prime_key = get_result(db_server, db_name, table_name, server, "prime_keys")

                row_count = count_result[0][0]
                limit = data_sampler.calculate_limit(row_count)

                logger.debug("Entering second column loop")

                prime_keys += go_over_prime_keys(prime_key)
                samples, generate_count = go_over_columns(columns, table_name, limit, server, prime_keys, samples, generate_count, db_name, row_count)

            logger.debug(f"Sending samples to LLM for YAML generation \n{samples}")

            yaml_str = llm_processor.generate_yaml(samples, "MySQL", fk_map, generate_count)
            logger.debug(f"Generated YAML:\n{yaml_str}")
            errors += yaml_generator.validate_yaml(db_name, yaml_str)
            yaml_generator.save_csv(errors, db_name)
        except (RuntimeError, IndexError) as exc:
            logger.error(f"Error: {exc}")
            
        finally:
            disconnect(db_server, server)
    
    elapsed = time.time() - start_time
    minutes = int(elapsed // 60)
    seconds = int(elapsed % 60)
    logger.info("Done")
    logger.info(f"Total execution time: {minutes}m {seconds}s")
    

if __name__ == "__main__":
    main()

