import mysql.connector

import logger_setup

def connect_to_mysql(host_name,user_name,db_password, db_name):
    try:
        mydb= mysql.connector.connect(
            host=host_name,
            user=user_name,
            password=db_password,
            database=db_name
            )
        logger_setup.logger.info("Connection to MySQL successful")
        return mydb
    except (mysql.connector.Error) as err:
        logger_setup.logger.error(f"Server is either not running or is unreachable: {err}")
        return None

def disconnect_from_mysql(mydb):
    if mydb is None:
        return
    try:
        mydb.close()
        logger_setup.logger.info("Connection to MySQL closed")
    except mysql.connector.Error as err:
        logger_setup.logger.error(f"Error while closing MySQL connection: {err}")

