# OWAT Kenya Backend Docker Test Script
# Run this after docker-compose has finished building

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "   OWAT Kenya Backend Test Script" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# Wait for services
Write-Host "⏳ Waiting for services to be ready..." -ForegroundColor Yellow
Start-Sleep -Seconds 5

# Check Docker containers
Write-Host "`n📦 Checking Docker containers..." -ForegroundColor Cyan
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# Test Health Check
Write-Host "`n🏥 Testing Health Check..." -ForegroundColor Cyan
try {
    $health = Invoke-RestMethod -Uri "http://localhost:5000/health" -Method Get -ErrorAction Stop
    Write-Host "✅ Health Check Passed!" -ForegroundColor Green
    Write-Host "   Message: $($health.message)" -ForegroundColor Gray
} catch {
    Write-Host "❌ Health Check Failed!" -ForegroundColor Red
    Write-Host "   Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "`n💡 Backend might still be starting. Wait 30 seconds and try again." -ForegroundColor Yellow
    exit 1
}

# Test Register User
Write-Host "`n👤 Testing User Registration..." -ForegroundColor Cyan
$registerBody = @{
    name = "Alex Mwangi"
    email = "alexmwangimungai254@gmail.com"
    password = "OWATKenya2024!"
} | ConvertTo-Json

try {
    $register = Invoke-RestMethod -Uri "http://localhost:5000/api/v1/auth/register" -Method Post -Body $registerBody -ContentType "application/json" -ErrorAction Stop
    Write-Host "✅ User Registered Successfully!" -ForegroundColor Green
    Write-Host "   User: $($register.data.user.name)" -ForegroundColor Gray
    Write-Host "   Email: $($register.data.user.email)" -ForegroundColor Gray
} catch {
    if ($_.Exception.Response.StatusCode -eq 400) {
        Write-Host "⚠️  User already exists (this is OK)" -ForegroundColor Yellow
    } else {
        Write-Host "❌ Registration Failed!" -ForegroundColor Red
        Write-Host "   Error: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Test Login
Write-Host "`n🔐 Testing User Login..." -ForegroundColor Cyan
$loginBody = @{
    email = "alexmwangimungai254@gmail.com"
    password = "OWATKenya2024!"
} | ConvertTo-Json

try {
    $login = Invoke-RestMethod -Uri "http://localhost:5000/api/v1/auth/login" -Method Post -Body $loginBody -ContentType "application/json" -ErrorAction Stop
    $token = $login.data.accessToken
    Write-Host "✅ Login Successful!" -ForegroundColor Green
    Write-Host "   Token: $($token.Substring(0, 30))..." -ForegroundColor Gray
    
    # Test Profile with Token
    Write-Host "`n👨‍💼 Testing Profile Endpoint (Authenticated)..." -ForegroundColor Cyan
    $headers = @{
        Authorization = "Bearer $token"
    }
    $profile = Invoke-RestMethod -Uri "http://localhost:5000/api/v1/auth/profile" -Method Get -Headers $headers -ErrorAction Stop
    Write-Host "✅ Profile Retrieved!" -ForegroundColor Green
    Write-Host "   Name: $($profile.data.user.name)" -ForegroundColor Gray
    Write-Host "   Role: $($profile.data.user.role)" -ForegroundColor Gray
    
} catch {
    Write-Host "❌ Login Failed!" -ForegroundColor Red
    Write-Host "   Error: $($_.Exception.Message)" -ForegroundColor Red
}

# Test Products Endpoint
Write-Host "`n🛍️  Testing Products Endpoint..." -ForegroundColor Cyan
try {
    $products = Invoke-RestMethod -Uri "http://localhost:5000/api/v1/products" -Method Get -ErrorAction Stop
    Write-Host "✅ Products Endpoint Working!" -ForegroundColor Green
    Write-Host "   Products Found: $($products.data.products.Count)" -ForegroundColor Gray
} catch {
    Write-Host "❌ Products Endpoint Failed!" -ForegroundColor Red
}

# Test Categories Endpoint
Write-Host "`n📁 Testing Categories Endpoint..." -ForegroundColor Cyan
try {
    $categories = Invoke-RestMethod -Uri "http://localhost:5000/api/v1/categories" -Method Get -ErrorAction Stop
    Write-Host "✅ Categories Endpoint Working!" -ForegroundColor Green
    Write-Host "   Categories Found: $($categories.data.categories.Count)" -ForegroundColor Gray
} catch {
    Write-Host "❌ Categories Endpoint Failed!" -ForegroundColor Red
}

# Summary
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "   Test Summary" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "`n✅ Backend API: http://localhost:5000" -ForegroundColor Green
Write-Host "✅ MongoDB GUI: http://localhost:8081 (admin/admin)" -ForegroundColor Green
Write-Host "`n📝 Useful Commands:" -ForegroundColor Yellow
Write-Host "   View logs:  docker-compose logs -f backend" -ForegroundColor Gray
Write-Host "   Stop:       docker-compose down" -ForegroundColor Gray
Write-Host "   Restart:    docker-compose restart backend" -ForegroundColor Gray
Write-Host "`n🎉 All tests complete!`n" -ForegroundColor Green
