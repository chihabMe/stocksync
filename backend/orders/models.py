from django.db import models
from common.base_model import BaseModel
from products.models import Product
from django.contrib.auth import get_user_model

# Create your models here.
User = get_user_model()


class Order(BaseModel):
    class OrderStateChoices(models.TextChoices):
        PENDING = "pending"
        ACCEPTED = "accepted"
        RECEIVED = "received"
    user = models.ForeignKey(User,related_name="orders",on_delete=models.CASCADE)
    state = models.CharField(max_length=10,default=OrderStateChoices.PENDING,choices=OrderStateChoices.choices)

    def __str__(self):
        return "order:"+str(self.user)
    







class OrderItem(BaseModel):
    product = models.ForeignKey(Product,related_name="orders",on_delete=models.CASCADE)
    quantity = models.PositiveIntegerField(default=1)
    order = models.ForeignKey(Order,related_name="items",on_delete=models.CASCADE)