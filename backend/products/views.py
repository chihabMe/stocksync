from rest_framework.generics import ListAPIView, RetrieveAPIView,ListCreateAPIView,RetrieveUpdateDestroyAPIView
from .models import Product,ProductCategory
from rest_framework.permissions import AllowAny
from .serializers import BasicProductSerializer, DetailedProductSerializer,ProductCategoryManagerSerializer
from common.permissions    import IsAdmin


class ProductsAddListView(ListAPIView):
    queryset = Product.objects.all()
    permission_classes = [AllowAny]
    serializer_class = BasicProductSerializer

class DetailedProductView(RetrieveAPIView):
    permission_classes = [AllowAny]
    queryset = Product.objects.all()
    lookup_field = 'slug'
    serializer_class = DetailedProductSerializer

class ProductCategoryListCreateManagerView(ListCreateAPIView):
    queryset = ProductCategory.objects.all()
    permission_classes = [AllowAny,IsAdmin]
    serializer_class = ProductCategoryManagerSerializer
class ProductCategoryUpdateDeleteView(RetrieveUpdateDestroyAPIView):
    queryset = ProductCategory.objects.all()
    permission_classes = [AllowAny]
    lookup_field = 'id'
    serializer_class = ProductCategoryManagerSerializer