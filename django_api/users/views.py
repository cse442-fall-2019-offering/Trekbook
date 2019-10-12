from django.shortcuts import render
from django.views.generic import View
from users.handlers import LoginHandler
import json

class LoginView(View):
    """
    handles URLs:
        /v1/login [POST]
    """

    def post(self, request, api_version, *args, **kwargs):
        """Login
        Handles a login request.
        :param request: API POST request object
        :param api_version: API version
        :return: LoginResult
        """

        username = request.POST.get('username', '')
        password = request.POST.get('password', '')

        return LoginHandler.login(username, password)
