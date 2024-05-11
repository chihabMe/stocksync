
from rest_framework import serializers
from .models import Complain
from products.serializers import DetailedProductSerializer


class ComplainSerializer(serializers.ModelSerializer):
    product = DetailedProductSerializer(read_only=True)
    class Meta:
        model = Complain
        fields = ('id', 'product', 'client', 'description', 'status')

    def create(self, validated_data):
        return Complain.objects.create(**validated_data)

    def update(self, instance, validated_data):
        instance.description = validated_data.get('description', instance.description)
        instance.save()
        return instance

class ComplainManagerSerializer(ComplainSerializer):

    def update(self, instance, validated_data):
        instance.status = validated_data.get('status', instance.status)
        instance.save()
        return instance