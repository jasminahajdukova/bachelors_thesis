import logging
import colorlog


REPAIR = 25
STAGE = 26
TOKENS = 27
FINISH = 28

def repair(self, message, *args, **kwargs):
        if self.isEnabledFor(REPAIR):
            self._log(REPAIR, message, args, **kwargs)

def stage(self, message, *args, **kwargs):
        if self.isEnabledFor(STAGE):
            self._log(STAGE, message, args, **kwargs)

def tokens(self, message, *args, **kwargs):
        if self.isEnabledFor(TOKENS):
            self._log(TOKENS, message, args, **kwargs)

def finish(self, message, *args, **kwargs):
        if self.isEnabledFor(FINISH):
            self._log(FINISH, message, args, **kwargs)

logging.Logger.repair = repair
logging.Logger.stage = stage
logging.Logger.tokens = tokens
logging.Logger.finish = finish

def setup_logging():

    logging.addLevelName(REPAIR, "REPAIR")
    logging.addLevelName(STAGE, "STAGE")
    logging.addLevelName(TOKENS, "TOKENS")
    logging.addLevelName(FINISH, "FINISH")

    logging.getLogger("mysql.connector").setLevel(logging.WARNING)
    logging.getLogger("httpx").setLevel(logging.WARNING)


    handler = colorlog.StreamHandler()

    colorlog.escape_codes.escape_codes['colour211'] = '\033[38;5;211m'
    colorlog.escape_codes.escape_codes['colour64'] = '\033[38;5;64m'
    colorlog.escape_codes.escape_codes['colour26'] = '\033[38;5;26m'
    colorlog.escape_codes.escape_codes['colour46'] = '\033[38;5;46m'

    colorlog.escape_codes.escape_codes['colour196'] = '\033[38;5;196m'
    colorlog.escape_codes.escape_codes['colour123'] = '\033[38;5;123m'
    colorlog.escape_codes.escape_codes['colour83'] = '\033[38;5;83m'
    colorlog.escape_codes.escape_codes['colour3'] = '\033[38;5;3m'

    formatter = colorlog.ColoredFormatter('%(asctime)s %(log_color)s %(levelname)-8s: %(message)s',
        datefmt='%Y-%m-%d %H:%M:%S',
        log_colors={
                'DEBUG':    'colour3',
                'INFO':     'colour83',
                'REPAIR':   'bold_colour123',
                'WARNING':  'colour26',
                'ERROR':    'bold_colour196',
                'STAGE':    'colour211',
                'TOKENS':   'colour64',
                'FINISH':   'colour46'})
    
    handler.setFormatter(formatter)

    logger = logging.getLogger()
    logger.addHandler(handler)
    logger.setLevel(logging.INFO)
    logger.propagate = False
    
    return logger


logger = setup_logging()