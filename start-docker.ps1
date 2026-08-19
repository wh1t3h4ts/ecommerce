# Start Docker containers
Write-Host "Starting OWAT Kenya Docker containers..." -ForegroundColor Cyan

# Navigate to project directory
Set-Location "c:\Users\USER\Desktop\ecommerce-OneShop"

# Start docker-compose in detached mode
& docker-compose up -d

# Wait for services to be ready
Start-Sleep -Seconds 10

# Check status
Write-Host "`nContainer Status:" -ForegroundColor Yellow
& docker ps

Write-Host "`nAll services started!" -ForegroundColor Green
Write-Host "Backend: http://localhost:5000" -ForegroundColor Gray
Write-Host "MongoDB Express: http://localhost:8081" -ForegroundColor Gray
