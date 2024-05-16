from django.db import models
from common.base_model import BaseModel
from products.models import Product
from clients.models import ClientProfile

# Create your models here.

class Complain(BaseModel):
    class ComplainStatusChoices(models.TextChoices):
        PENDING = "pending","pending"
        RESOLVED = "resolved","resolved"
        CLOSED = "closed","closed"
    product = models.ForeignKey(Product,related_name="complains",on_delete=models.CASCADE)
    client = models.ForeignKey(ClientProfile,related_name="complains",on_delete=models.CASCADE)
    description = models.TextField()
    status = models.CharField(max_length=10,default=ComplainStatusChoices.PENDING,choices=ComplainStatusChoices.choices)

    def __str__(self):
        return  str(self.client)+":"+str(self.product)

