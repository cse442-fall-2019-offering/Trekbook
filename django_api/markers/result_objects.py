from trekbook_base.result_object import ApiResult
from markers.models import Marker
import random


class MarkerSubmissionResult(ApiResult):
    def __init__(self):
        pass

    def serialize(self, version: int = 1) -> dict:
        serialized = {
            'message': 'Marker successfully submitted!'
        }

        return serialized
