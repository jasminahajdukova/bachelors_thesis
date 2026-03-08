import mysql.connector
import psycopg2

def connect_to_mysql(host_name,user_name,db_password):
    try:
        mydb= mysql.connector.connect(
            host=host_name,
            user=user_name,
            password=db_password
            )
        print("Connection to MySQL successful" if mydb else "Connection error")
        return mydb
    except mysql.connector.Error as err:
        print(f"Connection error: {err}")
        return None

def disconnect_from_mysql(mydb):
    mydb.close()
    print("Connection to MySQL closed")
    

def connect_to_postgresql(db_name,host_name,user_name,db_password):
    try:
        conn = psycopg2.connect(
            dbname=db_name,
            user=user_name,
            password=db_password,
            host=host_name
        )
        print("Connection to PostgreSQL successful" if conn else "Connection error")
        return conn
    except psycopg2.Error as err:
        print(f"Connection error: {err}")
        return None

def disconnect_from_postgresql(conn):
    conn.close()
    print("Connection to PostgreSQL closed")