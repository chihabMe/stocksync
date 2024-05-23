from django.shortcuts import render
from rest_framework.permissions import AllowAny
from rest_framework.response import Response
from rest_framework.views import APIView, status
from rest_framework.generics import GenericAPIView , DestroyAPIView
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework.permissions import IsAuthenticated
from .serializers import AuthenticatedUserSerializer


class TokenLogoutView(APIView):
    permission_classes = [AllowAny]

    def post(self, request):
        try:
            refresh_token = request.data["refresh"]
            token = RefreshToken(refresh_token)
            token.blacklist()
        except Exception as e:
            pass
        data = {"message": "Successfully logged out"}
        return Response(status=status.HTTP_200_OK, data=data)



class AuthenticatedUserView(GenericAPIView):
    permission_classes = [IsAuthenticated]
    
    def get(self, request):
        user = request.user
        serializer = AuthenticatedUserSerializer(user, context={'request': request})
        return Response(serializer.data)
    def delete(self, request):
        user = request.user
        password = request.data.get('password')
        if not user.check_password(password):
            return Response({'error': 'Password is incorrect'}, status=status.HTTP_400_BAD_REQUEST)

        user.delete()
        return Response({'success': 'User deleted successfully'}, status=status.HTTP_204_NO_CONTENT)
