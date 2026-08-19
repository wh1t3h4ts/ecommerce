import Stripe from 'stripe';
import { config } from '../config/env';

if (!config.stripe.secretKey) {
  throw new Error('STRIPE_SECRET_KEY is not defined');
}

export const stripe = new Stripe(config.stripe.secretKey, {
  apiVersion: '2024-12-18.acacia',
  typescript: true,
});

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
