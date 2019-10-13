from trekbook_base.exceptions import TrekbookException
from typing import Optional


class InvalidCredentialsException(TrekbookException):
    http_code = 401

    def __init__(self):
        message = f"The username/password combination you entered is invalid."
        super().__init__(message)


class DuplicateUserException(TrekbookException):
    http_code = 401

    def __init__(self):
        message = f"The username has already been registered."
        super().__init__(message)