

def mysql_query_templates(db_name: str) -> str:
    get_tables_name = f"""
    SELECT table_name FROM information_schema.tables
    WHERE table_schema = '{db_name}';
    """
    return get_tables_name

def postgresql_query_template(db_name:str) -> str:
    get_tables_name = f"""
    SELECT table_name FROM information_schema.tables
    WHERE table_schema NOT IN ('pg_catalog', 'information_schema)
    AND table_schema = '{db_name}'
    """
    return get_tables_name




def mysql_execute_sql():
    pass

def postgre_execute_sql():
    pass