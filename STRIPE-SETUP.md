# Stripe Payment Setup for OWAT Kenya

## Current Status
⚠️ **Stripe is NOT configured** - Orders can be created but payment processing is disabled.

## Why Orders Work Without Stripe
The backend has been modified to gracefully handle missing Stripe configuration:
- Orders are created successfully in the database
- Payment status is set to "pending"
- Stripe PaymentIntent creation is skipped if keys are invalid
- Frontend checkout flow completes without errors

## To Enable Stripe Payments

### 1. Get Stripe API Keys
1. Create a Stripe account at https://stripe.com
2. Go to Developers → API keys
3. Copy your **Test** keys (for development):
   - Publishable key (starts with `pk_test_`)
   - Secret key (starts with `sk_test_`)

### 2. For Kenyan Payments
Stripe supports KES (Kenyan Shilling) but you need to:
1. Set your Stripe account country to Kenya (or use international mode)
2. Verify that KES is enabled in your account settings
3. Consider integrating M-Pesa through Stripe (if available) for local payments

### 3. Update Environment Variables

#### Backend (docker-compose.yml)
Replace the placeholder values:
```yaml
environment:
  STRIPE_SECRET_KEY: sk_test_YOUR_ACTUAL_SECRET_KEY_HERE
  STRIPE_PUBLISHABLE_KEY: pk_test_YOUR_ACTUAL_PUBLISHABLE_KEY_HERE
  STRIPE_WEBHOOK_SECRET: whsec_YOUR_WEBHOOK_SECRET_HERE  # Optional for now
```

#### Frontend (.env)
```
VITE_STRIPE_PUBLIC_KEY=pk_test_YOUR_ACTUAL_PUBLISHABLE_KEY_HERE
```

### 4. Restart Services
```powershell
# Restart backend
docker restart owat-backend

# Restart frontend (if running)
# Press Ctrl+C in the terminal running npm run dev, then:
npm run dev
```

### 5. Test Payment Flow
1. Add products to cart
2. Go to checkout
3. Fill in shipping information
4. You should see Stripe payment form
5. Use Stripe test card: `4242 4242 4242 4242`
   - Any future expiry date
   - Any 3-digit CVC
   - Any valid ZIP code

## Alternative Payment Options for Kenya

### M-Pesa Integration
For better Kenya market fit, consider:
- **Stripe + M-Pesa**: Check if your Stripe account supports M-Pesa
- **Direct M-Pesa API**: Safaricom Daraja API
- **Payment Aggregators**: 
  - Flutterwave (popular in Kenya)
  - Paystack (supports M-Pesa)
  - Pesapal (Kenyan company)

### Cash on Delivery
You can also implement COD by:
1. Modifying the checkout to accept `paymentMethod: 'cod'`
2. Setting order payment status to `'pending'` or `'cod'`
3. Updating status to `'paid'` when cash is collected

## Current Behavior (Without Stripe)
- ✅ Orders are created in database
- ✅ Stock is deducted correctly
- ✅ Order confirmation page shows
- ✅ Users can view their orders
- ❌ No actual payment processing
- ❌ Payment status stays "pending"
- ℹ️ Perfect for development and testing

## Production Deployment
Before going live:
1. **Use Live Stripe Keys** (starting with `sk_live_` and `pk_live_`)
2. Set up Stripe webhooks for payment confirmations
3. Test with small real transactions
4. Implement proper error handling and retry logic
5. Add email notifications for orders
6. Consider backup payment methods

## Questions?
- Stripe Docs: https://stripe.com/docs
- Stripe Kenya: https://stripe.com/en-ke
- M-Pesa API: https://developer.safaricom.co.ke

---
**Note**: The current setup allows you to develop and test all e-commerce features without payment processing. Add Stripe keys when you're ready to accept real payments.
