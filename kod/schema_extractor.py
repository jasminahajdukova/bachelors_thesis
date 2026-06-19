from mysql.connector.connection import MySQLConnection
import psycopg2, logging, colorlog

handler = colorlog.StreamHandler()
handler.setFormatter(colorlog.ColoredFormatter(
	'%(asctime)s %(log_color)s %(levelname)s: %(name)s:%(message)s',
    datefmt='%Y-%m-%d %H:%M:%S'))

logging.getLogger("mysql.connector").setLevel(logging.WARNING)
logging.getLogger("psycopg2").setLevel(logging.WARNING)

logger = logging.getLogger("SCHEMA_EXTRACTOR")
logger.addHandler(handler)
logger.setLevel(logging.INFO)
logger.propagate = False



def error_check(types: str, table_name: str) -> None:
    if types not in ["tables","columns", "prime_keys", "foreign_keys"]:
        raise ValueError(f"Search type:{types} is not part of templates for tables,columns, prime_keys:")
    
    if table_name is None and types in ["columns", "prime_keys", "foreign_keys"]:
        raise ValueError(f"Table name is need to search for columns/primary keys")
    

def mysql_query_templates(types: str) -> str:
    
    templates_dict = {
        "tables":  """SELECT table_name 
                       FROM information_schema.tables 
                       WHERE table_schema = '{db_name}';""",

        "columns": """SHOW COLUMNS 
                       FROM {table_name} 
                       FROM {db_name};""",

        "prime_keys":  """SHOW KEYS 
                           FROM {table_name} 
                           WHERE Key_name = 'PRIMARY';""",

        "foreign_keys": """SELECT column_name, referenced_table_name, referenced_column_name
                            FROM information_schema.KEY_COLUMN_USAGE
                            WHERE table_schema = '{db_name}' AND table_name = '{table_name}' AND referenced_table_name IS NOT NULL; """
    }

    logger.debug(f"Created SQL template: {templates_dict[types]}")
    return templates_dict[types]



def postgresql_query_template(db_name: str, table_name: str | None, types: str) -> str:

    error_check(types, table_name)

    templates_dict = {
        "tables":       f"""SELECT table_name 
                            FROM information_schema.tables
                            WHERE table_schema NOT IN ('pg_catalog', 'information_schema') AND table_schema = 'public'; """,

        "columns":      f"""SELECT *
                            FROM information_schema.columns
                            WHERE table_schema = 'public' and table_name = '{table_name}'; """,
        
        "prime_keys":   f"""SELECT kcu.column_name
                            FROM information_schema.table_constraints tc
                            JOIN information_schema.key_column_usage kcu
                            ON tc.constraint_name = kcu.constraint_name
                            WHERE tc.table_schema = 'public' AND tc.table_name = '{table_name}' AND tc.constraint_type = 'PRIMARY KEY';""",

        "foreign_keys": f"""SELECT tc.table_schema, tc.constraint_name, tc.table_name, kcu.column_name, ccu.table_schema AS foreign_table_schema, ccu.table_name AS foreign_table_name, ccu.column_name AS foreign_column_name 
                            FROM information_schema.table_constraints AS tc 
                            JOIN information_schema.key_column_usage AS kcu
                            ON tc.constraint_name = kcu.constraint_name
                            AND tc.table_schema = kcu.table_schema  
                            JOIN information_schema.constraint_column_usage AS ccu
                            ON ccu.constraint_name = tc.constraint_name
                            WHERE tc.constraint_type = 'FOREIGN KEY' AND tc.table_schema='public' AND tc.table_name='{table_name}'; """
    }

    logger.debug(f"Created SQL template: {templates_dict[types]}")
    return templates_dict[types]


def mysql_execute_sql(db_name: MySQLConnection, query):
    try:
        logger.debug(query)
        mycursor = db_name.cursor()

        mycursor.execute(query)

        myresult = mycursor.fetchall()

        logger.debug(f"MY RESULT {myresult}")
        
        logger.debug(f"Query returned {len(myresult)} rows")
        return myresult
    except Exception as e:
        logger.error(f"Failed to execute query: {e}") 
        raise Exception("Failed to execute query.") from e


def postgre_execute_sql(db_name: psycopg2.extensions.connection, query: str):
    try:
        mycursor = db_name.cursor()

        mycursor.execute(query)

        myresults = mycursor.fetchall()

        logger.debug(f"Query returned {len(myresults)} rows")
        return myresults
    except Exception as e:
        logger.error(f"Failed to execute query: {e}") 
        raise Exception("Failed to execute query.") from e
    