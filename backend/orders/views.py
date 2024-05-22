from django.shortcuts import render
from rest_framework.generics import ListCreateAPIView,UpdateAPIView
from .models import Order
from rest_framework.permissions import IsAuthenticated
from common.permissions import IsClient
from .serializers import OrderSerializer
from rest_framework.response import Response
from rest_framework import status

# Create your views here.


##view for the client to get/create/cancels  orders
##/orders/  (get,post) get = list of orders  post create one order
class OrdersClientListCreateView(ListCreateAPIView):
    permission_classes = [IsAuthenticated,IsClient]
    serializer_class = OrderSerializer

    def get_queryset(self):
        user = self.request.user
        return Order.objects.filter(user=user)
class OrderClientCancelView(UpdateAPIView):
    queryset = Order.objects.all()
    permission_classes = [IsAuthenticated,IsClient]
    serializer_class = OrderSerializer
    lookup_field = 'id'


    def put(self,request,*args,**kwargs):
        instance = self.get_object()
        instance.status = Order.OrderStatusChoices.CANCELED
        instance.save()
        return Response(status=status.HTTP_201_CREATED)


    def has_object_permission(self, request, view, obj):
        print(obj.user)
        print(request.user)
        return obj.user == request.user



class OrderClientDestroy():
    pass

##/order/<id>/ (get order detials, delete, update)

## view for the seller to manage the received orders