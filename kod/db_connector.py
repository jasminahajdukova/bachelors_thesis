import mysql.connector, psycopg2, logging, colorlog

handler = colorlog.StreamHandler()
handler.setFormatter(colorlog.ColoredFormatter(
	'%(asctime)s %(log_color)s %(levelname)s: %(name)s:%(message)s',
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
    except mysql.connector.errors.InterfaceError as err:
        logger.error(f"Server is either not running or is unreachable: {err}")
        return None
    except mysql.connector.Error as err:
        logger.error(f"Connection error: {err}")
        return None
    

def disconnect_from_mysql(mydb):
    mydb.close()
    logger.info("Connection to MySQL closed")


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
    except psycopg2.OperationalError as err:
        logger.error(f"Server is either not running or is unreachable: {err}")
        return None
    except psycopg2.Error as err:
        logger.error(f"Connection error: {err}")
        return None
    

def disconnect_from_postgresql(conn):
    conn.close()
    logger.info("Connection to PostgreSQL closed")