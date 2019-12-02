from trekbook_base.result_object import ApiResult
from markers.models import Marker
import random


class MarkerSubmissionResult(ApiResult):
    def __init__(self, marker):
        self.marker = marker

    def serialize(self, version: int = 1) -> dict:
        serialized = {
            'user_id': self.marker.user_id,
            'title': self.marker.title,
            'description': self.marker.description,
            'latitude': self.marker.latitude,
            'longitude': self.marker.longitude
        }

        return serialized


class MarkerGetResult(ApiResult):
    def __init__(self, markers):
        self.markers = markers

    def serialize(self, version: int = 1) -> dict:
        serialized = {
            'markers': [MarkerSubmissionResult(marker).serialize() for marker in self.markers]
        }

        return serialized