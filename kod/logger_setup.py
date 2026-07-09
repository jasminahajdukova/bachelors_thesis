import logging
import colorlog


logging.getLogger("mysql.connector").setLevel(logging.WARNING)

logging.getLogger("httpx").setLevel(logging.WARNING)

handler = colorlog.StreamHandler()

logger = logging.getLogger()
logger.addHandler(handler)
logger.setLevel(logging.INFO)
logger.propagate = False

handler.setFormatter(colorlog.ColoredFormatter(
	'%(asctime)s %(log_color)s %(levelname)s: %(message)s',
    datefmt='%Y-%m-%d %H:%M:%S'))

