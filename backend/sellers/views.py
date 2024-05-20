from django.shortcuts import render
from .serializers import SellerProfileSerializer,SellerProfileSerializerForAdmin
from .models import SellerProfile
from rest_framework.permissions import IsAuthenticated,AllowAny
from accounts.serializers import UserSerializer
from django.shortcuts import get_object_or_404

from common.permissions import IsSellerOrAdmin,IsAdmin
from rest_framework.generics import ListAPIView,RetrieveUpdateDestroyAPIView
from django.contrib.auth import get_user_model
User  = get_user_model()

class SellersListView(ListAPIView):
    serializer_class = UserSerializer
    permission_classes = [IsAuthenticated,IsAdmin]


    def get_queryset(self):
        return User.objects.filter(is_active=True,user_type=User.UserTypesChoices.SELLER)


class SellersActivationRequestsListView(ListAPIView):
    serializer_class = UserSerializer
    permission_classes = [IsAuthenticated,IsAdmin]
    def get_queryset(self):
        return  User.objects.filter(is_active=False,user_type=User.UserTypesChoices.SELLER)
# class ActiveSellerAccount(RetrieveUpdateDestroyAPIView):
#     serializer_class = UserSerializer
#     permission_classes = [IsAuthenticated,IsAdmin]
#     lookup_field = "id"

#     def get_queryset(self):
#         return User.objects.filter(is_active=False,user_type=User.UserTypesChoices.SELLER)

#     def get_serializer_class(self):
#         return UserSerializer

#     def update(self, request, *args, **kwargs):
#         instance = self.get_object()
#         instance.is_active = request.data.get("is_active",instance.is_active)
#         instance.save()
#         return Response(self.get_serializer(instance).data)

class SellerDetailserializer(RetrieveUpdateDestroyAPIView):
    permission_classes = [IsAuthenticated,IsSellerOrAdmin]
    lookup_field = "id"

    def get_queryset(self):
        return SellerProfile.objects.all()


    def get_serializer_class(self):
        user_type = self.request.user.user_type
        if user_type == User.UserTypesChoices.ADMIN:
            return SellerProfileSerializerForAdmin
        return SellerProfileSerializer



