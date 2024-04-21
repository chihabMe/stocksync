
from django.urls import path
from .views import ProductsAddListView, DetailedProductView

urlpatterns = [
    path('', ProductsAddListView.as_view(), name='product-list'),
    path('<str:slug>/', DetailedProductView.as_view(), name='product-detail'),
]
