from django.urls import path

from .views import UserProfileUpdateRetrieveView, UserRegistrationView

app_name = "accounts"

urlpatterns = [
    path("register/", UserRegistrationView.as_view(), name="register"),
    path("profile/", UserProfileUpdateRetrieveView.as_view(), name="profile"),
]
