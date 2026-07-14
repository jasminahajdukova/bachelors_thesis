
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
from typing import List, Tuple, Dict, Set, Any


DBMS_PROMPT = {
    "mysql": "MySQL",
    "postgresql": "PostgreSQL"
}

def get_dbms(name: str) -> str:
    return DBMS_PROMPT.get(name.lower(), name.capitalize())


def parse_arguments() -> argparse.Namespace:
    """
    Parser and validates CLI arguments

    @return: Namespace object containing the parsed arguments
    """

    parser = argparse.ArgumentParser(
        description="Generates Dataster YAML configuration using LLM"
    )

    parser.add_argument("--host", required=True, help="Database host")
    parser.add_argument("--user", required=True, help="Database user")
    parser.add_argument("--db", required=True, help="Database name")
    parser.add_argument("--no-password", action="store_true", help="Connect without password")
    parser.add_argument("--password", default=None, help="Database password")
    parser.add_argument("--dbms", type=str, default="mysql", help="Target DBMS")
    parser.add_argument("--port", type=int, default=None, help="Database port (optional)")

    return parser.parse_args()
    


def check_ollama_models() -> bool:
    """
    Checks if the Ollama service is running and checks if all required models exist
    
    @return: True is Ollama is available and all models exist, False otherwise
    """
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

def go_over_prime_keys(p_keys: list[Any]) -> List[str]:
    """
    Processes the primary key information and extracts valid column names

    @param p_keys: List of tuples or lists containing primary key information from the database
    @return: Clean list of column names that form the primary key
    """
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
        
        column_name = pk[1]

        if isinstance(column_name, str):
            extracted_pks.append(column_name)
            logger_setup.logger.info(f"Successful extraction of prime key column: {column_name}")
        else:
            logger_setup.logger.warning(f"Unexpected prime key information {pk}")

    return extracted_pks


def go_over_columns(columns: List[Tuple[Any, ...]], table_name: str, limit: int,
                    server: Any, prime_keys: List[str],
                    samples: Dict[str, Dict[str, Any]],
                    generate_count: Dict[str, int],
                    db_name: str, row_count: int) -> Tuple[Dict[str, Dict[str, Any]], Dict[str, int]]:
    """
    Iterates over all table columns, separates primary keys and collects data samples

    @param columns: List of column metadata extracted from the database schema
    @param table_name: Name of the current table that is being procesed
    @param limit: Maximum number of rows to query for samples
    @param server: MySQL database connection server instance
    @param prime_keys: List of column names that acts as primary keys for the table
    @param samples: Data samples are stored into this
    @param generate_count: Maps tables names to their expected generation row counts
    @param db_name: Name of the target database
    @param row_count: current total row count of the database table

    @return: Tuple containing the updated samples and the generate_count
    """

    for column in columns:
        column_name  = column[0]
        db_data_type = column[1] if len(column) > 1 else "unknown"

        if column_name not in prime_keys:
            template = data_sampler.data_samples_template(server, table_name, column_name, limit)
            result = schema_extractor.execute_sql(server, template) 
            
            cl_rows = [json_decimal(row[0]) for row in result if row and len(row) > 0 and row[0] is not None]
            count_distinct_in_sample = len(set(cl_rows))
            samples[table_name][column_name] = {"is_pk": False, "db_type": db_data_type, "distinct_count_in_sample": count_distinct_in_sample, "samples": cl_rows[:10]}

            continue

        pk_template = data_sampler.prime_keys_template(server, table_name, column_name)
        pk_result   = schema_extractor.execute_sql(server, pk_template)

        if not pk_result or not pk_result[0]:
            logger_setup.logger.warning(f"No primary key for table {table_name}")
            continue

        min_val = pk_result[0][0]
        max_val = pk_result[0][1]
        
        if min_val is None or max_val is None:
            logger_setup.logger.warning(f"Table {table_name} appears to be empty")
            continue

        try:
            min_val = int(min_val)
            max_val = int(max_val)
            samples[table_name][column_name] = {"is_pk": True, "db_type": db_data_type, "data_type": "numeric", "seq": f"seq({min_val}, {max_val}, 1)"}
            generate_count[table_name] = max_val - min_val + 1


        except (ValueError, TypeError):
            sample_template = data_sampler.data_samples_template(server, table_name, column_name, limit)
            raw_samples = schema_extractor.execute_sql(server, sample_template)

            cl_samples = [json_decimal(row[0]) for row in raw_samples if row and len(row) > 0 and row[0] is not None]


            samples[table_name][column_name] = {"is_pk": True, "db_type": db_data_type, "data_type": "non-numeric", "samples": cl_samples[:10]}
            generate_count[table_name] = row_count
    
        except Exception as e:
            logger_setup.logger.error(f"Failed to process table {table_name}: {e}", exc_info=True)
    
            
    return samples, generate_count

def go_over_foreign_keys(fk_result: List[Tuple[Any, ...]],
                         fk_map: Dict[str, Dict[str, Tuple[str, str]]],
                         table_name: str, valid_tables: Set[str]) -> Dict[str, Dict[str, Tuple[str, str]]]:
    """
    Processes the raw SQL foreign key query results and maps relationships, ignoring out-of-scope tables

    @param fk_result: Raw SQL query result containing foreign key relationships
    @param kf_map: Dict structure stroing table-to-table foreign key mappings
    @param table_name: Name of the child whose foreign keys are being processed
    @param valid_tables: Set of valid tables currently in scope for generation
    @return: Updated fk_map structure filled with validated foreigh key relations
    """
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



def get_result(db_name: str, table_name: str | None, server: Any, sql_type: str) -> List[Any]:
    """
    Formats the requested SQL template, executed the query, and handles initial empty checks

    @param db_name: Name of the target database
    @param table_name: Optional table name
    @param server: MySQL database connection server instance
    @param sql_typ: Type of the SQL template query
    @return: Reulting data rows returned from the executed SQL query
    """
    schema_extractor.error_check(sql_type, table_name)
    
    result = schema_extractor.query_templates(server, sql_type, table_name)
    
    if sql_type == "tables" and len(result) == 0:
        logger_setup.logger.error("Db has no data. Cannot generate YAML")
        return []

    return result

def main():
    """
    Manages database connection, schema extraction, sample compilation, LLM YAML generation and final configuration validation
    """
    start_time  = time.time()
    args        = parse_arguments()
    host        = args.host
    user        = args.user
    db_name     = args.db
    no_password = args.no_password
    dbms        = args.dbms
    port        = args.port
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

        
    server = db_connector.connect_to_db(host, user, password, db_name, dbms, port)
    
    if server is None:
        logger_setup.logger.error(f"Database connection error")
        yaml_generator.save_csv([yaml_generator.YAML_result(db_name, "connection_error", "connection", 1, f"Database connection error: ")], db_name)
        return 

        
    logger_setup.logger.stage(f"Connected to database: {db_name}. Ready to start generating YAML...")

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

        valid_tables = []
        table_pk = {}

        for table in tables:
            t_name = table[0]
            try:
                logger_setup.logger.info(f"Extracting prime keys for table: {t_name}")
                pk_buff = get_result(db_name, t_name, server, "prime_keys")
                prime_keys = go_over_prime_keys(pk_buff)
                table_pk[t_name] = prime_keys

                fk_buff = get_result(db_name, t_name, server, "foreign_keys")
                fk_cols = {row[0] for row in fk_buff if row and row[0]}

                is_pure_mn = len(prime_keys) > 1 and all (pk in fk_cols for pk in prime_keys)
        
                if not is_pure_mn:

                    if t_name not in valid_tables:
                        valid_tables.append(t_name)

            except Exception as  exc:
                logger_setup.logger.warning(f"Prepass failed for table: {t_name}: {exc}")
                errors.append(yaml_generator.YAML_result(db_name, f"prepass:{t_name}", "table_prepass_failed", 2, f"Prepass failed for table: {t_name}: {exc}"))
                continue

        for table in tables:
            table_name = table[0]
            logger_setup.logger.info(f"Processing table: {table_name}")
            
            try:

                prime_keys = table_pk[table_name]

                fk_map[table_name] = {}
                fk_result = get_result(db_name, table_name, server, "foreign_keys")
                fk_columns = {row[0] for row in fk_result if row and row[0]}

            
                if len(prime_keys) > 1 and all(pk in fk_columns for pk in prime_keys):
                    logger_setup.logger.warning( f"""Table {table_name} is a pure M:N. This is excluded as it is out of scope""")
                    errors.append(yaml_generator.YAML_result(db_name, "preprocessing", "composite_pk", 2, f"""Table {table_name} has composite pk {prime_keys}. This is excluded from generating as it is out of scope""" ))
                    continue
                

                samples[table_name] = {}
                columns = get_result(db_name, table_name, server, "columns")
                

                for row in fk_result:
                    if row[1] and row[1] not in valid_tables:
                        logger_setup.logger.warning( f"Table {table_name} references out of scope table {row[1]}")
                        errors.append(yaml_generator.YAML_result(db_name, "preprocessing", "excluded_dependency", 2, f"Table {table_name} references out of scope table {row[1]}"))

                fk_map = go_over_foreign_keys(fk_result, fk_map, table_name, valid_tables)

                logger_setup.logger.debug(f"Found columns in {table_name}: {[c[0] for c in columns]}")

                count_result = get_result(db_name, table_name, server, "count")
                if not count_result or not count_result[0]:
                    logger_setup.logger.warning(f"Could not get row count for table {table_name}")
                    continue

                row_count = count_result[0][0]

                if row_count == 0:
                    logger_setup.logger.warning(f"Table {table_name} appears to be empty. This table is excluded from generating as there is no data to analyse")
                    errors.append(yaml_generator.YAML_result(db_name, "preprocessing", "empty_table", 2, f"Table {table_name} appears to be empty. This table is excluded from generating as there is no data to analyse"))
                    continue

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
            logger_setup.logger.stage(f"Sending samples to LLM for YAML generation:\n {samples}")

            try:
                db_dialect = server.dialect.name
                
                prompts_dbms = get_dbms(db_dialect)

                logger_setup.logger.info(f"Detected dialect: {db_dialect}: using for LLM: {prompts_dbms}")

                yaml_str = llm_processor.generate_yaml(samples, prompts_dbms, fk_map, generate_count, db_name)
                logger_setup.logger.debug(f"Generated YAML:\n{yaml_str}")   
                errors += yaml_generator.validate_yaml(db_name, yaml_str, samples)
                yaml_was_generated = True

            except CyclicDependencyError as cde:
                logger_setup.logger.error(f"Cylic FK dependency detected: {cde}")
                errors.append(yaml_generator.YAML_result(db_name, "preprocessing", "cyclic_fk", 1, f"Cylic FK dependency detected: {cde}" ))
            except ValueError as ve:
                logger_setup.logger.error(f"Internal generation error: {ve}")
                errors.append(yaml_generator.YAML_result(db_name, "pipeline", "generation_error", 1, f"Internal generation error: {ve}"))
            
        if yaml_was_generated and not any(e.severity == 1 for e in errors):
            errors.append(yaml_generator.YAML_result(db_name, "pipeline", "success", 0, "Successfully generated and validated YAML"))
        

        elif not yaml_was_generated and not any(e.severity == 1 for e in errors):
            errors.append(yaml_generator.YAML_result(db_name, "pipeline", "partial_skip", 0, "Pipeline skipped without any generation"))


        yaml_generator.save_csv(errors, db_name)

    except (RuntimeError, IndexError) as exc:
        logger_setup.logger.error(f"Error: {exc}")
        yaml_generator.save_csv([yaml_generator.YAML_result(db_name, "critical_collapse", "pipeline_crash", 1, str(exc))], db_name)
        
    finally:
        db_connector.disconnect_from_db(server)
    
    elapsed = time.time() - start_time
    minutes = int(elapsed // 60)
    seconds = int(elapsed % 60)
    logger_setup.logger.finish(f"Done. Total execution time: {minutes}m {seconds}s")
    

if __name__ == "__main__":
    main()

