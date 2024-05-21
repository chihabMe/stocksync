from django.urls import path
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView,TokenVerifyView

from .views import TokenLogoutView,AuthenticatedUserView

app_name = "authentication"

urlpatterns = [
    path("token/obtain/", TokenObtainPairView.as_view(), name="token-obtain_pair"),
    path("token/verify/", TokenVerifyView.as_view(), name="token-verify"),
    path("token/refresh/", TokenRefreshView.as_view(), name="token-refresh"),
    path("token/logout/", TokenLogoutView.as_view(), name="token-logout"),
    path("me/", AuthenticatedUserView.as_view(), name="authenacted-user"),
]
