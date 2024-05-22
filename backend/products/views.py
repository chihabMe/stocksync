from rest_framework.generics import ListAPIView, RetrieveAPIView,ListCreateAPIView,RetrieveUpdateDestroyAPIView,GenericAPIView,UpdateAPIView,DestroyAPIView
from .models import Product,ProductCategory
from rest_framework.permissions import AllowAny,IsAuthenticated
from .serializers import  ProductSerializer,ProductCategoryManagerSerializer,ProductCategorySerializer,SellerProductSerializer
from common.permissions    import IsAdmin,IsSeller,IsClient
from rest_framework.response import Response



## views for the client 
class ProductsAddListView(ListAPIView):
    queryset = Product.objects.all()
    permission_classes = [IsAuthenticated,IsClient]
    serializer_class = ProductSerializer
    def get_queryset(self):
        query = self.request.GET.get("query")
        order_by = self.request.GET.get("order_by")
        if order_by=="new":
            return Product.objects.all().order_by("-created_at")
        if query is not None:
            return Product.objects.filter(name__icontains=query)
        return Product.objects.all()
class LikedProductsListView(ListAPIView):
    queryset = Product.objects.all()
    permission_classes = [IsAuthenticated,IsClient]
    serializer_class = ProductSerializer
    def get_queryset(self):
        user = self.request.user
        return user.favorites.all()
class LikeProductView(GenericAPIView):
    def post(self,request,id):
        product = Product.objects.get(id=id)
        user = request.user
        if user in product.favored_by.all():
            product.favored_by.remove(user)
            return Response({"message":"unliked"})
        else:
            product.favored_by.add(user)
            return Response({"message":"liked"})

class ProductClientDetailsView(RetrieveAPIView):
    permission_classes = [IsAuthenticated,IsClient]
    queryset = Product.objects.all()
    lookup_field = 'id'
    serializer_class = ProductSerializer

class ProductCreateUpdateDestroyView(RetrieveUpdateDestroyAPIView):
    permission_classes = [IsAuthenticated,IsSeller]
    queryset = Product.objects.all()
    lookup_field = 'id'
    serializer_class = ProductSerializer

class ProductCategoryListView(ListAPIView):
    queryset = ProductCategory.objects.all()
    permission_classes = [IsAuthenticated]
    serializer_class = ProductCategorySerializer


## views for the seller 
class ProductSellerListCreateView(ListCreateAPIView):
    serializer_class = SellerProductSerializer
    permission_classes = [IsAuthenticated,IsSeller]
    def get_queryset(self):
        user = self.request.user
        return Product.objects.filter(user=user)
class ProductSellerDestroyUpdateView(DestroyAPIView,UpdateAPIView):
    serializer_class = SellerProductSerializer
    permission_classes = [IsAuthenticated,IsSeller]
    lookup_field = "id"
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