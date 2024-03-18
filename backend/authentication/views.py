from django.shortcuts import render
from rest_framework.response import Response
from rest_framework.views import APIView, status
from rest_framework_simplejwt.tokens import RefreshToken


class TokenLogoutView(APIView):
    def post(self, request):
        try:
            refresh_token = request.data["refresh"]
            token = RefreshToken(refresh_token)
            token.blacklist()
        except Exception as e:
            pass
        data = {"message": "Successfully logged out"}
        return Response(status=status.HTTP_200_OK, data=data)
