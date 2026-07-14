
from sqlalchemy import create_engine    # type: ignore
from sqlalchemy.exc import SQLAlchemyError # type: ignore
from sqlalchemy.engine import URL # type: ignore

import logger_setup

DBMS = {
    "mysql": "mysql+mysqlconnector",
    "postgresql": "postgresql+psycopg2"
}

def connect_to_db(host_name, user_name, db_password, db_name, dbms="mysql", port= None):
    
    dbms_lower = dbms.lower()
    try:
   
        driver = DBMS.get(dbms.lower(), "mysql+mysqlconnector")
        connection_url = URL.create(driver, user_name, db_password, host_name, port, db_name)
    
        engine = create_engine(connection_url)

        with engine.connect() as connection:
            pass
        logger_setup.logger.info(f"Connection to {dbms} successful")
        return engine
    
    except (SQLAlchemyError) as err:
        logger_setup.logger.error(f"Server is either not running or is unreachable: {err}")
        return None

def disconnect_from_db(mydb):
    if mydb is None:
        return
    try:
        mydb.dispose()
        logger_setup.logger.info(f"Connection closed")
    except Exception as err:
        logger_setup.logger.error(f"Error while closing MySQL connection: {err}")

