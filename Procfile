# Release command - runs migrations before deployment
release: python manage.py migrate --noinput

# Web process - runs gunicorn server
web: gunicorn --bind 0.0.0.0:$PORT --workers 3 --timeout 120 warranty_vault.wsgi:application
