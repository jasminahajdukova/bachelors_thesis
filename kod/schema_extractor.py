from mysql.connector.connection import MySQLConnection
import mysql.connector
import logging
import colorlog

handler = colorlog.StreamHandler()
handler.setFormatter(colorlog.ColoredFormatter(
	'%(asctime)s %(log_color)s %(message)s',
    datefmt='%Y-%m-%d %H:%M:%S'))

logging.getLogger("mysql.connector").setLevel(logging.WARNING)
logging.getLogger("psycopg2").setLevel(logging.WARNING)

logger = logging.getLogger("SCHEMA_EXTRACTOR")
logger.addHandler(handler)
logger.setLevel(logging.INFO)
logger.propagate = False



def error_check(types: str, table_name: str) -> None:
    if types not in ["tables","columns", "prime_keys", "foreign_keys", "count"]:
        raise ValueError(f"Search type:{types} is not part of templates for tables,columns, prime_keys, foreign_keys, count")
    
    if table_name is None and types in ["columns", "prime_keys", "foreign_keys"]:
        raise ValueError("Table name is needed to search for columns/primary keys")
    

def mysql_query_templates(types: str) -> str:
    
    templates_dict = {
        "tables":  """SELECT table_name 
                       FROM information_schema.tables 
                       WHERE table_schema = '{db_name}';""",

        "columns": """SHOW COLUMNS 
                       FROM `{table_name}` 
                       FROM `{db_name}`;""",

        "prime_keys":  """SHOW KEYS 
                           FROM `{table_name}` 
                           WHERE Key_name = 'PRIMARY';""",

        "foreign_keys": """SELECT column_name, referenced_table_name, referenced_column_name
                            FROM information_schema.KEY_COLUMN_USAGE
                            WHERE table_schema = '{db_name}' AND table_name = '{table_name}' AND referenced_table_name IS NOT NULL; """,

        "count":        "SELECT COUNT(*) FROM `{table_name}`;"
    }

    logger.debug(f"Created SQL template: {templates_dict[types]}")
    return templates_dict[types]



def execute_sql(db_name: MySQLConnection, query):
    try:
        logger.debug(query)
        mycursor = db_name.cursor()

        mycursor.execute(query)

        myresult = mycursor.fetchall()

        logger.debug(f"MY RESULT {myresult}")
        logger.debug(f"Query returned {len(myresult)} rows")

        return myresult
    
    except mysql.connector.Error as err:
        logger.error(f"Failed to execute query =  {query} \n{err}")
        raise RuntimeError(f"Failed to execute query {err}") from err
    except Exception as e:
        logger.error(f"Unexpected failure: {e}") 
        raise RuntimeError(f"Unexpected failure: {e}") from e



