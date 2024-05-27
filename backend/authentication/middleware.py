# from django.utils.deprecation import MiddlewareMixin
from rest_framework.request import Request
from rest_framework_simplejwt.authentication import JWTAuthentication

# class AuthorizationCookieMiddleware(MiddlewareMixin):
#     def process_request(self,request):

#         auth_cookie = request.COOKIES.get("Authorization")
#         if auth_cookie:
#             auth_cookie = auth_cookie.split(" ")[1]
#             try:
#                 payload = jwt.decode(auth_cookie,settings.SECRET_KEY,algorithms=["HS256"])
#                 user_id = payload.get("user_id")
#                 user = User.objects.get(id=user_id)
#                 print("pass")
#                 request.user = user
#             except jwt.ExpiredSignatureError:
#                 return JsonResponse({"error":"Token has expired"},status=401)
#             except jwt.InvalidTokenError:
#                 return JsonResponse({"error":"Invalid token"},status=401)
#             except User.DoesNotExist:
#                 return JsonResponse({"error":"User not found"},status=401)
#         else:
#             request.user=None
#     def process_response(self,request,response):
#         return response

class CookiesAuthentication(JWTAuthentication):
    """
    an authentication plugin that authenticates requests  through cookies 

    """
    def get_header(self, request: Request) -> bytes:
        print("-------------")
        header =  request.COOKIES.get("Authorization")
        print(header)
        print("-------------")
        # print(request.COOKIES)
        return header
    def get_raw_token(self, header: bytes) -> bytes | None:
        return header.split(" ")[1]