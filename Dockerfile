# Dockerfile for Digital Warranty Vault (DWV)
# Optimized for Railway deployment with OCR support

FROM python:3.11-slim

# Set environment variables
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

# Set work directory
WORKDIR /app

# Install system dependencies including Tesseract OCR and Poppler
RUN apt-get update && apt-get install -y \
    tesseract-ocr \
    tesseract-ocr-eng \
    poppler-utils \
    postgresql-client \
    gcc \
    python3-dev \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements file
COPY backend/requirements.txt /app/

# Install Python dependencies using python -m pip as requested
RUN python -m pip install --upgrade pip && \
    python -m pip install -r requirements.txt

# Copy backend code
COPY backend /app/

# Copy and set permissions for startup script
COPY backend/start.sh /app/start.sh
RUN chmod +x /app/start.sh

# Create necessary directories
RUN mkdir -p /app/staticfiles /app/media

# Collect static files
RUN python manage.py collectstatic --noinput || true

# Expose port (Railway will set PORT env variable)
EXPOSE 8000

# Use startup script to handle PORT variable
CMD ["/app/start.sh"]
