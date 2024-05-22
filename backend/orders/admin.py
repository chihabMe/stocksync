from django.contrib import admin
from .models import Order,OrderItem

# Register your models here.

class AdminOrder(admin.ModelAdmin):
    list_display = ["status","first_name","last_name","phone","city","state","user"]

class AdminOrderItem(admin.ModelAdmin):
    list_display = ["quantity","product"]


admin.site.register(Order,AdminOrder)
admin.site.register(OrderItem,AdminOrderItem)
    
