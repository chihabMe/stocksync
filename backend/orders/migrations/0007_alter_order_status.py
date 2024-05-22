# Generated by Django 5.0.2 on 2024-05-22 15:08

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('orders', '0006_alter_order_address_alter_order_city_and_more'),
    ]

    operations = [
        migrations.AlterField(
            model_name='order',
            name='status',
            field=models.CharField(choices=[('pending', 'Pending'), ('accepted', 'Accepted'), ('received', 'Received'), ('canceled', 'Canceled')], default='pending', max_length=10),
        ),
    ]
