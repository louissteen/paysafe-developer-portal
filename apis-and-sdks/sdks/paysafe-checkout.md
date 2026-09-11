---
description: A complete hosted checkout, themeable to your brand, in one integration.
icon: cart-shopping
---

# Paysafe Checkout

Paysafe Checkout renders a full payment experience — method selection, card entry, 3-D Secure, wallets, local methods — in an overlay on your page. It is the fastest route from nothing to a live payment.

## Install

```html
<script src="https://hosted.paysafe.com/checkout/v2/paysafe.checkout.min.js"></script>
```

## Open the checkout

```javascript
paysafe.checkout.setup(SINGLE_USE_TOKEN_API_KEY, {
  currency: "USD",
  amount: 4999,
  environment: "TEST",
  merchantRefNum: `order-${orderId}`,

  customer: {
    firstName: "Jane",
    lastName: "Ellery",
    email: "jane.ellery@example.com",
  },

  billingAddress: {
    country: "CA",
    zip: "M5H 2N2",
    street: "100 Queen Street West",
    city: "Toronto",
    state: "ON",
  },

  locale: "en_US",
  simulator: "EXTERNAL",

  displayPaymentMethods: ["card", "applePay", "googlePay", "paypal", "skrill"],

  theme: {
    primaryColor: "#5A28FF",
    fontFamily: "Inter, system-ui, sans-serif",
    borderRadius: 8,
  },
},
function (instance, error, result) {
  if (result && result.paymentHandleToken) {
    // Send to YOUR server to create the payment.
    fetch("/api/pay", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ token: result.paymentHandleToken, orderId }),
    }).then(() => instance.showSuccessScreen("Payment complete"));
  } else {
    instance.showFailureScreen(error?.displayMessage ?? "Payment failed");
  }
});
```

{% hint style="warning" %}
The callback gives you a **token**, not a completed payment. Your server still creates the payment. Treating the callback as confirmation is the most common Checkout integration bug — a customer who closes the tab at the wrong moment gets goods without a charge.
{% endhint %}

## Callbacks

| Callback | Fires when |
|---|---|
| `onSuccess` | A payment handle was created |
| `onError` | The customer hit an unrecoverable error |
| `onCancel` | The customer closed the overlay |
| `riskCallback` | Before authorization, for your own risk decision |

The `riskCallback` receives the payment context and lets you veto a transaction before it reaches the acquirer.

## Partial Authorization Service

For prepaid and gift cards that may not cover the full amount, PAS authorizes what is available and tells you the shortfall, so you can collect the remainder on a second instrument rather than declining outright.

## Shopping carts

Pre-built Checkout integrations exist for common platforms, with no code required.

| Platform | Methods |
|---|---|
| Shopify | Card (embedded), Skrill, PaysafeCash, PaysafeCard, BLIK, ACH, EFT |
| WooCommerce (official, v3) | Card, Google Pay, ACH, EFT, PayPal |
| Magento | Card, Apple Pay, Google Pay |
