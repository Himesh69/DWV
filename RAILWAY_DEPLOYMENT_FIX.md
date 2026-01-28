# Railway Deployment Fix - PORT Variable Issue

## Problem
Railway deployment was failing with error:
```
Error: '$PORT' is not a valid port number.
```

## Root Cause
The Dockerfile was using exec form `CMD ["gunicorn", ...]` with a hardcoded port `8000`, while Railway expects applications to use the `PORT` environment variable it provides dynamically.

## Solution Applied ✅

### 1. Updated Dockerfile
Changed from exec form to shell form to allow environment variable expansion:

**Before:**
```dockerfile
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers", "3", "--timeout", "120", "warranty_vault.wsgi:application"]
```

**After:**
```dockerfile
CMD gunicorn --bind 0.0.0.0:${PORT:-8000} --workers 3 --timeout 120 warranty_vault.wsgi:application
```

**Why this works:**
- Shell form allows `${PORT:-8000}` to be expanded at runtime
- `${PORT:-8000}` means: use `$PORT` if set, otherwise default to `8000`
- Railway will automatically set `PORT` environment variable

### 2. Updated railway.toml
Removed the redundant `startCommand` since Dockerfile CMD now handles everything:

**Before:**
```toml
[deploy]
startCommand = "gunicorn --bind 0.0.0.0:$PORT --workers 3 --timeout 120 warranty_vault.wsgi:application"
healthcheckPath = "/api/health/"
restartPolicyType = "ON_FAILURE"
```

**After:**
```toml
[deploy]
healthcheckPath = "/api/health/"
restartPolicyType = "ON_FAILURE"
```

## Changes Pushed to GitHub ✅

Commit: "Fix Railway PORT variable issue in Dockerfile"
- Updated: `Dockerfile`
- Updated: `railway.toml`

## Next Steps

1. **Railway will auto-redeploy** since changes are pushed to GitHub
2. **Monitor the deployment** in Railway dashboard
3. **Check deploy logs** to confirm the fix worked

## Expected Behavior

Railway will now:
1. Build the Docker image
2. Set the `PORT` environment variable (usually to a random port like 3000, 5000, etc.)
3. Start gunicorn with the correct port binding
4. Application should start successfully

## If Deployment Still Fails

Check these common issues:

### 1. Database Connection
Ensure PostgreSQL service is added and `DATABASE_URL` is set automatically by Railway.

### 2. Missing Environment Variables
Required variables:
- `SECRET_KEY` - Your Django secret key
- `DEBUG` - Set to `False`
- `ALLOWED_HOSTS` - Set to `.railway.app`

### 3. Static Files
If you see 404 errors for static files, run:
```bash
python manage.py collectstatic --noinput
```
(This is already in the Dockerfile, but check if it succeeded)

### 4. Database Migrations
Ensure migrations run successfully. Check the Procfile release command:
```
release: python manage.py migrate --noinput
```

### 5. Health Check Endpoint
Create a simple health check view if `/api/health/` doesn't exist:

```python
# In warranty_vault/urls.py
from django.http import JsonResponse

def health_check(request):
    return JsonResponse({"status": "healthy"})

urlpatterns = [
    path('api/health/', health_check),
    # ... other patterns
]
```

## Verification

Once deployed successfully, you should be able to:
1. Access your Railway URL (e.g., `https://web-production-xxxxx.up.railway.app`)
2. See the API endpoints working
3. Test OCR functionality by uploading a receipt

## Support

If you encounter other errors:
1. Check Railway deploy logs
2. Look for Python/Django errors
3. Verify all environment variables are set correctly
4. Ensure PostgreSQL database is connected
