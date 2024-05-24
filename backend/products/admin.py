from django.contrib import admin
from .models import Product, ProductCategory, ProductImage,ProductCoupon

class ProductCouponAdmin(admin.ModelAdmin):
    list_display = ["code","discount","user"]

class ProductImageInline(admin.TabularInline):
    model = ProductImage  # Use the ProductImage model
    extra = 4  # Number of extra forms to display for new images
    fields = ['image', 'caption', 'is_featured']  # Fields to display in the inline form


class ProductAdmin(admin.ModelAdmin):
    list_display = ['id','name', 'price', 'stock']  # Display fields in the list view
    prepopulated_fields = {'slug': ('name',)}  # Auto-generate slug from the name
    search_fields = ['name', 'price', 'slug']  # Optional: for easier search in the admin
    inlines = [ProductImageInline]

class ProductCategoryAdmin(admin.ModelAdmin):
    list_display = ['name']
    prepopulated_fields = {"slug": ('name',)}

admin.site.register(Product, ProductAdmin)
admin.site.register(ProductCategory, ProductCategoryAdmin)
admin.site.register(ProductImage)
admin.site.register(ProductCoupon,ProductCouponAdmin)