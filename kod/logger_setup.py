"""
@file logger_setup.py
@author Jasmina Hajdukova (xhajdu07)
@brief color console logging with custom log levels
"""

import logging
import colorlog

from typing import Any


FIX    = 25
STAGE  = 26
TOKENS = 27
FINISH = 28

def fix(self: logging.Logger, message: str, *args: Any, **kwargs: Any) -> None:
        if self.isEnabledFor(FIX):
            self._log(FIX, message, args, **kwargs)

def stage(self: logging.Logger, message: str, *args: Any, **kwargs: Any) -> None:
        if self.isEnabledFor(STAGE):
            self._log(STAGE, message, args, **kwargs)

def tokens(self: logging.Logger, message: str, *args: Any, **kwargs: Any) -> None:
        if self.isEnabledFor(TOKENS):
            self._log(TOKENS, message, args, **kwargs)

def finish(self: logging.Logger, message: str, *args: Any, **kwargs: Any) -> None:
        if self.isEnabledFor(FINISH):
            self._log(FINISH, message, args, **kwargs)

logging.Logger.fix    = fix 
logging.Logger.stage  = stage
logging.Logger.tokens = tokens
logging.Logger.finish = finish

def setup_logging() -> logging.Logger:

    logging.addLevelName(FIX, "FIX")
    logging.addLevelName(STAGE, "STAGE")
    logging.addLevelName(TOKENS, "TOKENS")
    logging.addLevelName(FINISH, "FINISH")

    logging.getLogger("mysql.connector").setLevel(logging.WARNING)
    logging.getLogger("httpx").setLevel(logging.WARNING)


    handler = colorlog.StreamHandler()

    colorlog.escape_codes.escape_codes['colour211'] = '\033[38;5;211m'
    colorlog.escape_codes.escape_codes['colour64'] = '\033[38;5;64m'
    colorlog.escape_codes.escape_codes['colour26'] = '\033[38;5;26m'
    colorlog.escape_codes.escape_codes['colour208'] = '\033[38;5;208m'

    colorlog.escape_codes.escape_codes['colour196'] = '\033[38;5;196m'
    colorlog.escape_codes.escape_codes['colour123'] = '\033[38;5;123m'
    colorlog.escape_codes.escape_codes['colour83'] = '\033[38;5;83m'
    colorlog.escape_codes.escape_codes['colour3'] = '\033[38;5;3m'

    formatter = colorlog.ColoredFormatter('%(asctime)s %(log_color)s %(levelname)-8s: %(message)s',
        datefmt='%Y-%m-%d %H:%M:%S',
        log_colors={
                'DEBUG':    'colour3',
                'INFO':     'colour83',
                'FIX':      'colour123',
                'WARNING':  'colour26',
                'ERROR':    'colour196',
                'STAGE':    'colour211',
                'TOKENS':   'colour64',
                'FINISH':   'colour208'})
    
    handler.setFormatter(formatter)

    logger = logging.getLogger()
    logger.addHandler(handler)
    logger.setLevel(logging.INFO)
    logger.propagate = False
    
    return logger


logger = setup_logging()