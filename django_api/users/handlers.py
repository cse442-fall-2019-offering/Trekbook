from django.http import HttpResponse, HttpResponseForbidden
from django.contrib.auth import authenticate
from users.result_objects import LoginResult
from users.exceptions import InvalidCredentialsException


class LoginHandler:

    @staticmethod
    def login(username: str, password: str):
        user = authenticate(username=username, password=password)

        if not user:
            raise InvalidCredentialsException()

        return LoginResult(user)
