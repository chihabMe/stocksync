from django.shortcuts import render
from rest_framework.generics import ListAPIView
from .serializers import ClientManagerSerializer
from accounts.serializers import UserSerializer
from common.permissions import IsAdmin
from django.contrib.auth import get_user_model
from rest_framework.generics import RetrieveUpdateDestroyAPIView  
from .models import ClientProfile
from django.shortcuts import get_object_or_404

User  = get_user_model()


class ClientsListView(ListAPIView):
    serializer_class = UserSerializer
    permission_classes = [IsAdmin]
    def get_queryset(self):
        return User.objects.filter(user_type=User.UserTypesChoices.CLIENT)

class ClientManagerView(RetrieveUpdateDestroyAPIView):
    serializer_class = ClientManagerSerializer
    queryset = ClientProfile.objects.all()
    lookup_field = "id"
    permission_classes = [IsAdmin]
    def get_object(self):
        return get_object_or_404(ClientProfile,user__id=self.kwargs.get("id"))
