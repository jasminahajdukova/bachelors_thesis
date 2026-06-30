import logging
import colorlog


logging.getLogger("mysql.connector").setLevel(logging.WARNING)
logging.getLogger("psycopg2").setLevel(logging.WARNING)
logging.getLogger("httpx").setLevel(logging.WARNING)

handler = colorlog.StreamHandler()
handler.setFormatter(colorlog.ColoredFormatter(
	'%(asctime)s %(log_color)s %(message)s',
    datefmt='%Y-%m-%d %H:%M:%S'))

logger = logging.getLogger()
logger.addHandler(handler)
logger.setLevel(logging.INFO)
logger.propagate = False

# handler.setFormatter(colorlog.ColoredFormatter(
# 	'%(asctime)s %(log_color)s %(levelname)s: %(name)s:%(message)s',
#     datefmt='%Y-%m-%d %H:%M:%S'))

