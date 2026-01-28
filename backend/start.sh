#!/bin/bash
# Startup script for Railway deployment
# This script ensures PORT variable is properly set before starting gunicorn

# Check if PORT is set, if not use default
if [ -z "$PORT" ]; then
    echo "WARNING: PORT environment variable not set, using default 8000"
    export PORT=8000
fi

echo "Starting gunicorn on port $PORT..."

# Start gunicorn with the PORT variable
exec gunicorn --bind 0.0.0.0:$PORT --workers 3 --timeout 120 warranty_vault.wsgi:application
