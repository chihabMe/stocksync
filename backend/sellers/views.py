from django.shortcuts import render
from .serializers import SellerProfileSerializer,SellerProfileSerializerForAdmin
from .models import SellerProfile
from rest_framework.permissions import IsAuthenticated

from common.permissions import IsSellerOrAdmin,IsAdmin
from rest_framework.generics import ListAPIView,RetrieveUpdateDestroyAPIView
from django.contrib.auth import get_user_model
User  = get_user_model()

class SellersListView(ListAPIView):
    serializer_class = SellerProfileSerializer
    permission_classes = [IsAuthenticated,IsAdmin]

    def get_queryset(self):
        return SellerProfile.objects.all()

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
        return super().get_serializer_class()



