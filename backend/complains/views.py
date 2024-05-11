from django.shortcuts import render


from rest_framework.generics import ListAPIView,RetrieveUpdateDestroyAPIView
from .models import Complain
from .serializers import ComplainManagerSerializer
from common.permissions import IsAdmin
from rest_framework.permissions import IsAuthenticated


class ManageComplainsView(ListAPIView):
    queryset = Complain.objects.all()
    serializer_class = ComplainManagerSerializer
    permission_classes = [IsAuthenticated,IsAdmin]

class ManageComplainView(RetrieveUpdateDestroyAPIView):
    lookup_field = "id"
    queryset = Complain.objects.all()
    serializer_class = ComplainManagerSerializer
    permission_classes = [IsAuthenticated,IsAdmin]




