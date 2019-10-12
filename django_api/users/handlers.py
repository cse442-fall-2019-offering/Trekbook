from django.http import HttpResponse, HttpResponseForbidden
from django.contrib.auth import authenticate


class LoginHandler:

    @staticmethod
    def login(username: str, password: str):
        user = authenticate(username=username, password=password)

        if not user:
            return HttpResponseForbidden(f"The username/password combination you entered is invalid.")

        return HttpResponse(f"{username}, {password}")