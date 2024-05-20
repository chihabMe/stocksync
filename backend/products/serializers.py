from rest_framework import serializers
import random
from .models import Product, ProductCategory, ProductImage, ProductCoupon
from django.utils import timezone

class ProductImageSerializer(serializers.ModelSerializer):
    class Meta:
        model = ProductImage
        fields = ["id", 'image']

class ProductCategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = ProductCategory
        fields = ['id', 'name', 'slug', 'parent']
        ref_name = "ProductCategoryDefault"  # Add a unique ref_name here

class ProductSerializer(serializers.ModelSerializer):
    is_liked = serializers.SerializerMethodField('get_is_liked')
    rating = serializers.SerializerMethodField('get_rating')
    images = ProductImageSerializer(read_only=True, many=True)
    category = ProductCategorySerializer(read_only=True)

    class Meta:
        model = Product
        fields = ['id', 'name', 'is_liked', 'rating', 'images', 'slug', 'price', 'category', 'description', 'stock']

    def get_is_liked(self, obj):
        user = self.context.get('request').user
        return user in obj.favored_by.all()

    def get_rating(self, obj):
        return random.choice([1, 2, 3, 4, 5])

class ProductCategoryManagerSerializer(serializers.ModelSerializer):  # Inheriting directly from serializers.ModelSerializer

    class Meta:
        model = ProductCategory
        fields = ['id', 'name', "created_at", 'parent']
        ref_name = "ProductCategoryManager"  # Add a unique ref_name here

    def create(self, validated_data):
        category = ProductCategory.objects.create(**validated_data)
        category.save()
        return category

    def update(self, instance, validated_data):
        instance.name = validated_data.get('name', instance.name)
        instance.parent = validated_data.get('parent', instance.parent)
        instance.save()
        return instance

class ProductCouponManagerSerializer(serializers.ModelSerializer):
    expired = serializers.SerializerMethodField("get_expired")

    class Meta:
        model = ProductCoupon
        fields = ["id", "code", "created_at", 'expired', 'expiry_date']
        ref_name = "ProductCouponManager"  # Add a unique ref_name here

    def get_expired(self, obj):
        now = timezone.now()
        return obj.expiry_date > now
