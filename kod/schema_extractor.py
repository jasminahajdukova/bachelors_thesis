"""
@file schema_extractor.py
@author Jasmina Hajdukova (xhajdu07)
@brief extraction of schema information and execution if SQL statements
"""
import re

from sqlalchemy import inspect, text  # type: ignore
from sqlalchemy.engine import Engine  # type: ignore
from sqlalchemy.exc import SQLAlchemyError  # type: ignore

import data_sampler
import logger_setup


def fix_db_type(db_type: str) -> str:
    """
    Fixes database type string  into true form
    
    @param dd_type: type string
    @return: fixed string, 'unknown' for empty input
    """
    
    if not db_type:
        return "unknown"
    
    fixed = db_type.lower().strip()

    fixed = re.sub(r'\s+character\s+set\s+("[^"]+"|\S+)', '', fixed)

    fixed = re.sub(r'\s+collate\s+("[^"]+"|\S+)', '', fixed)

    start_index = fixed.find("(")
    end_index   = fixed.find(")")

    if start_index != -1 and end_index != -1 and start_index < end_index:
        inside = fixed[start_index + 1 : end_index].replace(" ", "")
        fixed  = f"{fixed[:start_index]}({inside}){fixed[end_index + 1:]}"

    fixed = re.sub(r"\s+\(", '(', fixed).strip()

    fixed = re.sub(r"\s+", ' ', fixed).strip()

    fixed = re.sub(r"\binteger\b", "int", fixed)

    return fixed


def error_check(types: str, table_name: str | None) -> None:
    """
    Checks that query type is known and that table name exists

    @param types: type of the SQL template query
    @param table_name: table name
    """

    if types not in ["tables","columns", "prime_keys", "foreign_keys", "count"]:
        raise ValueError(f"Search type:{types} is not part of templates for tables,columns, prime_keys, foreign_keys, count")
    
    if table_name is None and types in ["columns", "prime_keys", "foreign_keys"]:
        raise ValueError("Table name is needed to search for columns/primary keys")
    



def query_templates(engine: Engine, types: str, table_name: str | None) -> list[tuple]:
    """
    Runs the schema query for the given type


    @param engine:      SQLAlchemy engine
    @param types:       type of the SQL template query
    @param table_name:  table name
    @return:            list of tuples with the schema information
    """

    error_check(types, table_name)

    
    if types == "count":
        query = data_sampler.count_template(engine, table_name)
        return execute_sql(engine, query)

    inspector = inspect(engine)
    
    if types == "tables":

        tables = inspector.get_table_names()
        return [(table,) for table in tables]

    elif types == "columns":
        columns_data = inspector.get_columns(table_name)
        return [(col['name'], fix_db_type(str(col['type']))) for col in columns_data]

    elif types == "prime_keys":
        pk_data = inspector.get_pk_constraint(table_name)
        constraint_name = pk_data.get('name') or 'PRIMARY'
        return [(constraint_name, col) for col in pk_data.get('constrained_columns', [])]

    elif types == "foreign_keys":
        fk_data = inspector.get_foreign_keys(table_name)
        result = []
        for fk in fk_data:
            for col, ref_col in zip(fk['constrained_columns'], fk['referred_columns']):
                result.append((col, fk['referred_table'], ref_col))
        return result

    raise ValueError(f"Unknown types parameter: {types}")


def execute_sql(engine: Engine, query: str) -> list[tuple]:
    """
    Executes the SQL query

    @param engine: SQLAlchemy engine
    @param query: SQL query to execute
    @return: list of rows
    """


    try:
        logger_setup.logger.debug(query)

        with engine.connect() as connection:
            result = connection.execute(text(query))
            myresult = result.fetchall()

        logger_setup.logger.debug(f"MY RESULT {myresult}")
        logger_setup.logger.debug(f"Query returned {len(myresult)} rows")

        return myresult # type: ignore[return-value]
    
    except SQLAlchemyError as err:
        logger_setup.logger.error(f"Failed to execute query =  {query} \n{err}")
        raise RuntimeError(f"Failed to execute query {err}") from err   


