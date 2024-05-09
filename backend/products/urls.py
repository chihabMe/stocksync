
from django.urls import path
from .views import (ProductsAddListView,
                     DetailedProductView,
                        ProductCategoryListCreateManagerView,
                        ProductCategoryUpdateDeleteView,
                     )

urlpatterns = [
    path('', ProductsAddListView.as_view(), name='product-list'),
    path('<str:slug>/', DetailedProductView.as_view(), name='product-detail'),
    path('categories/manager/', ProductCategoryListCreateManagerView.as_view(), name='product-categories'),
    path('categories/manager/<str:id>/', ProductCategoryUpdateDeleteView.as_view(), name='product-category'),
]
