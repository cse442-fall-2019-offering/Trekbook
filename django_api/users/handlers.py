from django.http import HttpResponse
from django.contrib.auth import authenticate


class LoginHandler:

    @staticmethod
    def login(username: str, password: str):
        user = authenticate(username=username, password=password)

        if not user:
            return HttpResponse("bad login")

        return HttpResponse(f"{username}, {password}")