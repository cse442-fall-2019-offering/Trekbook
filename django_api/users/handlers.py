from django.contrib.auth import authenticate
from users.result_objects import LoginResult
from users.exceptions import InvalidCredentialsException, DuplicateUserException
from users.models import User


class LoginHandler:

    @staticmethod
    def login(username: str, password: str) -> LoginResult:
        user = authenticate(username=username, password=password)

        if not user:
            raise InvalidCredentialsException()

        return LoginResult(user)


class SignupHandler:

    @staticmethod
    def signup(username: str, password: str, firstname: str, lastname: str) -> LoginResult:
        try:
            User.objects.get(username=username)
            raise DuplicateUserException()

        except User.DoesNotExist:
            pass

        extra_params = {'firstname': firstname, 'lastname': lastname}

        user = User.objects.create_user(username=username, password=password, **extra_params)

        return LoginResult(user)
