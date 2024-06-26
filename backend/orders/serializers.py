from rest_framework import serializers
from .models import OrderItem, Order
from products.models import Product
from products.serializers import ProductSerializer
from accounts.serializers import UserSerializer

class OrderItemSerializer(serializers.ModelSerializer):
    product_id = serializers.UUIDField(write_only=True)
    product = ProductSerializer(read_only=True)

    class Meta:
        model = OrderItem
        fields = ["quantity", "product", "product_id"]

class OrderSerializer(serializers.ModelSerializer):
    items = OrderItemSerializer(many=True)
    user = UserSerializer(read_only=True)
    total = serializers.SerializerMethodField(method_name="get_total",read_only=True)
    date = serializers.DateTimeField(source="created_at",read_only=True)

    class Meta:
        model = Order
        fields = ["id","user",'date','total',"first_name","zip_code","last_name","address","phone","city","status","state", "items"]

    def get_total(self, obj):
        total = sum(item.product.price * item.quantity for item in obj.items.all())
        return total

    def validate(self, attrs):
        items_data = attrs.get('items', [])
        for item_data in items_data:
            product_id = item_data.get('product_id')
            if product_id:
                try:
                    Product.objects.get(pk=product_id)
                except Product.DoesNotExist:
                    raise serializers.ValidationError(f"Product with id {product_id} does not exist.")
            else:
                raise serializers.ValidationError("Product id is required for each order item.")
        return attrs

    def create(self, validated_data):
        user = self.context["request"].user
        items_data = validated_data.pop('items')
        order = Order.objects.create(user=user, **validated_data)
        for item_data in items_data:
            product_id = item_data.pop('product_id')
            product = Product.objects.get(pk=product_id)
            OrderItem.objects.create(order=order, product=product, **item_data)
        return order

class OrderSellerManagerSerializer(serializers.ModelSerializer):
    items = OrderItemSerializer(many=True,read_only=True)
    user = UserSerializer(read_only=True)
    total = serializers.SerializerMethodField(method_name="get_total",read_only=True)
    date = serializers.DateTimeField(source="created_at",read_only=True)
    class Meta:
        model = Order 
        fields = ["id","user",'date','total',"first_name","zip_code","last_name","address","phone","city","status","state", "items"]
    def get_total(self, obj):
        total = sum(item.product.price * item.quantity for item in obj.items.all())
        return total
    
    def validate_status(self,value):
        if value not in [Order.OrderStatusChoices.ACCEPTED,Order.OrderStatusChoices.CANCELED,Order.OrderStatusChoices.RECEIVED,Order.OrderStatusChoices.PENDING]:
            raise serializers.ValidationError("invalid status")
        return value
    def update(self,instance):
        instance.status = instance.status
        instance.save()
        return instance