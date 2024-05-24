
from django.urls import path
from .views import (ProductsAddListView,
                     ProductCreateUpdateDestroyView,
                        ProductCategoryListCreateManagerView,
                        ProductCategoryUpdateDeleteView,
                        ProductCategoryListView,
                        LikeProductView,
                        LikedProductsListView,
                        ProductClientDetailsView,
                        ProductSellerListCreateView,
                        ProductSellerDestroyUpdateView,
                        CouponsSellerListCreateView,
                        CouponsSellerDeleteView,
                        ApplyCouponView
                     )

urlpatterns = [
    path('', ProductsAddListView.as_view(), name='product-list'),
    path('coupon/validate/', ApplyCouponView.as_view(), name='apply-coupon'),
    path('coupons/', CouponsSellerListCreateView.as_view(), name='seller-coupons'),
    path('coupons/<str:id>/', CouponsSellerDeleteView.as_view(), name='seller-coupon-delete'),
    path('seller/', ProductSellerListCreateView.as_view(), name='seller-product-list'),
    path('categories/', ProductCategoryListView.as_view(), name='product-categories'),
    path('categories/manager/', ProductCategoryListCreateManagerView.as_view(), name='product-categories-manager'),
    path('categories/manager/<str:id>/', ProductCategoryUpdateDeleteView.as_view(), name='product-category-manager'),
    path('liked/', LikedProductsListView.as_view(), name='liked-products-view'),
    path('<str:id>/seller/', ProductSellerDestroyUpdateView.as_view(), name='seller-product'),
    path('<str:id>/like/', LikeProductView.as_view(), name='like-product-view'),
    path('<str:id>/', ProductClientDetailsView.as_view(), name='product-details'),
    path('<str:id>/seller/', ProductCreateUpdateDestroyView.as_view(), name='product-seller-details'),
]
