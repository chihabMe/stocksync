from django.urls import path

from .views import (
    UserProfileUpdateRetrieveView, UserRegistrationView,
    SellersListView,
    AdminGetAcceptRemoveSeller
    )

app_name = "accounts"

urlpatterns = [
    path("register/", UserRegistrationView.as_view(), name="register"),
    path("profile/", UserProfileUpdateRetrieveView.as_view(), name="profile"),
    path("sellers/", SellersListView.as_view(), name="sellers"),
    path("sellers/<str:id>/", AdminGetAcceptRemoveSeller.as_view(), name="seller"),
]
