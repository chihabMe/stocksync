from django.urls import path

from .views import UserRegistrationView

app_name = "accounts"

urlpattrens = [
    path("register/", UserRegistrationView.as_view(), name="register"),
]
