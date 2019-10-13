from django.shortcuts import render
from django.views.generic import View
from users.handlers import LoginHandler
import json
from users.result_objects import LoginResult


class LoginView(View):
    """
    handles URLs:
        /v1/login [POST]
    """

    def post(self, request, api_version, *args, **kwargs) -> LoginResult:
        """Login
        Handles a login request.
        :param request: API POST request object
        :param api_version: API version
        :return: LoginResult
        """

        username = request.data.get('username', '')
        password = request.data.get('password', '')

        return LoginHandler.login(username, password)
