from rest_framework import serializers
from .models import Product, ProductCategory, ProductImage,ProductCoupon
from django.utils import timezone

class ProductImageSerializer(serializers.ModelSerializer):
    class Meta:
        model = ProductImage
        fields = ['id', 'image']

class ProductCategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = ProductCategory
        fields = ['id', 'name', 'slug', 'parent']

class BasicProductSerializer(serializers.ModelSerializer):
    category = ProductCategorySerializer(read_only=True)
    
    class Meta:
        model = Product
        fields = ['id', 'name', 'slug', 'price', 'category',]

class DetailedProductSerializer(BasicProductSerializer):
    images = ProductImageSerializer(many=True, read_only=True)
    
    class Meta(BasicProductSerializer.Meta):
        fields = BasicProductSerializer.Meta.fields + ['images','description','stock']

class ProductCategorySerializer(serializers.ModelSerializer):

    class Meta:
        model = ProductCategory
        fields = ['id', 'name', "created_at", 'parent']


class ProductCouponManagerSerializer(serializers.ModelSerializer):
    expired = serializers.SerializerMethodField("get_is_active")
    class Meta:
        model = ProductCoupon
        fields = ["id","code","created_at",'expired','expiry_date']
    def get_expired(self,obj):
        now = timezone.now()
        return  obj.expiry_date > now


class ProductCategoryManagerSerializer(ProductCategorySerializer):
    def create(self, validated_data):
        category  = ProductCategory.objects.create(**validated_data)
        category.save()
        return category
    
    def update(self, instance, validated_data):
        instance.name = validated_data.get('name', instance.name)
        instance.parent = validated_data.get('parent', instance.parent)
        instance.save()
        return instance