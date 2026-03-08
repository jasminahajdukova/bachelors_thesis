import mysql.connector
import psycopg2

def connect_to_mysql(host_name,user_name,db_password):
    mydb= mysql.connector.connect(
        host=host_name,
        user=user_name,
        password=db_password
        )
    print(mydb)
    return mydb

def connect_to_postgresql(db_name,host_name,user_name,db_password):
    conn = psycopg2.connect(
        db_name=db_name,
        user=user_name,
        password=db_password,
        host=host_name
    )
    print(conn)
    return conn
