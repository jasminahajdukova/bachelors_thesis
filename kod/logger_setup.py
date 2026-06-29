import logging
import colorlog

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

