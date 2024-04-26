

from rest_framework import serializers
from accounts.serializers import UserSerializer




class ClientSerialize(serializers.ModelSerializer):
    user = UserSerializer(read_only=True)
    class Meta:
        fields  = ["user","id"]