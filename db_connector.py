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

def disconnect_from_mysql(mydb):
    mydb.close()
    print("Connection to MySQL closed")

def connect_to_postgresql(db_name,host_name,user_name,db_password):
    conn = psycopg2.connect(
        dbname=db_name,
        user=user_name,
        password=db_password,
        host=host_name
    )
    print(conn)
    return conn

def disconnect_from_postgresql(conn):
    conn.close()
    print("Connection to PostgreSQL closed")