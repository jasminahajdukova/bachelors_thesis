from mysql.connector.connection import MySQLConnection
import logger_setup
def calculate_limit(row_count):
    limit = int(row_count * 0.25)
    return max(5, min(limit,20))

def prime_keys_template(table_name: str, column_name: str):
    template = f"SELECT MIN(`{column_name}`), MAX(`{column_name}`) FROM `{table_name}`"
    return template

def data_samples_template(table_name: str, column_name: str, limit: int = 5) -> str:
    
    template = f"SELECT DISTINCT `{column_name}` FROM `{table_name}` ORDER BY `{column_name}` LIMIT {limit}"

    logger_setup.logger.debug(f"Creating SQL query: {template}")
    return template

