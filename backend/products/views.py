from rest_framework.generics import ListAPIView, RetrieveAPIView,ListCreateAPIView,RetrieveUpdateDestroyAPIView
from .models import Product,ProductCategory
from rest_framework.permissions import AllowAny
from .serializers import  ProductSerializer,ProductCategoryManagerSerializer,ProductCategorySerializer
from common.permissions    import IsAdmin


## views for the client 
class ProductsAddListView(ListAPIView):
    queryset = Product.objects.all()
    permission_classes = [AllowAny]
    serializer_class = ProductSerializer
    def get_queryset(self):
        order_by = self.request.GET.get("order_by")
        if order_by=="new":
            return Product.objects.all().order_by("-created_at")
        return Product.objects.all()


class ProductCreateUpdateDestroyView(RetrieveAPIView):
    permission_classes = [AllowAny]
    queryset = Product.objects.all()
    lookup_field = 'slug'
    serializer_class = ProductSerializer

class ProductCategoryListView(ListAPIView):
    queryset = ProductCategory.objects.all()
    permission_classes = [AllowAny]
    serializer_class = ProductCategorySerializer

## views for the admin user 
class ProductCategoryListCreateManagerView(ListCreateAPIView):
    queryset = ProductCategory.objects.all()
    permission_classes = [AllowAny,IsAdmin]
    serializer_class = ProductCategoryManagerSerializer

class ProductCategoryUpdateDeleteView(RetrieveUpdateDestroyAPIView):
    queryset = ProductCategory.objects.all()
    permission_classes = [AllowAny]
    lookup_field = 'id'
    serializer_class = ProductCategoryManagerSerializer