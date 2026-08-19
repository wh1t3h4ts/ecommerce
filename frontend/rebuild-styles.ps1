# Rebuild Frontend Styles
Write-Host ""
Write-Host "Rebuilding OWAT Kenya Frontend with New Theme..." -ForegroundColor Cyan
Write-Host ""

# Navigate to frontend directory
Set-Location "c:\Users\USER\Desktop\ecommerce-OneShop\frontend"

Write-Host "Step 1: Clearing Vite cache..." -ForegroundColor Yellow
if (Test-Path ".\.vite") {
    Remove-Item -Recurse -Force ".\.vite"
    Write-Host "  Cache cleared!" -ForegroundColor Green
} else {
    Write-Host "  No cache to clear" -ForegroundColor Gray
}

Write-Host ""
Write-Host "Step 2: Clearing dist folder..." -ForegroundColor Yellow
if (Test-Path ".\dist") {
    Remove-Item -Recurse -Force ".\dist"
    Write-Host "  Dist cleared!" -ForegroundColor Green
} else {
    Write-Host "  No dist folder" -ForegroundColor Gray
}

Write-Host ""
Write-Host "Step 3: Clearing node_modules/.vite..." -ForegroundColor Yellow
if (Test-Path ".\node_modules\.vite") {
    Remove-Item -Recurse -Force ".\node_modules\.vite"
    Write-Host "  Vite cache cleared!" -ForegroundColor Green
} else {
    Write-Host "  No Vite cache" -ForegroundColor Gray
}

Write-Host ""
Write-Host "Rebuild complete! Now start the dev server:" -ForegroundColor Cyan
Write-Host "  cd frontend" -ForegroundColor Gray
Write-Host "  npm run dev" -ForegroundColor Gray
Write-Host ""
Write-Host "The new ORANGE theme will be visible when you refresh the browser!" -ForegroundColor Green
Write-Host ""
