from rest_framework.generics import ListAPIView, RetrieveAPIView
from .models import Product
from rest_framework.permissions import AllowAny
from .serializers import BasicProductSerializer, DetailedProductSerializer

class ProductsAddListView(ListAPIView):
    queryset = Product.objects.all()
    permission_classes = [AllowAny]
    serializer_class = BasicProductSerializer

class DetailedProductView(RetrieveAPIView):
    permission_classes = [AllowAny]
    queryset = Product.objects.all()
    lookup_field = 'slug'
    serializer_class = DetailedProductSerializer