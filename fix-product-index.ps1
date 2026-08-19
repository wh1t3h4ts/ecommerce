# Fix Product Variant Index Issue
Write-Host ""
Write-Host "Fixing Product Variant SKU Index..." -ForegroundColor Cyan
Write-Host ""

# Drop the problematic unique index
Write-Host "Dropping variants.sku_1 index..." -ForegroundColor Yellow

$mongoCommand = "db.products.dropIndex('variants.sku_1')"

try {
    docker exec owat-mongodb mongosh "mongodb://admin:owatkenya2024@localhost:27017/owat-kenya?authSource=admin" --eval "$mongoCommand"
    Write-Host ""
    Write-Host "  Index dropped successfully!" -ForegroundColor Green
} catch {
    Write-Host "  Failed to drop index (it might not exist)" -ForegroundColor Yellow
}

# Restart backend to apply model changes
Write-Host ""
Write-Host "Restarting backend..." -ForegroundColor Yellow
docker restart owat-backend | Out-Null
Start-Sleep -Seconds 8

Write-Host "  Backend restarted!" -ForegroundColor Green
Write-Host ""
Write-Host "You can now create products without variant conflicts." -ForegroundColor Cyan
Write-Host ""
