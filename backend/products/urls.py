
from django.urls import path
from .views import (ProductsAddListView,
                     ProductCreateUpdateDestroyView,
                        ProductCategoryListCreateManagerView,
                        ProductCategoryUpdateDeleteView,
                        ProductCategoryListView,
                        LikeProductView
                     )

urlpatterns = [
    path('', ProductsAddListView.as_view(), name='product-list'),
    path('<str:slug>/', ProductCreateUpdateDestroyView.as_view(), name='product-detail'),
    path('<str:id>/like/', LikeProductView.as_view(), name='like-product-view'),
    path('categories/', ProductCategoryListView.as_view(), name='product-categories'),
    path('categories/manager/', ProductCategoryListCreateManagerView.as_view(), name='product-categories-manager'),
    path('categories/manager/<str:id>/', ProductCategoryUpdateDeleteView.as_view(), name='product-category-manager'),
]
