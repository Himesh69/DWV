# Railway Deployment - PORT Variable Solution

## Problem
Railway deployment continues to fail with:
```
Error: '$PORT' is not a valid port number.
```

## Root Cause Analysis

The issue occurs because:
1. Railway sets the `PORT` environment variable
2. The variable needs to be expanded/interpolated before gunicorn starts
3. Docker CMD with shell form may not be expanding the variable correctly in Railway's environment

## Solution Implemented

### Approach: Startup Script

Created `backend/start.sh` to explicitly handle PORT variable expansion:

```bash
#!/bin/bash
# Startup script for Railway deployment

# Check if PORT is set, if not use default
if [ -z "$PORT" ]; then
    echo "WARNING: PORT environment variable not set, using default 8000"
    export PORT=8000
fi

echo "Starting gunicorn on port $PORT..."

# Start gunicorn with the PORT variable
exec gunicorn --bind 0.0.0.0:$PORT --workers 3 --timeout 120 warranty_vault.wsgi:application
```

### Updated Dockerfile

```dockerfile
# Copy and set permissions for startup script
COPY backend/start.sh /app/start.sh
RUN chmod +x /app/start.sh

# Use startup script to handle PORT variable
CMD ["/app/start.sh"]
```

## Why This Works

1. **Explicit Bash Execution**: The script runs in bash, ensuring proper variable expansion
2. **Error Handling**: Checks if PORT is set, provides fallback
3. **Logging**: Prints the port being used for debugging
4. **exec Command**: Replaces the shell process with gunicorn (proper signal handling)

## Alternative Solutions (If This Doesn't Work)

### Option 1: Use ENTRYPOINT Instead of CMD

Update Dockerfile:
```dockerfile
ENTRYPOINT ["/bin/bash", "-c"]
CMD ["gunicorn --bind 0.0.0.0:$PORT --workers 3 --timeout 120 warranty_vault.wsgi:application"]
```

### Option 2: Python Wrapper Script

Create `backend/start.py`:
```python
import os
import subprocess

port = os.environ.get('PORT', '8000')
print(f"Starting gunicorn on port {port}...")

cmd = [
    'gunicorn',
    '--bind', f'0.0.0.0:{port}',
    '--workers', '3',
    '--timeout', '120',
    'warranty_vault.wsgi:application'
]

subprocess.run(cmd)
```

Dockerfile:
```dockerfile
CMD ["python", "start.py"]
```

### Option 3: Remove Healthcheck Temporarily

Update `railway.toml`:
```toml
[deploy]
# healthcheckPath = "/api/health/"  # Comment this out temporarily
restartPolicyType = "ON_FAILURE"
```

This allows the app to start without health check validation.

### Option 4: Use Nixpacks Instead of Docker

Delete `Dockerfile` and let Railway use Nixpacks (auto-detection):
- Railway will automatically detect Django
- Will handle PORT variable correctly
- May be simpler for Django apps

Update `railway.toml`:
```toml
[build]
builder = "NIXPACKS"

[deploy]
startCommand = "gunicorn --bind 0.0.0.0:$PORT --workers 3 --timeout 120 warranty_vault.wsgi:application"
restartPolicyType = "ON_FAILURE"
```

## Debugging Steps

### 1. Check Railway Environment Variables

In Railway dashboard:
- Go to Variables tab
- Verify `PORT` is NOT manually set
- Railway should set it automatically

### 2. Check Build Logs

Look for:
```
Copying backend/start.sh to /app/start.sh
chmod +x /app/start.sh
```

### 3. Check Deploy Logs

Look for:
```
Starting gunicorn on port XXXX...
```

If you see the actual port number, the script is working.

### 4. Test Locally with Docker

```bash
cd C:\Users\lenovo\Downloads\DWV

# Build the image
docker build -t dwv-test .

# Run with PORT variable
docker run -e PORT=3000 -p 3000:3000 dwv-test

# Check if it starts on port 3000
```

## Current Status

✅ Startup script created: `backend/start.sh`
✅ Dockerfile updated to use startup script
✅ Changes pushed to GitHub
⏳ Waiting for Railway to redeploy

## Next Steps

1. **Monitor Railway Deployment**
   - Watch for new deployment with commit: "Add startup script to handle PORT variable properly"
   - Check deploy logs for "Starting gunicorn on port..." message

2. **If Still Fails**
   - Try Option 1 (ENTRYPOINT approach)
   - Or try Option 4 (Switch to Nixpacks)

3. **If Succeeds**
   - Verify health check passes
   - Test API endpoints
   - Celebrate! 🎉

## Railway Configuration Files

Current configuration:

**Dockerfile**: Uses startup script
**Procfile**: Has release command for migrations
**railway.toml**: Configured for Docker build with health check
**Aptfile**: System dependencies (Tesseract, Poppler)

All files are properly configured for Railway deployment.
