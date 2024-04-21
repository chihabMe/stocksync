from django.db import models
import os
from common.base_model import BaseModel
from django.utils.text import slugify

# Create your models here.
class ProductCategory(BaseModel):
    name = models.CharField(max_length=100,unique=True)
    slug = models.SlugField(max_length=120, unique=True,blank=True)
    parent = models.ForeignKey("self",null=True,blank=True,on_delete=models.CASCADE,related_name='children')
    def save(self, *args, **kwargs):
        if not self.slug:
            self.slug = slugify(self.name)
        super().save(*args, **kwargs)
    def __str__(self) -> str:
        return self.name
    
class Product(BaseModel):
    name = models.CharField(max_length=300)
    slug = models.CharField(max_length=350,blank=True,unique=True)
    description = models.TextField()
    price = models.DecimalField(max_digits=10,decimal_places=2)
    category = models.ForeignKey(ProductCategory,related_name='products',on_delete=models.CASCADE)
    stock = models.PositiveIntegerField(default=1)

    def featured_image(self):
        featured = self.images.fitler(is_feautred=True).first()
        if featured:
            return featured
        return self.image.first()

    def save(self,*args,**kwargs):
        if not self.slug:
            self.slug = slugify(self.name)
        super().save(*args,**kwargs)

    def __str__(self) -> str:
        return self.name
def prodcut_image_uploader(instance, filename):
    return os.path.join("products", str(instance.product.id), filename)
class ProductImage(BaseModel):
    product = models.ForeignKey(Product, on_delete=models.CASCADE, related_name='images')
    image = models.ImageField(upload_to=prodcut_image_uploader)  
    caption = models.CharField(max_length=255, blank=True, null=True)
    is_feautred = models.BooleanField(default=False)
    def __str__(self):
        return f"{self.product.name} - {self.caption if self.caption else 'Image'}"