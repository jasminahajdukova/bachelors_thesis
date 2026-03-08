import getopt, sys, getpass, db_connector


def main():
    
    args         = sys.argv[1:]
    options      = "hd:"
    long_options = ["help", "db_server=", "host=", "user=", "db="]
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
            connection = db_connector.connect_to_mysql(host, user, password)
            print("do something")
            db_connector.disconnect_from_mysql(connection)
        elif db_server in ("PostgreSQL", "postgresql"):
            connection = db_connector.connect_to_postgresql(db_name, host, user, password)
            print("do something")
            db_connector.disconnect_from_postgresql(connection)
        else:
            print("Server not recognized")

    except getopt.error as err:
        print(str(err))


if __name__ == "__main__":
    main()

