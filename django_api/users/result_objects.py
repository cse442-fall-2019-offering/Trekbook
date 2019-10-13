from trekbook_base.result_object import ApiResult
from users.models import User


class LoginResult(ApiResult):
    def __init__(self, user: User):
        self.user = user

    def serialize(self, version: int = 1) -> dict:
        serialized = {
            'user_id': self.user.user_id,
            'first_name': self.user.firstname,
            'last_name': self.user.lastname,
            'username': self.user.username
        }

        return serialized
