# Generated by Django 5.0.2 on 2024-04-26 13:32

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('accounts', '0002_sellerprofile_created_at_sellerprofile_is_active_and_more'),
    ]

    operations = [
        migrations.DeleteModel(
            name='SellerProfile',
        ),
    ]
