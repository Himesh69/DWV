"""
URL configuration for warranty_vault project.
"""
from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static
from django.http import JsonResponse

def api_root(request):
    """Root endpoint - serves as health check for Railway"""
    return JsonResponse({
        'status': 'healthy',
        'message': 'Digital Warranty Vault API',
        'version': '1.0',
        'endpoints': {
            'health': '/api/health/',
            'admin': '/admin/',
            'auth': {
                'register': '/api/auth/register/',
                'login': '/api/auth/login/',
                'profile': '/api/auth/profile/',
            },
            'warranties': {
                'list': '/api/warranties/',
                'share': '/api/share/<uuid:share_token>/',
            },
            'notifications': '/api/notifications/',
        }
    })

def health_check(request):
    """Health check endpoint for Railway deployment monitoring"""
    return JsonResponse({
        'status': 'healthy',
        'service': 'Digital Warranty Vault API',
        'version': '1.0'
    })



urlpatterns = [
    path('', api_root, name='api-root'),
    path('api/health/', health_check, name='health-check'),
    path('admin/', admin.site.urls),
    path('api/auth/', include('users.urls')),
    path('api/', include('warranties.urls')),
    path('api/notifications/', include('notifications.urls')),
]

# Serve media files in development
if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
