from rest_framework.generics import CreateAPIView, RetrieveUpdateAPIView,RetrieveAPIView,ListAPIView,GenericAPIView,RetrieveUpdateDestroyAPIView
from rest_framework.mixins import Response,DestroyModelMixin,UpdateModelMixin
from rest_framework.permissions import AllowAny, IsAuthenticated
from .permissions import IsAdmin
from .models import SellerProfile

from .models import CustomUser as User
from .serializers import (
    SellerProfileSerializer,
    SellerProfileSerializerForAdmin,
    UserProfileSerializer,
    UserRegistrationSerializer,

    UserSerializer
)


class UserRegistrationView(CreateAPIView):
    serializer_class = UserRegistrationSerializer
    permission_classes = [AllowAny]


class SellersListView(ListAPIView):
    serializer_class = SellerProfileSerializer
    permission_classes = [IsAuthenticated,IsAdmin]

    def get_queryset(self):
        return SellerProfile.objects.all()
    
class AdminGetAcceptRemoveSeller(RetrieveUpdateDestroyAPIView):
    serializer_class = SellerProfileSerializerForAdmin
    permission_classes = [IsAuthenticated,IsAdmin]
    lookup_field = "id"

    def get_queryset(self):
        print(self.request)
        return SellerProfile.objects.all()








class UserProfileUpdateRetrieveView(RetrieveUpdateAPIView):

    def get_object(self):
        user_type = self.request.user.user_type
        print("User type:", user_type)
        if user_type == User.UserTypesChoices.USER:
            user_profile = self.request.user.user_profile
            print("User profile:", user_profile)
            return user_profile
        elif user_type == User.UserTypesChoices.SELLER:
            seller_profile = self.request.user.seller_profile
            print("Seller profile:", seller_profile)
            return seller_profile
        return None

    def get_serializer_class(self):
        user_type = self.request.user.user_type
        if user_type == User.UserTypesChoices.USER:
            return UserProfileSerializer
        elif user_type == User.UserTypesChoices.SELLER:
            return SellerProfileSerializer
        return None  # Handle other cases or raise appropriate error

    def retrieve(self, request, *args, **kwargs):
        print("retrieve")
        instance = self.get_object()
        print(instance)
        print()
        serializer = self.get_serializer(instance)
        print(serializer.data)  # Add this line to inspect the serialized data
        return Response(serializer.data)
