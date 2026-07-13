import logger_setup
def calculate_limit(row_count):
    limit = int(row_count * 0.25)
    return max(5, min(limit,20))

def prime_keys_template(table_name: str, column_name: str):
    template = f"SELECT MIN(`{column_name}`), MAX(`{column_name}`) FROM `{table_name}`"
    return template

def data_samples_template(table_name: str, column_name: str, limit: int = 5) -> str:
    
    half_limit_asc = (limit + 1) // 2
    half_limit_desc = limit // 2

    template = f"""(SELECT DISTINCT `{column_name}` FROM `{table_name}` WHERE `{column_name}` IS NOT NULL ORDER BY `{column_name}` ASC LIMIT {half_limit_asc})
    UNION
    (SELECT DISTINCT `{column_name}` FROM `{table_name}` WHERE `{column_name}` IS NOT NULL ORDER BY `{column_name}` DESC LIMIT {half_limit_desc})
    ORDER BY `{column_name}` ASC;"""

    logger_setup.logger.debug(f"Creating SQL query: {template}")
    return template

