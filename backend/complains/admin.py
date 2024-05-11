from django.contrib import admin
from .models import Complain

class ComplainAdmin(admin.ModelAdmin):
    list_display = ('client', 'product', 'status')
    list_filter = ('status',)
    search_fields = ('client__name', 'product__name')  # Assuming 'name' is the field representing client's and product's name

admin.site.register(Complain, ComplainAdmin)
