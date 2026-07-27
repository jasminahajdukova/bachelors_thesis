"""
@file data_sampler.py
@author Jasmina Hajdukova (xhajdu07)
@brief SQL templates for column ranges and value sampling
"""

import logger_setup
from sqlalchemy.engine import Engine

def calculate_limit(row_count: int) -> int:
    """
    Calculate sample limit: 25% of rows (between 5 and 20)

    @param row_count: number of rows inside table
    @return: target number of samples between 5 and 20
    """
    limit = int(row_count * 0.25)
    return max(5, min(limit,20))

def count_template(engine: Engine, table_name: str) -> str:
    """
    Query to get total row count

    @param engine: SQLAlchemy engine used to quote identifiers
    @param table_name: name of the target table
    @return: SQL statement returning total row count
    """
    quote = engine.dialect.identifier_preparer.quote_identifier
    quoted_table = quote(table_name)

    return f"SELECT COUNT(*) FROM {quoted_table}"

def prime_keys_template(engine: Engine, table_name: str, column_name: str) -> str:
    """
    Query to get min and max value for a column, NULLs ignored

    @param engine: SQLAlchemy engine used to quote identifiers
    @param table_name: name of the target table
    @param column_name: name of the target column
    @return: SQL statement returning min and max value of the column
    """

    quote = engine.dialect.identifier_preparer.quote_identifier
    quoted_table = quote(table_name)
    quoted_column = quote(column_name)

    template = f"SELECT MIN({quoted_column}), MAX({quoted_column}) FROM {quoted_table}"
    return template

def data_samples_template(engine: Engine, table_name: str, column_name: str, limit: int = 5) -> str:
    """
    Get the lowest and the highest values for a column

    @param engine: SQLAlchemy engine used to quote identifiers
    @param table_name: name of the target table
    @param column_name: name of the target column
    @param limit: number of samples
    @return: SQL statement returning sample values
    
    """
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

