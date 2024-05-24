from rest_framework.generics import ListAPIView, RetrieveAPIView,ListCreateAPIView,RetrieveUpdateDestroyAPIView,GenericAPIView,UpdateAPIView,DestroyAPIView
from .models import Product,ProductCategory
from rest_framework.views import APIView
from rest_framework.permissions import AllowAny,IsAuthenticated
from .serializers import  ProductSerializer,ProductCategoryManagerSerializer,ProductCategorySerializer,SellerProductSerializer,ProductCouponManagerSerializer,CouponSerializer
from common.permissions    import IsAdmin,IsSeller,IsClient
from rest_framework.response import Response
from .models import ProductCoupon
from rest_framework import status



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

    def update(self, request, *args, **kwargs):
        print(request.body)
        return super().update(request, *args, **kwargs)
    def check_object_permissions(self, request, obj):
        return request.user == obj.user
    def get_queryset(self):
        user = self.request.user
        return Product.objects.filter(user=user)
    def delete(self, request, *args, **kwargs):
        instance = self.get_object()
        if instance.user != request.user:
            return Response(status=status.HTTP_401_UNAUTHORIZED)
        instance.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)

class ApplyCouponView(APIView):
    permission_classes = [IsAuthenticated, IsClient]
    
    def post(self, request):
        serializer = CouponSerializer(data=request.data)
        if serializer.is_valid():
            coupon_code = serializer.validated_data['coupon_code']
            
            # Check if the provided coupon code exists in the database
            coupon = ProductCoupon.objects.filter(code=coupon_code).first()
            if coupon:
                discount_percentage = coupon.discount
                return Response({'discount_percentage': discount_percentage}, status=status.HTTP_200_OK)
            else:
                return Response({'message': 'Invalid coupon code'}, status=status.HTTP_400_BAD_REQUEST)
        else:
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class CouponsSellerListCreateView(ListCreateAPIView):
    serializer_class = ProductCouponManagerSerializer
    permission_classes = [IsAuthenticated,IsSeller]

    def  get(self, request, *args, **kwargs):
        return super().get(request, *args, **kwargs)
    def get_queryset(self):
        user = self.request.user
        return ProductCoupon.objects.filter(user=user)
    
class CouponsSellerDeleteView(DestroyAPIView):
    serializer_class = ProductCouponManagerSerializer
    permission_classes = [IsAuthenticated,IsSeller]
    lookup_field = "id"
    def delete(self, request, *args, **kwargs):
        instance = self.get_object()
        if request.user != instance.user:
            return Response(status=status.HTTP_401_UNAUTHORIZED)
        instance.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)

    def get_queryset(self):
        user = self.request.user
        return ProductCoupon.objects.filter(user=user)

## views for the admin user 
class ProductCategoryListCreateManagerView(ListCreateAPIView):
    queryset = ProductCategory.objects.all()
    permission_classes = [AllowAny,IsAdmin]
    serializer_class = ProductCategoryManagerSerializer

class ProductCategoryUpdateDeleteView(RetrieveUpdateDestroyAPIView):
    queryset = ProductCategory.objects.all()
    permission_classes = [AllowAny,IsSeller]
    lookup_field = 'id'
    serializer_class = ProductCategoryManagerSerializer