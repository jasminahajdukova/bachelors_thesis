import mysql.connector
import psycopg2
import logging
import colorlog

handler = colorlog.StreamHandler()
handler.setFormatter(colorlog.ColoredFormatter(
	'%(asctime)s %(log_color)s %(message)s',
    datefmt='%Y-%m-%d %H:%M:%S'))


logging.getLogger("mysql.connector").setLevel(logging.WARNING)
logging.getLogger("psycopg2").setLevel(logging.WARNING)

logger = logging.getLogger("DB_CONNECTOR")
logger.addHandler(handler)
logger.setLevel(logging.INFO)
logger.propagate = False



def connect_to_mysql(host_name,user_name,db_password, db_name):
    try:
        mydb= mysql.connector.connect(
            host=host_name,
            user=user_name,
            password=db_password,
            database=db_name
            )
        logger.info("Connection to MySQL successful")
        return mydb
    except (mysql.connector.Error) as err:
        logger.error(f"Server is either not running or is unreachable: {err}")
        return None

    

def disconnect_from_mysql(mydb):
    if mydb is None:
        return
    try:
        mydb.close()
        logger.info("Connection to MySQL closed")
    except mysql.connector.Error as err:
        logger.warning(f"Error while closing MySQL connection: {err}")

def connect_to_postgresql(db_name,host_name,user_name,db_password):
    try:
        conn = psycopg2.connect(
            dbname=db_name,
            user=user_name,
            password=db_password,
            host=host_name
        )
        logger.info("Connection to PostgreSQL successful")
        return conn
    except (psycopg2.Error) as err:
        logger.warning(f"Error while closing MySQL connection: {err}")
    

def disconnect_from_postgresql(conn):
    if conn is None:
        return
    try:
        conn.close()
        logger.info("Connection to PostgreSQL closed")
    except psycopg2.Error as err:
        logger.error(f"Server is either not running or is unreachable: {err}")
        return None 
