
"""
@file   db_connector.py
@author Jasmina Hajdukova (xhajdu07)
@brief  creating and closing connection to target database
"""

from sqlalchemy import create_engine
from sqlalchemy.engine import URL, Engine
from sqlalchemy.exc import SQLAlchemyError

import logger_setup

DBMS = {
    "mysql": "mysql+mysqlconnector",
    "postgresql": "postgresql+psycopg2"
}

def connect_to_db(host_name: str, user_name: str, db_password: str, db_name: str, dbms: str = "mysql", port: int | None = None) -> Engine | None:
    """
    Creates a database connection using SQLAlchemy and checks it.
    
    @param host_name: database server address
    @param user_name: username 
    @param db_password: password
    @param db_name: name of the target database
    @param dbms: type of DBMS (mysql, postgresql). Default is  mysql
    @param port: port number
    @return> SQLAlchemy Engine isntance if connection is successfull, otherwise None
    """

    dbms_lower = dbms.lower()
    try:
        #gets driver based on dbms
        driver = DBMS.get(dbms_lower, "mysql+mysqlconnector")

        # creates connection url
        connection_url = URL.create(driver, user_name, db_password, host_name, port, db_name)

        engine = create_engine(connection_url)

        with engine.connect():
            pass

        logger_setup.logger.info(f"Connection to {dbms} successful")
        return engine
    
    except (SQLAlchemyError) as err:
        logger_setup.logger.error(f"Server is either not running or is unreachable: {err}")
        return None

def disconnect_from_db(mydb):
    """
    Closses connection to database

    @param mydb: SQLAlchemy Engine instance, None is ignored
    """

    if mydb is None:
        return
    
    try:
        mydb.dispose()
        logger_setup.logger.info("Connection closed")
        
    except Exception as err:
        logger_setup.logger.error(f"Error while closing MySQL connection: {err}")

