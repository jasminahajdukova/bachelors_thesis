import getopt, sys, getpass, db_connector, logging

def print_help():
    logging.info("Usage: python main.py -d [mysql|postgresql] --host HOST --user USER --db DB")


def parse_arguments(args, options, long_options):
    host = user = db_name = db_server = None
    no_password = False
    arguments = getopt.getopt(args, options, long_options)[0]
    for currentArg, currentVal in arguments:
            if currentArg in ("-h", "--help"):
                print_help()
            elif currentArg in ("-d", "--db_server"):
                db_server = currentVal
            elif currentArg == "--host":
                host = currentVal
            elif currentArg == "--user":
                user = currentVal
            elif currentArg == "--db":
                db_name = currentVal
            elif currentArg == "--no-password":
                no_password = True
    return db_server, host, user, db_name, no_password

def check_if_server_exists(db_server):
    if db_server not in ("MySQL", "mysql", "PostgreSQL", "postgresql"):
        db_connector.logger.error("Server not recognized")
        return False
    return True


def choose_server(db_server, host, user, db_name, password):
    if db_server in ("MySQL", "mysql"):
        return db_connector.connect_to_mysql(host,user,password)  
    elif db_server in ("PostgreSQL", "postgresql"):
        return db_connector.connect_to_postgresql(db_name, host, user, password)


def disconnect(db_server,server):
    if db_server in ("MySQL", "mysql"):
        return db_connector.disconnect_from_mysql(server)
    elif db_server in ("PostgreSQL", "postgresql"):
        return db_connector.disconnect_from_postgresql(server)

def main():
    args         = sys.argv[1:]
    options      = "hd:"
    long_options = ["help", "db_server=", "host=", "user=", "db=", "no-password"]
    
    try:
        db_server, host, user, db_name, no_password = parse_arguments(args,options,long_options)
        if not check_if_server_exists(db_server):
            return
        password = "" if no_password else getpass.getpass("Enter password: ")
        server = choose_server(db_server, host, user, db_name, password)

        if server:
            # TO DO
            disconnect(db_server, server)
    except getopt.error as err:
        logging.error(str(err))


if __name__ == "__main__":
    main()

