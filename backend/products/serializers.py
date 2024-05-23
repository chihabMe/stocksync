from rest_framework import serializers
import random
from .models import Product, ProductCategory, ProductImage, ProductCoupon
from django.utils import timezone
import random
import string
from datetime import timedelta



class ProductCategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = ProductCategory
        fields = ['id', 'name', 'slug', 'parent']
        ref_name = "ProductCategoryDefault"  # Add a unique ref_name here

class ProductImageSerializer(serializers.ModelSerializer):
    image = serializers.SerializerMethodField()

    class Meta:
        model = ProductImage
        fields = ['image']

    def get_image(self, obj):
        return obj.image.url

class ProductSerializer(serializers.ModelSerializer):
    is_liked = serializers.SerializerMethodField('get_is_liked')
    rating = serializers.SerializerMethodField('get_rating')
    images = serializers.SerializerMethodField('get_image_urls')
    category = ProductCategorySerializer(read_only=True)

    class Meta:
        model = Product
        fields = ['id', 'name', 'is_liked', 'rating', 'images', 'slug', 'price', 'category', 'description', 'stock']

    def get_is_liked(self, obj):
        user = self.context.get('request').user
        return user in obj.favored_by.all()

    def get_rating(self, obj):
        return random.choice([1, 2, 3, 4, 5])

    def get_image_urls(self, obj):
        request = self.context.get('request')
        absolute_base_url = request.build_absolute_uri('/')[:-1]  # Remove the trailing slash
        image_urls = [absolute_base_url + image.image.url for image in obj.images.all()]
        return image_urls


from rest_framework import serializers
from django.core.files.base import ContentFile
from .models import Product, ProductCategory, ProductImage
import random

class SellerProductSerializer(serializers.ModelSerializer):
    rating = serializers.SerializerMethodField('get_rating', read_only=True)
    images = serializers.ListField(
        child=serializers.ImageField(max_length=None, use_url=True),
        write_only=True,
        required=False
    )
    image_urls = serializers.SerializerMethodField('get_image_urls', read_only=True)
    category = serializers.CharField(write_only=True)

    class Meta:
        model = Product
        fields = ['id', 'name', 'category', 'images', 'image_urls', 'rating', 'price', 'description', 'stock']

    def validate_category(self, value):
        try:
            ProductCategory.objects.get(name=value)
        except ProductCategory.DoesNotExist:
            raise serializers.ValidationError("Invalid category name")
        return value

    def get_rating(self, obj):
        return random.choice([1, 2, 3, 4, 5])

    def get_image_urls(self, obj):
        request = self.context.get('request')
        absolute_base_url = request.build_absolute_uri('/')[:-1]  # Remove the trailing slash
        image_urls = [absolute_base_url + image.image.url for image in obj.images.all()]
        return image_urls

    def create(self, validated_data):
        user = self.context.get('request').user
        category_name = validated_data.pop('category')
        category = ProductCategory.objects.get(name=category_name)
        images_data = validated_data.pop('images')

        product = Product.objects.create(user=user, category=category, **validated_data)
        
        for image_data in images_data:
            product_image = ProductImage(product=product, image=image_data)
            product_image.save()
        
        return product

    def update(self, instance, validated_data):
        instance.name = validated_data.get('name', instance.name)
        instance.description = validated_data.get('description', instance.description)
        instance.price = validated_data.get('price', instance.price)
        instance.stock = validated_data.get('stock', instance.stock)
        category_name = validated_data.get('category', instance.category.name)
        instance.category = ProductCategory.objects.get(name=category_name)
        
        images_data = validated_data.pop('images', None)
        if images_data is not None:
            instance.images.all().delete()  # Clear existing images
            for image_data in images_data:
                product_image = ProductImage(product=instance, image=image_data)
                product_image.save()
        
        instance.save()
        return instance

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
    expired = serializers.SerializerMethodField("get_expired",read_only=True)
    code = serializers.CharField(read_only=True)
    expiry_date = serializers.DateTimeField(read_only=True)
    product_id = serializers.CharField(write_only=True)


    class Meta:
        model = ProductCoupon
        fields = ["id", "code","product_id","discount", "created_at", 'expired', 'expiry_date']
        ref_name = "ProductCouponManager"  # Add a unique ref_name here

    def get_expired(self, obj):
        now = timezone.now()
        return obj.expiry_date > now

    def create(self, validated_data):
        # Generate a random code for the coupon
        user = self.context["request"].user
        code = ''.join(random.choices(string.ascii_uppercase + string.digits, k=8))
        validated_data['code'] = code
        
        # Set expiry date 30 days from the created day
        created_at = validated_data.get('created_at', timezone.now())
        expiry_date = created_at + timedelta(days=30)
        validated_data['expiry_date'] = expiry_date
        
        product_coupon = ProductCoupon.objects.create(user=user,**validated_data)
        
        return product_coupon
