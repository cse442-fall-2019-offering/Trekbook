from django.urls import path

from . import views

urlpatterns = [
    path('marker', views.MarkerView.as_view())
]
