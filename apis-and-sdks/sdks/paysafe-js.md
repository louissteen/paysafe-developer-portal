---
description: >-
  Embed Paysafe-hosted payment fields inside your own form and keep PCI scope
  at SAQ A.
icon: js
---

# Paysafe JS

Paysafe JS renders individual payment fields — card number, expiry, CVV — as iframes served by Paysafe, which you position inside your own form. You control the layout and styling; the card number never enters your page's DOM.

## Install

```html
<script src="https://hosted.paysafe.com/js/v1/latest/paysafe.min.js"></script>
```

## Initialize

```javascript
const instance = await paysafe.fields.setup(SINGLE_USE_TOKEN_API_KEY, {
  currencyCode: "USD",
  environment: "TEST",              // "LIVE" in production
  fields: {
    cardNumber: { selector: "#card-number", placeholder: "Card number" },
    expiryDate: { selector: "#expiry",      placeholder: "MM/YY" },
    cvv:        { selector: "#cvv",         placeholder: "CVV", optional: false },
  },
  style: {
    input: {
      fontFamily: "Inter, system-ui, sans-serif",
      fontSize: "16px",
      color: "#141414",
    },
    ":focus": { color: "#5A28FF" },
    ".invalid": { color: "#D42054" },
  },
});
```

{% hint style="danger" %}
The key here is a **single-use token key**, not your API secret. It can create tokens and nothing else, which is why it is safe in a browser. Putting the API secret here would let anyone on the internet move money on your account.
{% endhint %}

## Tokenize

```javascript
document.querySelector("#pay").addEventListener("click", async () => {
  try {
    const result = await instance.tokenize({
      amount: 4999,
      transactionType: "PAYMENT",
      paymentType: "CARD",
      merchantRefNum: `order-${orderId}`,
      customerDetails: {
        billingDetails: {
          country: "CA",
          zip: "M5H 2N2",
          street: "100 Queen Street West",
          city: "Toronto",
          state: "ON",
        },
      },
    });

    // Send to YOUR server — never authorize from the browser.
    await fetch("/api/pay", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ token: result.token, orderId }),
    });
  } catch (err) {
    console.error(err.code, err.detailedMessage);
  }
});
```

## Events

| Event | Fires when | Typical use |
|---|---|---|
| `FieldValueChange` | A field's value changes | Enable or disable the pay button |
| `Valid` | A field becomes valid | Clear an inline error |
| `Invalid` | A field becomes invalid | Show an inline error |
| `FieldsReady` | All iframes have loaded | Remove your loading skeleton |
| `binNotification` | Enough digits to identify the BIN | Show the card brand, or switch currency |

{% hint style="info" %}
`binNotification` was called `badBin` before February 2026. The old name no longer fires — see the [changelog](https://app.gitbook.com/s/mH0d2WOfwPMJtdaq2oGk/).
{% endhint %}

## Apple Pay and Google Pay

Both are configured through the same setup call. Apple Pay button dimensions are configurable, and on iOS 18+ the QR-code scanning flow is supported automatically.

```javascript
const instance = await paysafe.fields.setup(SINGLE_USE_TOKEN_API_KEY, {
  currencyCode: "USD",
  environment: "TEST",
  fields: {
    applePay: {
      selector: "#apple-pay",
      buttonStyle: "black",
      buttonHeight: 48,
      buttonWidth: 240,
    },
    googlePay: {
      selector: "#google-pay",
      buttonOptions: { buttonType: "pay", buttonColor: "black" },
    },
  },
});
```
