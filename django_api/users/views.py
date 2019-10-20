from django.shortcuts import render
from django.views.generic import View
from users.handlers import LoginHandler, SignupHandler
import json
from users.result_objects import LoginResult, LogoutResult


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


class SignupView(View):
    """
    handles URLs:
        /v1/signup [POST]
    """

    def post(self, request, api_version, *args, **kwargs) -> LoginResult:
        """

        :param request:
        :param api_version:
        :param args:
        :param kwargs:
        :return:
        """

        username = request.data.get('username')
        password = request.data.get('password')
        firstname = request.data.get('firstname')
        lastname = request.data.get('lastname')

        return SignupHandler.signup(username, password, firstname, lastname)


class LogoutView(View):
    """
    handles URLs:
        /v1/logout [POST]
    """

    def post(self, request, api_version, *args, **kwargs) -> LogoutResult:

        return LogoutResult()