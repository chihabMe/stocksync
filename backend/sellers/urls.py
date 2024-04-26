from django.urls import path 
from .views import SellersListView,SellerDetailserializer
app_name = "sellers"
urlpatterns = [
    path("/", SellersListView.as_view(), name="sellers"),
    path("sellers/<str:id>/", SellerDetailserializer.as_view(), name="seller"),
]
