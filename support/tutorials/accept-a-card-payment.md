---
description: >-
  A complete card payment — client-side capture, server-side authorization and
  the error paths that matter.
icon: credit-card
---

# Accept a card payment

This tutorial builds a working card payment with the card capture done correctly: the number never reaches your server, so you stay at SAQ A.

**Before you start** you need a test account and both keys — the **single-use token key** for the browser and the **API secret** for your server.

{% stepper %}
{% step %}
### Render the fields

Paysafe JS serves each field as an iframe you position in your own form.

```html
<form id="payment-form">
  <div id="card-number" class="field"></div>
  <div id="expiry"      class="field"></div>
  <div id="cvv"         class="field"></div>
  <button id="pay" type="button" disabled>Pay $49.99</button>
</form>

<script src="https://hosted.paysafe.com/js/v1/latest/paysafe.min.js"></script>
```

```javascript
const instance = await paysafe.fields.setup(SINGLE_USE_TOKEN_KEY, {
  currencyCode: "USD",
  environment: "TEST",
  fields: {
    cardNumber: { selector: "#card-number", placeholder: "Card number" },
    expiryDate: { selector: "#expiry",      placeholder: "MM/YY" },
    cvv:        { selector: "#cvv",         placeholder: "CVV" },
  },
});

instance.fields().on("Valid Invalid", () => {
  document.querySelector("#pay").disabled = !instance.fields().valid();
});
```
{% endstep %}

{% step %}
### Tokenize in the browser

```javascript
document.querySelector("#pay").addEventListener("click", async () => {
  const result = await instance.tokenize({
    amount: 4999,
    transactionType: "PAYMENT",
    paymentType: "CARD",
    merchantRefNum: `order-${orderId}`,
    customerDetails: {
      billingDetails: {
        country: "CA", zip: "M5H 2N2",
        street: "100 Queen Street West", city: "Toronto", state: "ON",
      },
    },
  });

  await fetch("/api/pay", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ token: result.token, orderId }),
  });
});
```

{% hint style="danger" %}
Do **not** authorize from the browser. The token is not a payment — anyone can call your endpoint with a token, so your server must decide the amount from the order, never from the request body.
{% endhint %}
{% endstep %}

{% step %}
### Authorize on your server

```javascript
app.post("/api/pay", async (req, res) => {
  const { token, orderId } = req.body;

  // Amount comes from YOUR database, never from the client.
  const order = await db.orders.findById(orderId);
  if (!order || order.status !== "pending") {
    return res.status(409).json({ error: "Order not payable" });
  }

  try {
    const payment = await paysafe.payments.create({
      merchantRefNum: `order-${orderId}`,   // deterministic — retry-safe
      amount: order.amountMinor,
      currencyCode: order.currency,
      paymentHandleToken: token,
      settleWithAuth: true,
    });

    if (payment.status === "COMPLETED") {
      await db.orders.markPaid(orderId, payment.id);
      return res.json({ ok: true });
    }
    return res.status(202).json({ ok: false, status: payment.status });

  } catch (err) {
    if (err.status === 402) {
      return res.status(402).json({ error: declineMessage(err.code) });
    }
    if (err.status === 409) {
      // Same merchantRefNum — already paid. Not an error.
      return res.json({ ok: true, duplicate: true });
    }
    throw err;
  }
});
```
{% endstep %}

{% step %}
### Handle declines usefully

```javascript
function declineMessage(code) {
  switch (code) {
    case "3023": return "There aren't enough funds available on this card.";
    case "3022": return "This card can't be used. Please try another.";
    case "3024": return "Your bank is temporarily unavailable. Try again shortly.";
    case "3082": return "Your bank needs to verify this payment.";
    default:     return "Your bank declined this payment. Please try another card.";
  }
}
```

{% hint style="warning" %}
Never show the raw `error.message` to a customer. It is written for developers and occasionally leaks detail that helps card testers.
{% endhint %}
{% endstep %}

{% step %}
### Confirm out of band

The API response tells you what happened **now**. A webhook tells you what happened **eventually** — including for payments that went to `PENDING` or were held for review.

Treat the webhook as authoritative for fulfilment. See [Handling webhooks](handling-webhooks.md).
{% endstep %}
{% endstepper %}

## Test it

| Card | Expect |
|---|---|
| `4111 1111 1111 1111` | `COMPLETED` |
| `4000 0000 0000 0002` | `402`, code `3023` |
| `4000 0000 0000 0069` | `402`, expired card |
| `4000 0000 0000 3220` | 3-D Secure challenge |

Then check the retry path: kill the connection mid-request and confirm that re-posting the same `orderId` returns the original result rather than charging twice.
