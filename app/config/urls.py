from django.contrib import admin
from django.http import JsonResponse
from django.urls import path


def home(request):
    return JsonResponse({
        "message": "Django + PostgreSQL + Nginx is running successfully"
    })

urlpatterns = [
    path('', home),
    path('admin/', admin.site.urls),
]
