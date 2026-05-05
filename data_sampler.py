from mysql.connector.connection import MySQLConnection
import psycopg2

def data_samples_templates(table_name: str | None, column_name: str | None) -> str:
    
    template = f"""SELECT MIN({column_name}), MAX({column_name}), AVG({column_name}), COUNT(DISTINCT {column_name})
                        FROM {table_name};"""
    
    return template


def mysql_execute_sql(db_name: MySQLConnection, query):
    try:
        mycursor = db_name.cursor()

        mycursor.execute(query)

        myresult = mycursor.fetchall()

        return myresult
    except Exception as e:
        raise Exception("Failed to execute query.") from e


def postgre_execute_sql(db_name: psycopg2.extensions.connection, query: str):
    try:
        mycursor = db_name.cursor()

        mycursor.execute(query)

        myresults = mycursor.fetchall()

        return myresults
    except Exception as e:
        raise Exception("Failed to execute query.") from e
    


def extr_talk_to_llm():
    pass