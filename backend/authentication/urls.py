from django.urls import path
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView,TokenVerifyView

from .views import (TokenLogoutView,AuthenticatedUserView,LoginViewWithCookies,RefreshAuthCookies)

app_name = "authentication"

urlpatterns = [
    path("login/", LoginViewWithCookies.as_view(), name="login-view"),
    path("refresh/", RefreshAuthCookies.as_view(), name="refresh-view"),
    path("token/obtain/", TokenObtainPairView.as_view(), name="token-obtain_pair"),
    path("token/verify/", TokenVerifyView.as_view(), name="token-verify"),
    path("token/refresh/", TokenRefreshView.as_view(), name="token-refresh"),
    path("token/logout/", TokenLogoutView.as_view(), name="token-logout"),
    path("me/", AuthenticatedUserView.as_view(), name="authenacted-user"),
]
