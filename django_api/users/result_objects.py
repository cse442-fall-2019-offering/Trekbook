from trekbook_base.result_object import ApiResult
from users.models import User
import random

class LoginResult(ApiResult):
    def __init__(self, user: User):
        self.user = user

    def serialize(self, version: int = 1) -> dict:
        serialized = {
            'user_id': self.user.user_id,
            'first_name': self.user.firstname,
            'last_name': self.user.lastname,
            'username': self.user.username,
            'fullname': self.user.firstname + " " + self.user.lastname,
            'numbervisited': str(random.randint(1,30)) + " places visited"
        }

        return serialized


class LogoutResult(ApiResult):
    def __init__(self):
        pass

    def serialize(self, version: int = 1) -> dict:
        serialized = {
            'message': 'Logged out!'
        }

        return serialized


class GetUserResult(ApiResult):
    def __init__(self, users):
        self.users = users

    def serialize(self, version: int = 1) -> dict:
        serialized = {
            'users': [LoginResult(user).serialize() for user in self.users]
        }

        return serialized
