from django.conf import settings
from django.contrib import admin
from django.urls import include, path
from django.conf.urls.static import static

urlpatterns = [
    path("admin/", admin.site.urls),
]
api_v1 = [
    path("api/v1/auth/", include("authentication.urls")),
    path("api/v1/accounts/", include("accounts.urls")),
    path("api/v1/products/", include("products.urls")),
    path("api/v1/sellers/", include("sellers.urls")),
    path("api/v1/clients/", include("clients.urls")),
    path("api/v1/complains/", include("complains.urls")),
]

urlpatterns += api_v1


if settings.DEBUG:
    urlpatterns += [
        path("api-auth/", include("rest_framework.urls", namespace="rest_framework"))
    ]
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
