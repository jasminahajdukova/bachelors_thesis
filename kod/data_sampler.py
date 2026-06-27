from mysql.connector.connection import MySQLConnection
import psycopg2
import logging
import colorlog

handler = colorlog.StreamHandler()
handler.setFormatter(colorlog.ColoredFormatter(
	'%(asctime)s %(log_color)s %(levelname)s: %(name)s:%(message)s',
    datefmt='%Y-%m-%d %H:%M:%S'))

logging.getLogger("mysql.connector").setLevel(logging.WARNING)
logging.getLogger("psycopg2").setLevel(logging.WARNING)

logger = logging.getLogger("DATA_SAMPLER")
logger.addHandler(handler)
logger.setLevel(logging.INFO)
logger.propagate = False

def calculate_limit(row_count):
    limit = int(row_count * 0.25)
    return max(5, min(limit,20))

def data_samples_templates(table_name: str | None, column_name: str | None, limit: int = 5) -> str:
    
    template = f"""SELECT DISTINCT {column_name},
                        (SELECT MIN({column_name}) FROM {table_name}),
                        (SELECT MAX({column_name}) FROM {table_name}),
                        (SELECT COUNT(DISTINCT {column_name}) FROM {table_name})
                    FROM {table_name}
                    LIMIT {limit};"""
    
    logger.debug(f"Creating SQL query: {template}")
    return template


def data_samples_templates_postgresql(table_name: str | None, column_name: str | None) -> str:
    template = f"""SELECT MIN({column_name}), MAX({column_name}), COUNT(DISTINCT {column_name})
                   FROM {table_name};"""
    
    logger.debug(f"Creating SQL query: {template}")
    return template


def execute_sql(db_name: psycopg2.extensions.connection | MySQLConnection, query: str):
    try:
        mycursor = db_name.cursor()

        mycursor.execute(query)

        myresults = mycursor.fetchall()
        logger.debug(f"Query returned {len(myresults)} rows")
        return myresults
    except Exception as e:
        logger.error(f"Failed to execute query: {e}") 
        raise Exception("Failed to execute query.") from e
    