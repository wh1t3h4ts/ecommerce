# Add More Products to OWAT Kenya Backend
Write-Host ""
Write-Host "Adding More Products to OWAT Kenya..." -ForegroundColor Cyan
Write-Host ""

# Login as admin
$loginBody = @{
    email = "admin@owatkenya.com"
    password = "OWATAdmin2024!"
} | ConvertTo-Json

$loginResponse = Invoke-RestMethod -Uri "http://localhost:5000/api/v1/auth/login" -Method Post -Body $loginBody -ContentType "application/json"
$token = $loginResponse.data.accessToken

$headers = @{
    "Authorization" = "Bearer $token"
    "Content-Type" = "application/json"
}

# Get categories
$categoriesResponse = Invoke-RestMethod -Uri "http://localhost:5000/api/v1/categories" -Method Get
$categories = @{}
foreach ($cat in $categoriesResponse.data.categories) {
    $categories[$cat.slug] = $cat._id
}

$electronicsId = $categories["electronics"]
$fashionId = $categories["fashion"]
$sportsId = $categories["sports"]
$homeKitchenId = $categories["home-kitchen"]

Write-Host "Creating Products..." -ForegroundColor Yellow

# Products array
$newProducts = @(
    @{
        name = "Premium Smartwatch"
        slug = "premium-smartwatch"
        description = "Advanced smartwatch with GPS, heart rate monitor, and 5-day battery life."
        price = 1599900
        currency = "KES"
        category = $electronicsId
        stock = 28
        featured = $true
        isActive = $true
        images = @(@{ url = "https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500&h=500&fit=crop"; public_id = "premium-smartwatch" })
    }
    @{
        name = "Leather Travel Bag"
        slug = "leather-travel-bag"
        description = "Durable leather travel bag with multiple compartments."
        price = 1099900
        currency = "KES"
        category = $fashionId
        stock = 18
        featured = $true
        isActive = $true
        images = @(@{ url = "https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=500&h=500&fit=crop"; public_id = "leather-travel-bag" })
    }
    @{
        name = "Athletic Running Shoes"
        slug = "athletic-running-shoes"
        description = "Professional running shoes with advanced cushioning technology."
        price = 749900
        currency = "KES"
        category = $sportsId
        stock = 45
        featured = $true
        isActive = $true
        images = @(@{ url = "https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500&h=500&fit=crop"; public_id = "athletic-running-shoes" })
    }
    @{
        name = "Automatic Coffee Machine"
        slug = "automatic-coffee-machine"
        description = "Smart coffee machine with programmable settings and thermal carafe."
        price = 649900
        currency = "KES"
        category = $homeKitchenId
        stock = 22
        featured = $true
        isActive = $true
        images = @(@{ url = "https://images.unsplash.com/photo-1517668808822-9ebb02f2a0e6?w=500&h=500&fit=crop"; public_id = "automatic-coffee-machine" })
    }
    @{
        name = "Wireless Earbuds Pro"
        slug = "wireless-earbuds-pro"
        description = "True wireless earbuds with active noise cancellation and premium sound quality."
        price = 499900
        currency = "KES"
        category = $electronicsId
        stock = 65
        featured = $true
        isActive = $true
        images = @(@{ url = "https://images.unsplash.com/photo-1590658268037-6bf12165a8df?w=500&h=500&fit=crop"; public_id = "wireless-earbuds-pro" })
    }
    @{
        name = "Designer Sunglasses"
        slug = "designer-sunglasses"
        description = "Stylish UV protection sunglasses with polarized lenses."
        price = 399900
        currency = "KES"
        category = $fashionId
        stock = 35
        featured = $false
        isActive = $true
        images = @(@{ url = "https://images.unsplash.com/photo-1511499767150-a48a237f0083?w=500&h=500&fit=crop"; public_id = "designer-sunglasses" })
    }
    @{
        name = "Yoga Mat Premium"
        slug = "yoga-mat-premium"
        description = "Extra thick yoga mat with non-slip surface and carrying strap."
        price = 199900
        currency = "KES"
        category = $sportsId
        stock = 50
        featured = $false
        isActive = $true
        images = @(@{ url = "https://images.unsplash.com/photo-1592432678016-e910b452f9a5?w=500&h=500&fit=crop"; public_id = "yoga-mat-premium" })
    }
    @{
        name = "Kitchen Knife Set"
        slug = "kitchen-knife-set"
        description = "Professional 8-piece knife set with wooden block."
        price = 299900
        currency = "KES"
        category = $homeKitchenId
        stock = 30
        featured = $false
        isActive = $true
        images = @(@{ url = "https://images.unsplash.com/photo-1593618998160-e34014e67546?w=500&h=500&fit=crop"; public_id = "kitchen-knife-set" })
    }
)

$successCount = 0
$failCount = 0

foreach ($product in $newProducts) {
    $json = $product | ConvertTo-Json -Depth 10
    try {
        $result = Invoke-RestMethod -Uri "http://localhost:5000/api/v1/products" -Method Post -Body $json -Headers $headers -ErrorAction Stop
        Write-Host "  Created: $($product.name)" -ForegroundColor Green
        $successCount++
    } catch {
        Write-Host "  Failed: $($product.name)" -ForegroundColor Red
        $failCount++
    }
}

Write-Host ""
Write-Host "Summary:" -ForegroundColor Cyan
Write-Host "  - Created: $successCount" -ForegroundColor Green
Write-Host "  - Failed: $failCount" -ForegroundColor $(if ($failCount -gt 0) { "Red" } else { "Gray" })
Write-Host ""
