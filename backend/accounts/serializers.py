from django.contrib.auth import get_user_model
from django.contrib.auth.password_validation import validate_password
from django.core.exceptions import ValidationError
from rest_framework import serializers

User = get_user_model()


class UserRegistrationSerializer(serializers.ModelSerializer):
    password2 = serializers.CharField(write_only=True)
    password = serializers.CharField(write_only=True)
    user_type = serializers.ChoiceField(choices=User.UserTypesChoices.choices, read_only=True)

    class Meta:
        model = User
        fields = ["email", "username", "password", "password2", "user_type"]

    def validate_password(self, value):
        try:
            validate_password(value)
        except ValidationError as e:
            raise serializers.ValidationError(e.messages)
        return value

    def validate_password2(self, value):
        password1 = self.initial_data.get("password")
        password2 = value

        if password1 != password2:
            raise serializers.ValidationError("Passwords do not match.")
        return value

    def create(self, validated_data):
        validated_data.pop("password2")
        user_type = self.initial_data.get("user_type", User.UserTypesChoices.CLIENT)  # Default to 'client' if not provided
        validated_data['user_type'] = user_type

        is_active = True if user_type == User.UserTypesChoices.CLIENT else False
        validated_data['is_active'] = is_active

        user = User.objects.create_user(**validated_data)
        return user

class UserSerializer(serializers.ModelSerializer):
    email = serializers.EmailField(read_only=True)
    class Meta:
        model = User
        fields = ["id","email","is_active","image", "username","user_type","created_at"]



