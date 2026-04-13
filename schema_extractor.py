
def mysql_query_templates(db_name: str, table_name: str | None, types: str) -> str:
    
    if types not in ["tables","columns", "prime_keys"]:
        raise ValueError(f"Searech type:{types} is not part of templates for tables,columns, prime_keys:")

    
    if table_name is None and types in ["columns", "prime_keys"]:
        raise ValueError(f"Table name is need to search for columns/primary keys")
    
    templates_dict = {
        "tables":  f"""SELECT table_name 
                       FROM information_schema.tables 
                       WHERE table_schema = '{db_name}';""",

        "columns": f"""SHOW COLUMNS 
                       FROM {table_name} 
                       FROM {db_name};""",

        "prime_keys":  f"""SHOW KEYS 
                           FROM {table_name} 
                           WHERE Key_name = 'PRIMARY';""",

        "foreign_keys": f"""SELECT column_name, referenced_table_name, referenced_column_name
                            FROM information_schema.KEY_COLUMN_USAGE
                            WHERE table_schema = '{db_name}' AND table_name = '{table_name}' AND referenced_table_name IS NOT NULL"""
    }

    return templates_dict[types]



def postgresql_query_template(db_name:str) -> str:
    get_tables_name = f"""
    SELECT table_name FROM information_schema.tables
    WHERE table_schema NOT IN ('pg_catalog', 'information_schema)
    AND table_schema = '{db_name}'
    """
    return get_tables_name



def mysql_execute_sql(db_name: str, queries: list[str]):
    mycursor = db_name.cursor()

    myresult: list[str] = []
    for query in queries:
        mycursor.execute(query)
        myresult.append(mycursor.fetchall())

    return myresult

def postgre_execute_sql():
    pass