from django.contrib.auth import get_user_model
from rest_framework import serializers
User = get_user_model()



class AuthenticatedUserSerializer(serializers.ModelSerializer):
    image = serializers.SerializerMethodField('get_image')
    
    class Meta:
        model = User
        fields = ['id', 'username','image', 'email', "user_type"]
    def get_image(self,obj):
        request = self.context.get('request')
        if obj.image and request :
            return request.build_absolute_uri(obj.image.url)

        return None