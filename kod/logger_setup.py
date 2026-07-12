import logging
import colorlog


REPAIR = 25
STAGE = 26

def repair(self, message, *args, **kwargs):
        if self.isEnabledFor(REPAIR):
            self._log(REPAIR, message, args, **kwargs)

def stage(self, message, *args, **kwargs):
        if self.isEnabledFor(STAGE):
            self._log(STAGE, message, args, **kwargs)

logging.Logger.repair = repair
logging.Logger.stage = stage
    
def setup_logging():

    logging.addLevelName(REPAIR, "REPAIR")
    logging.addLevelName(STAGE, "STAGE")

    logging.getLogger("mysql.connector").setLevel(logging.WARNING)
    logging.getLogger("httpx").setLevel(logging.WARNING)


    handler = colorlog.StreamHandler()

    colorlog.escape_codes.escape_codes['color211'] = '\033[38;5;211m'

    formatter = colorlog.ColoredFormatter('%(asctime)s %(log_color)s %(levelname)-8s: %(message)s',
        datefmt='%Y-%m-%d %H:%M:%S',
        log_colors={
                'DEBUG':    'cyan',
                'INFO':     'green',
                'REPAIR':   'bold_cyan',
                'WARNING':  'yellow',
                'ERROR':    'red',
                'STAGE':     'color211'})
    
    handler.setFormatter(formatter)

    logger = logging.getLogger()
    logger.addHandler(handler)
    logger.setLevel(logging.INFO)
    logger.propagate = False
    
    return logger


logger = setup_logging()