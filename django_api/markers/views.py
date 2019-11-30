from django.shortcuts import render
from django.views.generic import View
from markers.handlers import MarkerHandler
from markers.result_objects import MarkerSubmissionResult


class MarkerView(View):
    """
    handles URLs:
        /v1/marker [POST]
    """

    def post(self, request, api_version, *args, **kwargs) -> MarkerSubmissionResult:

        title = request.data.get('title')
        description = request.data.get('description')
        latitude = request.data.get('latitude')
        longitude = request.data.get('longitude')
        userid = request.data.get('user_id')

        return MarkerHandler.submit_marker(title, description, latitude, longitude, user_id=userid)