from rest_framework.permissions import BasePermission
from accounts.models import CustomUser as User


class IsAdmin(BasePermission):
    def has_permissions(self,request,view):
        return request.user.is_admin or request.user.user_type== User.UserTypesChoices.ADMIN


class IsSeller(BasePermission):
    def has_permission(self, request, view):
        return request.user.user_type == User.UserTypesChoices.SELLER

class IsClient(BasePermission):
    def has_permission(self, request, view):
        return request.user.user_type == User.UserTypesChoices.CLIENT

class IsSellerOrAdmin(BasePermission):
    def has_permission(self, request, view):
        return request.user.user_type == User.UserTypesChoices.SELLER or request.user.user_type == User.UserTypesChoices.ADMIN

class IsUser(BasePermission):
    def has_permission(self, request, view):
        return request.user.user_type == User.UserTypesChoices.CLIENT