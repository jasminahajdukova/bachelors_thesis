from db_connector import connect_to_postgresql, connect_to_mysql
import getopt, sys, getpass


def main():
    
    args         = sys.argv[1:]
    options      = "h"
    long_options = ["help", "db_server", "host", "user", "db"]
    host = user = db_name = db_server = None
    
    
    try:
        arguments, values = getopt.getopt(args, options, long_options)
        for currentArg, currentVal in arguments:
            if currentArg in ("-h", "--help"):
                print("Usage: python main.py -d [mysql|postgresql] --host HOST --user USER --db DB")
            elif currentArg in ("-d", "--db_server"):
                db_server = currentVal
            elif currentArg == "--host":
                host = currentVal
            elif currentArg == "--user":
                user = currentVal
            elif currentArg == "--db":
                db_name = currentVal

        password     = getpass.getpass("Zadajte heslo: ")
        if db_server in ("MySQL", "mysql"):
            connect_to_mysql(host, user, password)
        elif db_server in ("PostgreSQL", "postgresql"):
            connect_to_postgresql(db_name, host, user, db_server)
        else:
            print("Server not recognized")

    except getopt.error as err:
        print(str(err))


if __name__ == "__main__":
    main()

