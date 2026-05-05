import argparse, getpass, db_connector, data_sampler, llm_processor, schema_extractor, yaml_generator,logging

import psycopg2 
from mysql.connector.connection import MySQLConnection

def parse_arguments():
    parser = argparse.ArgumentParser(
        description="Generates Dataster YAML configuration using LLM"
    )

    parser.add_argument("-d", "--db_server", required=True, help="Database server (mysql/postgresql)")
    parser.add_argument("--host", required=True, help="Database host")
    parser.add_argument("--user", required=True, help="Database user")
    parser.add_argument("--db", required=True, help="Database name")
    parser.add_argument("--no-password", action="store_true", help="Connect without password")
    return parser.parse_args()
    

def check_if_server_exists(db_server):
    if db_server not in ("MySQL", "mysql", "PostgreSQL", "postgresql"):
        db_connector.logger.error("Server not recognized")
        return False
    return True


def choose_server(db_server, host, user, db_name, password):
    if db_server in ("MySQL", "mysql"):
        return db_connector.connect_to_mysql(host,user,password)  
    elif db_server in ("PostgreSQL", "postgresql"):
        return db_connector.connect_to_postgresql(db_name, host, user, password)


def disconnect(db_server,server):
    if db_server in ("MySQL", "mysql"):
        return db_connector.disconnect_from_mysql(server)
    elif db_server in ("PostgreSQL", "postgresql"):
        return db_connector.disconnect_from_postgresql(server)

def main():

    args = parse_arguments()
    db_server = args.db_server
    host = args.host
    user = args.user
    db_name = args.db
    no_password = args.no_password

    if not check_if_server_exists(db_server):
        return
    
    password = "" if no_password else getpass.getpass("Enter password: ")
    server = choose_server(db_server, host, user, db_name, password)

    if isinstance(server, MySQLConnection):
        template = schema_extractor.mysql_query_templates(db_name, None, "tables")
        sql_query = llm_processor.generate_sql_query(template, db_server)
        tables = schema_extractor.mysql_execute_sql(server, sql_query)

        samples = {}
        for table in tables:
            table_name = table[0]
            samples[table_name] = {}
            column_template = schema_extractor.mysql_query_templates(db_name, table_name, "columns")
            columns = schema_extractor.mysql_execute_sql(server, column_template)

            for column in columns:
                column_name = column[0]
                template = data_sampler.data_samples_templates(table_name, column_name)
                result = schema_extractor.mysql_execute_sql(server, template)
                samples[table_name][column_name] = result

        yaml_str = llm_processor.generate_yaml(samples, "MySQL")
        yaml_generator.validate_yaml(yaml_str)
        disconnect(db_server, server)

    elif isinstance(server, psycopg2.extensions.connection):
        template = schema_extractor.postgresql_query_template(db_name, None, "tables")
        sql_query = llm_processor.generate_sql_query(template, db_server)
        tables = schema_extractor.postgre_execute_sql(server, sql_query)

        samples = {}
        for table in tables:
            table_name = table[0]
            samples[table_name] = {}

            column_template = schema_extractor.postgresql_query_template(db_name, table_name, "columns")
            columns = schema_extractor.postgre_execute_sql(server, column_template)

            for column in columns:
                column_name = column[0]
                template = data_sampler.data_samples_templates(table_name, column_name)
                result = schema_extractor.postgre_execute_sql(server, template)
                samples[table_name][column_name] = result

        yaml_str = llm_processor.generate_yaml(samples, "PostgreSQL")
        yaml_generator.validate_yaml(yaml_str)
        disconnect(db_server, server)
    else:
        print("error")
if __name__ == "__main__":
    main()

