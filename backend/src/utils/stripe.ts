import Stripe from 'stripe';
import { config } from '../config/env';

// Check if Stripe is properly configured
const isStripeConfigured = 
  config.stripe.secretKey && 
  config.stripe.secretKey !== 'sk_test_placeholder' &&
  config.stripe.secretKey.startsWith('sk_');

// Initialize Stripe only if properly configured
export const stripe = isStripeConfigured 
  ? new Stripe(config.stripe.secretKey, {
      apiVersion: '2024-12-18.acacia',
      typescript: true,
    })
  : null;

// Helper to check if Stripe is available
export const isStripeAvailable = (): boolean => {
  return stripe !== null;
};

export const calculateTax = (subtotal: number): number => {
  // 16% VAT for Kenya
  // In production, use proper tax calculation based on location
  return Math.round(subtotal * 0.16);
};

export const calculateShipping = (items: number, total: number): number => {
  // Simple shipping calculation
  // Free shipping over KSh 1000, otherwise KSh 50
  if (total >= 100000) {
    // KSh 1000 in cents
    return 0;
  }
  return 5000; // KSh 50 in cents
};
