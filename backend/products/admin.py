from django.contrib import admin
from .models import Product, ProductCategory, ProductImage

class ProductAdmin(admin.ModelAdmin):
    list_display = ['name', 'price', 'stock']  # Display fields in the list view
    prepopulated_fields = {'slug': ('name',)}  # Auto-generate slug from the name
    search_fields = ['name', 'price', 'slug']  # Optional: for easier search in the admin

class ProductCategoryAdmin(admin.ModelAdmin):
    list_display = ['name']
    prepopulated_fields = {"slug": ('name',)}

admin.site.register(Product, ProductAdmin)
admin.site.register(ProductCategory, ProductCategoryAdmin)
admin.site.register(ProductImage)