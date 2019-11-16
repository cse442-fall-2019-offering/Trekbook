from django.urls import path

from . import views

urlpatterns = [
    path('users', views.GetUsersView.as_view()),
    path('login', views.LoginView.as_view()),
    path('signup', views.SignupView.as_view()),
    path('logout', views.LogoutView.as_view())
]
