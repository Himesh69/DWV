# DWV - Digital Warranty Vault

A comprehensive web application for managing product warranties with OCR receipt scanning capabilities.

## Features

- 🔐 **Secure Authentication**: JWT-based user authentication
- 📱 **Warranty Management**: Track and manage all your product warranties
- 📸 **OCR Receipt Scanning**: Extract warranty information from receipt images using Tesseract OCR
- 📧 **Email Notifications**: Automated expiry reminders
- 📊 **Dashboard**: Visual overview of warranty status
- 🔗 **QR Code Sharing**: Share warranty details via QR codes
- 🌐 **RESTful API**: Full-featured REST API built with Django REST Framework

## Tech Stack

### Backend
- **Framework**: Django 5.0 + Django REST Framework
- **Database**: PostgreSQL
- **Authentication**: JWT (djangorestframework-simplejwt)
- **OCR**: Tesseract OCR + pytesseract
- **PDF Processing**: pdf2image + PyPDF2
- **Server**: Gunicorn

### Frontend
- **Framework**: React + Vite
- **Styling**: TailwindCSS
- **HTTP Client**: Axios
- **Routing**: React Router

## Railway Deployment

This project is configured for deployment on Railway with Docker.

### Prerequisites
1. Railway account
2. PostgreSQL database on Railway
3. GitHub repository connected to Railway

### Environment Variables

Set these in your Railway dashboard:

```
SECRET_KEY=your-secret-key-here
DEBUG=False
DATABASE_URL=postgresql://... (automatically set by Railway PostgreSQL)
ALLOWED_HOSTS=.railway.app,your-domain.com
CORS_ALLOWED_ORIGINS=https://your-frontend-domain.com

# Email Configuration
EMAIL_HOST_USER=your-email@gmail.com
EMAIL_HOST_PASSWORD=your-app-password

# Optional: OCR Configuration
TESSERACT_CMD=/usr/bin/tesseract
POPPLER_PATH=/usr/bin
```

### Deployment Steps

1. **Create Railway Project**
   - Connect your GitHub repository
   - Add PostgreSQL database service

2. **Configure Environment Variables**
   - Set all required environment variables in Railway dashboard

3. **Deploy**
   - Railway will automatically detect the Dockerfile
   - System dependencies (Tesseract, Poppler) are installed via Aptfile
   - Python dependencies are installed from requirements.txt
   - Migrations run automatically via Procfile release command

4. **Verify Deployment**
   - Check logs for any errors
   - Test OCR functionality by uploading a receipt

## Local Development

### Backend Setup

```bash
cd backend
python -m pip install -r requirements.txt
python manage.py migrate
python manage.py createsuperuser
python manage.py runserver
```

### Frontend Setup

```bash
cd frontend
npm install
npm run dev
```

## OCR Feature

The OCR feature uses Tesseract to extract warranty information from receipt images:

- Supported formats: JPG, PNG, PDF, BMP, TIFF
- Automatically extracts: Product name, brand, purchase date, warranty period
- Auto-categorizes products based on keywords
- Provides confidence scores for extracted data

## License

MIT License

## Author

Digital Warranty Vault Team
