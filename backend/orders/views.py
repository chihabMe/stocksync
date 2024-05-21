from django.shortcuts import render
from rest_framework.generics import ListCreateAPIView
from .models import Order
from rest_framework.permissions import IsAuthenticated
from common.permissions import IsClient
from .serializers import OrderSerializer

# Create your views here.


##view for the client to get/create/cancels  orders
##/orders/  (get,post) get = list of orders  post create one order
class OrdersClientListCreateView(ListCreateAPIView):
    permission_classes = [IsAuthenticated,IsClient]
    serializer_class = OrderSerializer

    def get_queryset(self):
        user = self.request.user
        return Order.objects.filter(user=user)

class OrderClientDestroy():
    pass

##/order/<id>/ (get order detials, delete, update)

## view for the seller to manage the received orders