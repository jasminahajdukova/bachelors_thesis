import argparse, getpass,db_connector, data_sampler, llm_processor, schema_extractor, yaml_generator,logging, colorlog
import time

handler = colorlog.StreamHandler()
handler.setFormatter(colorlog.ColoredFormatter(
	'%(asctime)s %(log_color)s %(levelname)s: %(name)s: %(message)s',
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
    parser.add_argument("--no-fix", action="store_true", help="Skip YAML fix step")
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

def main():

    start_time  = time.time()
    args        = parse_arguments()
    db_server   = args.db_server
    host        = args.host
    user        = args.user
    db_name     = args.db
    no_password = args.no_password
    no_fix      = args.no_fix

    if not check_if_server_exists(db_server):
        return
    
    password = "" if no_password else getpass.getpass("Enter password: ")
    server   = choose_server(db_server, host, user, db_name, password)

    if server is None:
        raise RuntimeError("Couldn't connect to server")
    
    if db_server in ("MySQL", "mysql"):
        template = schema_extractor.mysql_query_templates(db_name, None, "tables")
        logger.debug(f"SQL TEMPLATE: {template}")
        sql_query = llm_processor.generate_sql_query(template, db_server, db_name)
        logger.debug(f"SQL QUERY: {sql_query}")
        logger.debug(f"Generated SQL query for tables: {sql_query}")
        tables = schema_extractor.mysql_execute_sql(server, sql_query)
        if len(tables) == 0:
            logger.error("Db has no data. Cannot generate YAML.")
            disconnect(db_server, server)
            return
        logger.info(f"Found {len(tables)} tables {tables} in {db_name}")

        samples = {}
        fk_map = {}
        for table in tables:
            table_name = table[0]
            samples[table_name] = {}
            logger.info(f"Processing table: {table_name}")
            column_template = schema_extractor.mysql_query_templates(db_name, table_name, "columns")
            column_sql_query =  llm_processor.generate_sql_query(column_template, db_server, db_name)
            columns = schema_extractor.mysql_execute_sql(server, column_sql_query)

            fk_template = schema_extractor.mysql_query_templates(db_name, table_name, "foreign_keys")
            fk_sql_query = llm_processor.generate_sql_query(fk_template, db_server, db_name)
            fk_result = schema_extractor.mysql_execute_sql(server, fk_sql_query)
            fk_map[table_name] = {}
            for row in fk_result:
                local_col = row[0]
                ref_table = row[1]
                ref_col   = row[2]
                fk_map[table_name][local_col] = (ref_table, ref_col)
            logger.debug("Found columns in {table_name}: {[c[0] for c in columns]}")
            prime_keys = []
            logger.debug("Entering first column loop")
            for column in columns:
                column_name = column[0]
                if column[3] == "PRI":
                    prime_keys.append(column_name)

            count_result = schema_extractor.mysql_execute_sql(server, f"SELECT COUNT(*) FROM {table_name};")
            row_count = count_result[0][0]
            limit = data_sampler.calculate_limit(row_count)
            logger.info(f"Table {table_name}: {row_count} rows, LIMIT {limit}")
            logger.debug("Entering second column loop")
            for column in columns:
                column_name = column[0]
                template = data_sampler.data_samples_templates(table_name, column_name, limit)
                result = schema_extractor.mysql_execute_sql(server, template)
                
                if column_name in prime_keys:
                    logger.debug(f"2nd column loop: prime key: {column_name}")
                    min_val = result[0][1]
                    max_val = result[0][2]
                    samples[table_name][column_name] = {"is_pk": True, "seq": f"seq({min_val}, {max_val}, 1)"}
                    logger.debug(f"samples[table_name][column_name] = {samples[table_name][column_name]}")
                else:    
                    logger.debug(f"2nd column loop: NOT prime key: {column_name}")
                    samples[table_name][column_name] = result
                    logger.debug(f"samples[table_name][column_name] = {samples[table_name][column_name]}")

        logger.info("Sending samples to LLM for YAML generation")
        yaml_str = llm_processor.generate_yaml(samples, "MySQL", fk_map,  no_fix)
        logger.debug(f"Generated YAML:\n{yaml_str}")
        yaml_generator.validate_yaml(yaml_str)
        disconnect(db_server, server)
        

    # elif db_server in ("PostgreSQL", "postgresql"):
    #     template = schema_extractor.postgresql_query_template(db_name, None, "tables")
    #     sql_query = llm_processor.generate_sql_query(template, db_server, db_name)
    #     logger.debug(f"Generated SQL query for tables: {sql_query}")
    #     tables = schema_extractor.postgre_execute_sql(server, sql_query)
    #     if len(tables) == 0:
    #         logger.error("Db has no data. Cannot generate YAML.")
    #         disconnect(db_server, server)
    #         return
    #     logger.info(f"Found {len(tables)} tables in {db_name}")

    #     samples = {}
    #     for table in tables:
    #         table_name = table[0]
    #         samples[table_name] = {}
    #         logger.info(f"Processing table: {table_name}")
    #         column_template = schema_extractor.postgresql_query_template(db_name, table_name, "columns")
    #         columns = schema_extractor.postgre_execute_sql(server, column_template)
    #         logger.debug(f"Found columns in {table_name}: {[c[3] for c in columns]}")

    #         for column in columns:
    #             column_name = column[3]
    #             template = data_sampler.data_samples_templates_postgresql(table_name, column_name)
    #             result = schema_extractor.postgre_execute_sql(server, template)
    #             samples[table_name][column_name] = result

    #     logger.info("Sending samples to LLM for YAML generation")
    #     yaml_str = llm_processor.generate_yaml(samples, "PostgreSQL", no_fix)
    #     logger.debug(f"Generated YAML:\n{yaml_str}")
    #     yaml_generator.validate_yaml(yaml_str)
    #     disconnect(db_server, server)
    
    
    elapsed = time.time() - start_time
    minutes = int(elapsed // 60)
    seconds = int(elapsed % 60)
    logger.info(f"Total execution time: {minutes}m {seconds}s")
    logger.info("Done")

if __name__ == "__main__":
    main()

