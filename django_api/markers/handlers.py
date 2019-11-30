from markers.models import Marker
from markers.result_objects import MarkerSubmissionResult, MarkerGetResult


class MarkerHandler:

    @staticmethod
    def submit_marker(title: str, description: str, latitude: float, longitude: float, user_id: int):
        marker = Marker.objects.create(user_id=user_id, title=title, description=description, latitude=latitude, longitude=longitude)

        return MarkerSubmissionResult(marker)

    @staticmethod
    def get_markers(user_id: int):
        markers = Marker.objects.filter(user_id=user_id)

        return MarkerGetResult(markers)
