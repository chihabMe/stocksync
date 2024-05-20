from django.db import models
import os
from common.base_model import BaseModel
from django.utils.text import slugify
from sellers.models import SellerProfile
from django.core.validators import MaxValueValidator,MinValueValidator
from io import BytesIO
from PIL import Image
from django.core.files.base import ContentFile
from django.contrib.auth import get_user_model

User = get_user_model()
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
    favored_by = models.ManyToManyField(User,related_name='favorites',blank=True)

    def featured_image(self):
        featured = self.images.fitler(is_featured=True).first()
        if featured:
            return featured
        return self.image.first()
    def save(self, *args, **kwargs):
        if not self.slug:
            self.slug = slugify(self.name)
            while Product.objects.filter(slug=self.slug).exists():
                self.slug = '{}-{}'.format(slugify(self.name), Product.objects.filter(name=self.name).count())
        super().save(*args, **kwargs)

    def __str__(self) -> str:
        return self.name
class ProductCoupon(BaseModel):
    code = models.CharField(max_length=49, unique=True)
    discount = models.PositiveIntegerField(validators=[MinValueValidator(1),MaxValueValidator(100)])
    seller = models.ForeignKey(SellerProfile,related_name="generated_coupons",on_delete=models.CASCADE)
    product = models.ForeignKey(Product,related_name="coupons",on_delete=models.CASCADE)
    expiry_date = models.DateTimeField()

def product_image_uploader(instance, filename):
    return os.path.join("products", str(instance.product.id), filename)
class ProductImage(BaseModel):
    product = models.ForeignKey(Product, on_delete=models.CASCADE, related_name='images')
    image = models.ImageField(upload_to=product_image_uploader,max_length=500)  
    caption = models.CharField(max_length=255, blank=True, null=True)
    is_featured = models.BooleanField(default=False)
    def save(self,*args,**kwargs):
        super().save(*args,**kwargs)
        imag = Image.open(self.image.path)
        if imag.width > 650 or imag.height> 450:
            output_size = (650, 450)
            imag.thumbnail(output_size)
            imag.save(self.image.path)
    def __str__(self):
        return f"{self.product.name} - {self.caption if self.caption else 'Image'}"