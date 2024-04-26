
from django.urls import path
from .views import ClientsListView

app_name = "clients"

urlpatterns = [
    path("",ClientsListView.as_view(),name="clients"),
]
