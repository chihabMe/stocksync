from django.urls import path 
from . import views
app_name = "orders"
urlpatterns = [
    path("",views.OrdersClientListCreateView.as_view(),name="client-orders"),
]