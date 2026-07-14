
import logger_setup
from sqlalchemy.engine import Engine

def calculate_limit(row_count):
    limit = int(row_count * 0.25)
    return max(5, min(limit,20))

def count_template(engine: Engine, table_name) -> str:
    quote = engine.dialect.identifier_preparer.quote_identifier
    quoted_table = quote(table_name)

    return f"SELECT COUNT(*) FROM {quoted_table}"

def prime_keys_template(engine: Engine, table_name: str, column_name: str):
    quote = engine.dialect.identifier_preparer.quote_identifier
    quoted_table = quote(table_name)
    quoted_column = quote(column_name)

    template = f"SELECT MIN({quoted_column}), MAX({quoted_column}) FROM {quoted_table}"
    return template

def data_samples_template(engine: Engine, table_name: str, column_name: str, limit: int = 5) -> str:
    quote = engine.dialect.identifier_preparer.quote_identifier
    quoted_table = quote(table_name)
    quoted_column = quote(column_name)

    half_limit_asc = (limit + 1) // 2
    half_limit_desc = limit // 2

    template = f"""(SELECT DISTINCT {quoted_column} FROM {quoted_table} WHERE {quoted_column} IS NOT NULL ORDER BY {quoted_column} ASC LIMIT {half_limit_asc})
    UNION
    (SELECT DISTINCT {quoted_column} FROM {quoted_table} WHERE {quoted_column} IS NOT NULL ORDER BY {quoted_column} DESC LIMIT {half_limit_desc})
    ORDER BY {quoted_column} ASC;"""

    logger_setup.logger.debug(f"Creating SQL query: {template}")
    return template

