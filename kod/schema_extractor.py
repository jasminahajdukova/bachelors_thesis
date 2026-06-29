from mysql.connector.connection import MySQLConnection
import logger_setup


def error_check(types: str, table_name: str) -> None:
    if types not in ["tables","columns", "prime_keys", "foreign_keys", "count"]:
        raise ValueError(f"Search type:{types} is not part of templates for tables,columns, prime_keys, foreign_keys, count")
    
    if table_name is None and types in ["columns", "prime_keys", "foreign_keys"]:
        raise ValueError("Table name is needed to search for columns/primary keys")
    

def mysql_query_templates(types: str) -> str:
    
    templates_dict = {
        # index 0 = table_name
        "tables":  """SELECT table_name 
                       FROM information_schema.tables 
                       WHERE table_schema = '{db_name}';""",


        # index 0 = column_name
        "columns": """SELECT column_name 
                       FROM information_schema.columns 
                       WHERE table_schema = '{db_name}' AND table_name = '{table_name}'
                       ORDER BY ordinal_position;""",

        # index 0 = constraint_name 
        # index 1 = column_name
        "prime_keys":  """SELECT constraint_name, column_name 
                           FROM information_schema.key_column_usage 
                           WHERE table_schema = '{db_name}' 
                             AND table_name = '{table_name}' 
                             AND constraint_name = 'PRIMARY'
                           ORDER BY ordinal_position;""",

        # index 0 = column_name, index 1 = referenced_table_name, index 2 = referenced_column_name
        "foreign_keys": """SELECT column_name, referenced_table_name, referenced_column_name
                            FROM information_schema.KEY_COLUMN_USAGE
                            WHERE table_schema = '{db_name}' 
                              AND table_name = '{table_name}' 
                              AND referenced_table_name IS NOT NULL; """,

        # index 0 = row_count
        "count":        "SELECT COUNT(*) FROM `{table_name}`;"
    }

    logger_setup.logger.debug(f"Created SQL template: {templates_dict[types]}")
    return templates_dict[types]


def execute_sql(db_name: MySQLConnection, query):
    try:
        logger_setup.logger.debug(query)
        mycursor = db_name.cursor()

        mycursor.execute(query)

        myresult = mycursor.fetchall()

        logger_setup.logger.debug(f"MY RESULT {myresult}")
        logger_setup.logger.debug(f"Query returned {len(myresult)} rows")

        return myresult
    
    except Exception as err:
        logger_setup.logger.error(f"Failed to execute query =  {query} \n{err}")
        raise RuntimeError(f"Failed to execute query {err}") from err   


