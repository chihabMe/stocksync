from rest_framework.generics import CreateAPIView, RetrieveUpdateAPIView
from rest_framework.permissions import AllowAny, IsAuthenticated

from .models import CustomUser as User
from .models import SellerProfile, UserProfile
from .serializers import (
    SellerProfileSerializer,
    UserProfileSerializer,
    UserRegistrationSerializer,
)


class UserRegistrationView(CreateAPIView):
    serializer_class = UserRegistrationSerializer
    permission_classes = [AllowAny]


class UserProfileUpdateRetrieveView(RetrieveUpdateAPIView):
    permission_classes = [IsAuthenticated]

    def get_object(self):
        user_type = self.request.user.user_type
        if user_type == User.UserTypesChoices.USER:
            return self.request.user.user_profile
        elif user_type == User.UserTypesChoices.SELLER:
            return self.request.user.seller_profile
        return None

    def get_serializer_class(self):
        user_type = self.request.user.user_type
        if user_type == User.UserTypesChoices.USER:
            return UserProfileSerializer
        elif user_type == User.UserTypesChoices.SELLER:
            return SellerProfileSerializer
        return None  # Handle other cases or raise appropriate error
