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

    class Meta:
        model = Order
        fields = ["user","first_name","last_name","address","phone","city","status","state", "items"]

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
