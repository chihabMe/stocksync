from django.shortcuts import render


from rest_framework.generics import ListAPIView,DestroyAPIView,RetrieveDestroyAPIView
from .models import Complain
from .serializers import ComplainManagerSerializer
from common.permissions import IsAdmin
from rest_framework.permissions import IsAuthenticated


class ManageComplainsView(ListAPIView):
    queryset = Complain.objects.all()
    serializer_class = ComplainManagerSerializer
    permission_classes = [IsAuthenticated,IsAdmin]

class ManageComplainView(DestroyAPIView,RetrieveDestroyAPIView):
    queryset = Complain.objects.all()
    serializer_class = ComplainManagerSerializer
    permission_classes = [IsAuthenticated,IsAdmin]

