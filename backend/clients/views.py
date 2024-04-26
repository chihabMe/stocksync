from django.shortcuts import render
from rest_framework.generics import ListAPIView
from .serializers import ClientSerialize
from accounts.serializers import UserSerializer
from common.permissions import IsAdmin
from django.contrib.auth import get_user_model

User  = get_user_model()


class ClientsListView(ListAPIView):
    serializer_class = UserSerializer
    permission_classes = [IsAdmin]
    def get_queryset(self):
        return User.objects.filter(user_type=User.UserTypesChoices.CLIENT)
