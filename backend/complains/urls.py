from django.urls import path
from . import views

app_name = "complains"

urlpatterns = [
    path("manager/",views.ManageComplainsView.as_view(),name="complains-manager"),
    path("manager/<str:id>/",views.ManageComplainView.as_view(),name="complain-manager"),
]
