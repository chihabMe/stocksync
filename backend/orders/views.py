from django.shortcuts import render
from rest_framework.generics import ListCreateAPIView,UpdateAPIView,ListAPIView
from .models import Order
from rest_framework.permissions import IsAuthenticated
from common.permissions import IsClient,IsSeller
from .serializers import OrderSerializer,OrderSellerManagerSerializer
from rest_framework.response import Response
from rest_framework import status
from products.models import Product 


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
        if instance.status != Order.OrderStatusChoices.PENDING:
            return Response(status=status.HTTP_400_BAD_REQUEST)
        instance.status = Order.OrderStatusChoices.CANCELED
        instance.save()
        return Response(status=status.HTTP_201_CREATED)


    def has_object_permission(self, request, view, obj):
        print(obj.user)
        print(request.user)
        return obj.user == request.user


class OrderSellerListView(ListAPIView):
    serializer_class = OrderSellerManagerSerializer
    permission_classes = [IsAuthenticated, IsSeller]
    
    def get_queryset(self):
        user = self.request.user
        # Assuming the seller is associated with the product via a `seller` field
        # Fetch all products belonging to the current seller
        seller_products = Product.objects.filter(user=user)
        # Get all orders that include these products
        orders = Order.objects.filter(items__product__in=seller_products).distinct()
        return orders



class OrderSellerUpdateStatus(UpdateAPIView):
    permission_classes = [IsAuthenticated, IsSeller]
    lookup_field = "id"
    queryset = Order.objects.all()

    def update(self, request, *args, **kwargs):
        instance = self.get_object()
        new_status = request.data.get('status', None)
        
        # Check if the new status is valid
        valid_statuses = [Order.OrderStatusChoices.ACCEPTED, Order.OrderStatusChoices.CANCELED, Order.OrderStatusChoices.RECEIVED, Order.OrderStatusChoices.PENDING,Order.OrderStatusChoices.COMPLETED]
        if new_status not in valid_statuses:
            return Response({'error': 'Invalid order status'}, status=status.HTTP_400_BAD_REQUEST)

        instance.status = new_status
        instance.save()
        
        return Response(status=status.HTTP_200_OK)