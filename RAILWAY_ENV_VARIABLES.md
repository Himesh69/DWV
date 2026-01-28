# Railway Environment Variables Configuration
# Copy these variables to your Railway dashboard

## Required Variables

# Django Secret Key (CRITICAL - Keep this secret!)
SECRET_KEY=bed(kzu*&uq1h!@@55f84w)kppxta5-i%4p%e%+aapp-_()vvd5

# Debug Mode (Set to False in production)
DEBUG=False

# Allowed Hosts (Railway domains)
ALLOWED_HOSTS=.railway.app

# Database URL (Automatically set by Railway PostgreSQL service)
# DATABASE_URL=postgresql://... (Railway sets this automatically)

## Email Configuration (for warranty expiry notifications)

# Gmail SMTP Configuration
EMAIL_HOST_USER=your-email@gmail.com
EMAIL_HOST_PASSWORD=your-gmail-app-password

# Note: For Gmail, you need to create an "App Password":
# 1. Go to Google Account settings
# 2. Security > 2-Step Verification
# 3. App passwords > Generate new app password
# 4. Use that password here (not your regular Gmail password)

## CORS Configuration

# Frontend domain (update with your actual frontend URL)
CORS_ALLOWED_ORIGINS=https://your-frontend-domain.railway.app
CORS_ALLOW_ALL_ORIGINS=False

## OCR Configuration

# Option 1: Local Tesseract (installed via Aptfile - recommended for Railway)
TESSERACT_CMD=/usr/bin/tesseract
POPPLER_PATH=/usr/bin

# Option 2: Cloud OCR API (OCR.space) - Fallback or Alternative
# Get your free API key from: https://ocr.space/ocrapi
USE_CLOUD_OCR=True
OCR_API_KEY=your-ocr-space-api-key-here

# Note: The OCR service will try local Tesseract first, then fall back to cloud OCR if enabled
# For Railway deployment, Tesseract is installed automatically via Aptfile
# Cloud OCR is useful as a backup or if Tesseract fails

## Optional Variables

# Timezone (default is UTC)
# TIME_ZONE=Asia/Kolkata

# Language Code
# LANGUAGE_CODE=en-us

---

## How to Get OCR.space API Key (Free Tier)

1. Go to https://ocr.space/ocrapi
2. Sign up for a free account
3. Free tier includes:
   - 25,000 requests per month
   - Max file size: 1MB
   - All languages supported
4. Copy your API key from the dashboard
5. Paste it in the OCR_API_KEY variable above

## Railway Deployment Steps

1. Go to https://railway.app
2. Create new project > Deploy from GitHub repo
3. Select: Himesh69/DWV
4. Add PostgreSQL database service (Railway will auto-set DATABASE_URL)
5. Go to Variables tab
6. Add all the variables listed above
7. Deploy!

## Important Notes

- **SECRET_KEY**: Never commit this to GitHub or share publicly
- **DATABASE_URL**: Railway sets this automatically when you add PostgreSQL
- **OCR Configuration**: You can use local Tesseract (free, unlimited) or cloud OCR (25k/month free) or both
- **Email**: Required for warranty expiry notifications to work
- **CORS**: Update with your actual frontend domain after deployment
