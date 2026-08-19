# Create Admin User for OWAT Kenya
Write-Host ""
Write-Host "Creating Admin User for OWAT Kenya..." -ForegroundColor Cyan
Write-Host ""

# MongoDB connection details
$mongoUri = "mongodb://admin:owatkenya2024@localhost:27017/owat-kenya?authSource=admin"

# First, register the user via API
Write-Host "Registering admin user..." -ForegroundColor Yellow
$regBody = @{
    name = "OWAT Admin"
    email = "admin@owatkenya.com"
    password = "OWATAdmin2024!"
} | ConvertTo-Json

try {
    $registerResponse = Invoke-RestMethod -Uri "http://localhost:5000/api/v1/auth/register" -Method Post -Body $regBody -ContentType "application/json" -ErrorAction Stop
    $userId = $registerResponse.data.user.id
    Write-Host "  User registered with ID: $userId" -ForegroundColor Green
} catch {
    Write-Host "  User might already exist, trying to get ID..." -ForegroundColor Yellow
    
    # Try to login to get user ID
    $loginBody = @{
        email = "admin@owatkenya.com"
        password = "OWATAdmin2024!"
    } | ConvertTo-Json
    
    try {
        $loginResponse = Invoke-RestMethod -Uri "http://localhost:5000/api/v1/auth/login" -Method Post -Body $loginBody -ContentType "application/json" -ErrorAction Stop
        $userId = $loginResponse.data.user.id
        Write-Host "  Found existing user with ID: $userId" -ForegroundColor Green
    } catch {
        Write-Host "  Failed to register or login user" -ForegroundColor Red
        exit 1
    }
}

# Now update the role in MongoDB directly using docker exec
Write-Host ""
Write-Host "Updating user role to admin..." -ForegroundColor Yellow

$mongoCommand = "db.users.updateOne({_id: ObjectId('$userId')}, {`$set: {role: 'admin'}})"

try {
    docker exec owat-mongodb mongosh "mongodb://admin:owatkenya2024@localhost:27017/owat-kenya?authSource=admin" --eval "$mongoCommand"
    Write-Host ""
    Write-Host "  Admin user created successfully!" -ForegroundColor Green
} catch {
    Write-Host "  Failed to update role in MongoDB" -ForegroundColor Red
    Write-Host "  You can update manually in Mongo Express at http://localhost:8081" -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "Admin Credentials:" -ForegroundColor Cyan
Write-Host "  Email: admin@owatkenya.com" -ForegroundColor Gray
Write-Host "  Password: OWATAdmin2024!" -ForegroundColor Gray
Write-Host ""
