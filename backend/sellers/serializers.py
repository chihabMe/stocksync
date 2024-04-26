from accounts.serializers import UserSerializer
from rest_framework import serializers
from .models import SellerProfile

class SellerProfileSerializer(serializers.ModelSerializer):
    user = UserSerializer(read_only=True)
    is_active = serializers.BooleanField(read_only=True)

    class Meta:
        model = SellerProfile
        fields = [
            "id",
            "user",
            "is_active",
            "created_at"
        ]



class SellerProfileSerializerForAdmin(SellerProfileSerializer):
    def update(self,instance:SellerProfile,validated_data):
        instance.is_active = validated_data.get("is_active",instance.is_active)
        instance.save()
        return instance