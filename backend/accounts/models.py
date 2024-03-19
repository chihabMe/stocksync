from django.db import models
from django_password_validators.password_character_constraints.validators import (
    validate_password_contains_digit, validate_password_contains_lowercase,
    validate_password_contains_uppercase)
from django_password_validators.password_history.validators import \
    validate_password_no_repeated_passwords

# Create your models here.


class UserRegistrationSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)
    password2 = serializers.CharField(write_only=True)

    class Meta:
        model = User
        fields = ["email", "username", "password", "password2"]

    def validate_password(self, value):
        # Use django-password-validators validators
        validate_password_contains_digit(value)
        validate_password_contains_lowercase(value)
        validate_password_contains_uppercase(value)
        validate_password_no_repeated_passwords(value)

        return value

    def validate_password2(self, value):
        # Your existing password validation logic
        # ...

    def create(self, validated_data):
        # Your existing create method
        # ...
