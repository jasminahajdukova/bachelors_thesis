import logging
import colorlog


handler = colorlog.StreamHandler()
handler.setFormatter(colorlog.ColoredFormatter(
	'%(asctime)s %(log_color)s %(levelname)s: %(name)s:%(message)s',
    datefmt='%Y-%m-%d %H:%M:%S'))

logging.getLogger("mysql.connector").setLevel(logging.WARNING)
logging.getLogger("psycopg2").setLevel(logging.WARNING)

logger = logging.getLogger("LLM_PROCESSOR")
logger.addHandler(handler)
logger.setLevel(logging.INFO)
logger.propagate = False




def go_over_schema(schemas, samples):
    current_table = ""
    new_schema = []
    schemas = schemas.split("\n")

    for line in schemas:
        logger.info(f"Line ={line}")
        if line == "schema:" or not line.strip():
            new_schema.append(line)
            continue
        line_split = line.strip().split(" ")

        table_name = line_split[0].strip(":")
        if len(line_split) == 1:
            if table_name in samples:
                current_table = table_name
                new_schema.append(line)
                continue
            else:
                logger.warning(f"{table_name} is not part of {samples.keys()}")
                continue
       
        schema_name = line_split[0].strip(":")
        if schema_name not in samples[current_table]:
            logger.warning(f"This schema_name does not belong = {schema_name}")
            continue

        new_schema.append(line)

    new_schema = '\n'.join(new_schema)
    return new_schema


samples = {"passenger_information": {"passenger_email": {"is_pk": False, "distinct_count_in_sample": 5, "samples": ["anna.benesova@uni.com", "david.cerny@uni.com", "eva.dvorakova@uni.com", "filip.fiala@uni.com", "hana.horakova@uni.com"]}, "passenger_full_name": {"is_pk": False, "distinct_count_in_sample": 5, "samples": ["Anna Benesova", "David Cerna", "Eva Dvorakova", "Filip Fiala", "Hana Horak"]}}}
schema = """schema:
    passenger_information:
        passenger_email: passenger_information.passenger_email
        passenger_full_name: passenger_information.passenger_full_name
    tvoja_mamka:
        tvoja_mamka: tvoja_mamka.tvoja_mamka
"""


go_over_schema(schema, samples)