# GitHub Repository Setup Instructions

## Create GitHub Repository

Since the GitHub CLI is not available, please follow these steps to create the repository manually:

### Step 1: Create Repository on GitHub

1. Go to https://github.com/new
2. Repository name: **DWV**
3. Description: "Digital Warranty Vault - Product warranty management with OCR receipt scanning"
4. Visibility: **Public** (or Private if you prefer)
5. **DO NOT** initialize with README, .gitignore, or license (we already have these)
6. Click "Create repository"

### Step 2: Push Local Repository to GitHub

After creating the repository on GitHub, run these commands in PowerShell:

```powershell
cd C:\Users\lenovo\Downloads\DWV
git remote add origin https://github.com/YOUR_USERNAME/DWV.git
git branch -M main
git push -u origin main
```

Replace `YOUR_USERNAME` with your actual GitHub username.

### Alternative: Using SSH

If you prefer SSH:

```powershell
cd C:\Users\lenovo\Downloads\DWV
git remote add origin git@github.com:YOUR_USERNAME/DWV.git
git branch -M main
git push -u origin main
```

## Verify Repository

After pushing, verify that:
- All files are visible on GitHub
- The README.md displays correctly
- OCR files are present in `backend/warranties/`
- Docker files (Dockerfile, Aptfile, Procfile) are present

## Next Steps: Railway Deployment

1. Go to https://railway.app
2. Click "New Project"
3. Select "Deploy from GitHub repo"
4. Choose your DWV repository
5. Add PostgreSQL database service
6. Set environment variables (see README.md for required variables)
7. Deploy!

Railway will automatically:
- Detect the Dockerfile
- Install system dependencies from Aptfile
- Run migrations via Procfile
- Start the application

## Important Files Created

✅ `backend/warranties/ocr_service.py` - OCR scanning service
✅ `backend/requirements.txt` - Updated with OCR dependencies
✅ `Dockerfile` - Docker configuration for Railway
✅ `Aptfile` - System dependencies (Tesseract, Poppler)
✅ `Procfile` - Railway process configuration
✅ `.dockerignore` - Docker build exclusions
✅ `railway.toml` - Railway deployment settings
✅ `README.md` - Comprehensive documentation

## OCR Feature Status

✅ **RESTORED** - The OCR scanning feature is now fully functional in the DWV project!

The feature includes:
- Receipt image scanning (JPG, PNG, PDF, BMP, TIFF)
- Automatic extraction of product details
- Brand and warranty period detection
- Auto-categorization of products
- Confidence scoring for extracted data
