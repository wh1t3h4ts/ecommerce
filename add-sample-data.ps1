# Add Sample Data to OWAT Kenya Backend
Write-Host ""
Write-Host "Adding Sample Data to OWAT Kenya Database..." -ForegroundColor Cyan
Write-Host ""

# First, login as admin to get auth token
Write-Host "Logging in as admin..." -ForegroundColor Yellow

$loginBody = @{
    email = "admin@owatkenya.com"
    password = "OWATAdmin2024!"
} | ConvertTo-Json

try {
    $loginResponse = Invoke-RestMethod -Uri "http://localhost:5000/api/v1/auth/login" -Method Post -Body $loginBody -ContentType "application/json" -ErrorAction Stop
    $token = $loginResponse.data.accessToken
    Write-Host "  Logged in successfully" -ForegroundColor Green
} catch {
    Write-Host "  Failed to login. Make sure you have run create-admin.ps1 first." -ForegroundColor Red
    Write-Host "  Run: .\create-admin.ps1" -ForegroundColor Yellow
    exit 1
}

# Create headers with auth token
$headers = @{
    "Authorization" = "Bearer $token"
    "Content-Type" = "application/json"
}

# Create categories
Write-Host ""
Write-Host "Creating Categories..." -ForegroundColor Yellow

$categoryData = @(
    @{ name = "Electronics"; slug = "electronics"; description = "Electronic devices and gadgets"; isActive = $true }
    @{ name = "Fashion"; slug = "fashion"; description = "Clothing and accessories"; isActive = $true }
    @{ name = "Sports"; slug = "sports"; description = "Sports equipment and gear"; isActive = $true }
    @{ name = "Home and Kitchen"; slug = "home-kitchen"; description = "Home and kitchen appliances"; isActive = $true }
)

$categoryIds = @{}

foreach ($cat in $categoryData) {
    $json = $cat | ConvertTo-Json
    try {
        $response = Invoke-RestMethod -Uri "http://localhost:5000/api/v1/categories" -Method Post -Body $json -Headers $headers -ErrorAction Stop
        $categoryIds[$cat.slug] = $response.data.category._id
        Write-Host "  Created: $($cat.name)" -ForegroundColor Green
    } catch {
        Write-Host "  Category might already exist: $($cat.name)" -ForegroundColor Yellow
    }
}

Start-Sleep -Seconds 1

# Get existing categories if we didn't create them
if ($categoryIds.Count -eq 0) {
    Write-Host "  Fetching existing categories..." -ForegroundColor Cyan
    try {
        $existingResponse = Invoke-RestMethod -Uri "http://localhost:5000/api/v1/categories" -Method Get
        foreach ($cat in $existingResponse.data.categories) {
            $categoryIds[$cat.slug] = $cat._id
        }
    } catch {
        Write-Host "  Failed to fetch categories" -ForegroundColor Red
        exit 1
    }
}

# Now create products
Write-Host ""
Write-Host "Creating Products..." -ForegroundColor Yellow

$electronicsId = $categoryIds["electronics"]

if (-not $electronicsId) {
    Write-Host "  Electronics category not found" -ForegroundColor Red
    exit 1
}

# Product 1: Wireless Headphones
$product1 = @{
    name = "Wireless Headphones"
    slug = "wireless-headphones"
    description = "Premium wireless headphones with active noise cancellation and 30-hour battery life. Perfect for music lovers and professionals."
    price = 799900
    currency = "KES"
    category = $electronicsId
    stock = 50
    featured = $true
    isActive = $true
    images = @(
        @{
            url = "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500&h=500&fit=crop"
            public_id = "wireless-headphones"
        }
    )
}

try {
    $json1 = $product1 | ConvertTo-Json -Depth 10
    $result1 = Invoke-RestMethod -Uri "http://localhost:5000/api/v1/products" -Method Post -Body $json1 -Headers $headers -ErrorAction Stop
    Write-Host "  Created: Wireless Headphones - KSh 7,999" -ForegroundColor Green
} catch {
    Write-Host "  Failed to create: Wireless Headphones" -ForegroundColor Red
    Write-Host "  Error: $($_.Exception.Message)" -ForegroundColor Red
}

# Product 2: Smart Watch
$product2 = @{
    name = "Smart Watch"
    slug = "smart-watch"
    description = "Feature-rich smartwatch with fitness tracking, heart rate monitoring, and mobile notifications. Stay connected on the go."
    price = 1299900
    currency = "KES"
    category = $electronicsId
    stock = 35
    featured = $true
    isActive = $true
    images = @(
        @{
            url = "https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500&h=500&fit=crop"
            public_id = "smart-watch"
        }
    )
}

try {
    $json2 = $product2 | ConvertTo-Json -Depth 10
    $result2 = Invoke-RestMethod -Uri "http://localhost:5000/api/v1/products" -Method Post -Body $json2 -Headers $headers -ErrorAction Stop
    Write-Host "  Created: Smart Watch - KSh 12,999" -ForegroundColor Green
} catch {
    Write-Host "  Failed to create: Smart Watch" -ForegroundColor Red
    Write-Host "  Error: $($_.Exception.Message)" -ForegroundColor Red
}

# Product 3: Leather Backpack
$product3 = @{
    name = "Leather Backpack"
    slug = "leather-backpack"
    description = "Stylish genuine leather backpack with laptop compartment and multiple pockets. Perfect for work and travel."
    price = 899900
    currency = "KES"
    category = $electronicsId
    stock = 42
    featured = $true
    isActive = $true
    images = @(
        @{
            url = "https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=500&h=500&fit=crop"
            public_id = "leather-backpack"
        }
    )
}

try {
    $json3 = $product3 | ConvertTo-Json -Depth 10
    $result3 = Invoke-RestMethod -Uri "http://localhost:5000/api/v1/products" -Method Post -Body $json3 -Headers $headers -ErrorAction Stop
    Write-Host "  Created: Leather Backpack - KSh 8,999" -ForegroundColor Green
} catch {
    Write-Host "  Failed to create: Leather Backpack" -ForegroundColor Red
    Write-Host "  Error: $($_.Exception.Message)" -ForegroundColor Red
}

# Product 4: Running Shoes
$product4 = @{
    name = "Running Shoes"
    slug = "running-shoes"
    description = "Comfortable running shoes with superior cushioning and breathable mesh upper. Ideal for daily runs and workouts."
    price = 649900
    currency = "KES"
    category = $electronicsId
    stock = 78
    featured = $true
    isActive = $true
    images = @(
        @{
            url = "https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500&h=500&fit=crop"
            public_id = "running-shoes"
        }
    )
}

try {
    $json4 = $product4 | ConvertTo-Json -Depth 10
    $result4 = Invoke-RestMethod -Uri "http://localhost:5000/api/v1/products" -Method Post -Body $json4 -Headers $headers -ErrorAction Stop
    Write-Host "  Created: Running Shoes - KSh 6,499" -ForegroundColor Green
} catch {
    Write-Host "  Failed to create: Running Shoes" -ForegroundColor Red
    Write-Host "  Error: $($_.Exception.Message)" -ForegroundColor Red
}

# Product 5: Coffee Maker
$product5 = @{
    name = "Coffee Maker"
    slug = "coffee-maker"
    description = "Programmable coffee maker with thermal carafe and auto-brew feature. Wake up to fresh coffee every morning."
    price = 549900
    currency = "KES"
    category = $electronicsId
    stock = 28
    featured = $true
    isActive = $true
    images = @(
        @{
            url = "https://images.unsplash.com/photo-1517668808822-9ebb02f2a0e6?w=500&h=500&fit=crop"
            public_id = "coffee-maker"
        }
    )
}

try {
    $json5 = $product5 | ConvertTo-Json -Depth 10
    $result5 = Invoke-RestMethod -Uri "http://localhost:5000/api/v1/products" -Method Post -Body $json5 -Headers $headers -ErrorAction Stop
    Write-Host "  Created: Coffee Maker - KSh 5,499" -ForegroundColor Green
} catch {
    Write-Host "  Failed to create: Coffee Maker" -ForegroundColor Red
    Write-Host "  Error: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Write-Host "Sample data added successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "Summary:" -ForegroundColor Cyan
Write-Host "  - Categories: 4" -ForegroundColor Gray
Write-Host "  - Products: 5" -ForegroundColor Gray
Write-Host ""
Write-Host "View your store:" -ForegroundColor Cyan
Write-Host "  - Frontend: http://localhost:5173" -ForegroundColor Gray
Write-Host "  - Backend: http://localhost:5000" -ForegroundColor Gray
Write-Host "  - MongoDB: http://localhost:8081" -ForegroundColor Gray
Write-Host ""
