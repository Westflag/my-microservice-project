from django.http import JsonResponse
from django.urls import path


def health(_request):
    return JsonResponse({"status": "ok", "service": "django-app"})


urlpatterns = [
    path('', health),
    path('health/', health),
]
