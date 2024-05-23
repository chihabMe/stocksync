from django.urls import path 
from . import views
app_name = "orders"
urlpatterns = [
    path("",views.OrdersClientListCreateView.as_view(),name="client-orders"),
    path("<str:id>/cancel/",views.OrderClientCancelView.as_view(),name="client-cancel-order"),
    path("seller/",views.OrderSellerListView.as_view(),name="seller-orders"),
    path("<str:id>/seller/",views.OrderSellerUpdateStatus.as_view(),name="seller-update-status"),
]
