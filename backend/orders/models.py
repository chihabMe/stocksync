from django.db import models
from common.base_model import BaseModel
from products.models import Product
from django.contrib.auth import get_user_model

# Create your models here.
User = get_user_model()


class Order(BaseModel):
    class OrderStatusChoices(models.TextChoices):
        PENDING = "pending"
        ACCEPTED = "accepted"
        RECEIVED = "received"
    user = models.ForeignKey(User,related_name="orders",on_delete=models.CASCADE)
    status = models.CharField(max_length=10,default=OrderStatusChoices.PENDING,choices=OrderStatusChoices.choices)

    first_name = models.CharField(default="",max_length=250)
    last_name = models.CharField(default="",max_length=250)
    phone = models.CharField(default="",max_length=350)
    address =  models.CharField(default="",max_length=350)
    state = models.CharField(default="",max_length=250)
    city = models.CharField(default="",max_length=250)
    zip_code = models.CharField(default="",max_length=20)

    def __str__(self):
        return "order:"+str(self.user)
    

class OrderItem(BaseModel):
    product = models.ForeignKey(Product,related_name="orders",on_delete=models.CASCADE)
    quantity = models.PositiveIntegerField(default=1)
    order = models.ForeignKey(Order,related_name="items",on_delete=models.CASCADE)