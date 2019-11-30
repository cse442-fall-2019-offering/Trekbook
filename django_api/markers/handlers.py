from markers.models import Marker
from markers.result_objects import MarkerSubmissionResult


class MarkerHandler:

    @staticmethod
    def submit_marker(title: str, description: str, latitude: float, longitude: float, user_id: int):
        Marker.objects.create(user_id=user_id, title=title, description=description, latitude=latitude, longitude=longitude)

        return MarkerSubmissionResult()
