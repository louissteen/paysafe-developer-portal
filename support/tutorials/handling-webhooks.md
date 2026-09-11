---
description: >-
  Verify signatures, acknowledge fast, stay idempotent and survive replays.
icon: webhook
---

# Handling webhooks

Webhooks are how you learn about things that happen without a request from you: a held payment released, a refund settled, a chargeback opened, an application decisioned.

{% hint style="warning" %}
**Polling is not a substitute.** Several events — disputes, settlement finalization, underwriting decisions — arrive minutes to days after the original call. Polling for them is expensive and you will still miss edge cases.
{% endhint %}

## Subscribe

```bash
curl -X POST "$PAYSAFE_BASE/paymenthub/v1/webhooks" \
  -u "$PAYSAFE_API_KEY:$PAYSAFE_API_SECRET" \
  -H "Content-Type: application/json" \
  -d '{
    "url": "https://api.example.com/webhooks/paysafe",
    "events": [
      "PAYMENT_COMPLETED", "PAYMENT_FAILED", "PAYMENT_HELD",
      "REFUND_COMPLETED", "SETTLEMENT_COMPLETED", "DISPUTE_OPENED"
    ]
  }'
```

The response contains a **signing secret**. Store it in your secret manager — it is shown once.

## The four rules

{% stepper %}
{% step %}
### Verify the signature before anything else

An unverified webhook is an unauthenticated POST from the internet.

```javascript
app.post("/webhooks/paysafe",
  express.raw({ type: "application/json" }),   // RAW body — not express.json()
  (req, res) => {
    let event;
    try {
      event = paysafe.webhooks.constructEvent(
        req.body,
        req.headers["paysafe-signature"],
        process.env.PAYSAFE_WEBHOOK_SECRET
      );
    } catch {
      return res.sendStatus(400);
    }
    // ...
  });
```

{% hint style="danger" %}
Verification needs the **raw bytes**. A JSON body-parser mounted before this route re-serializes the body and every signature check fails — usually only in production, where a proxy differs from your laptop.
{% endhint %}
{% endstep %}

{% step %}
### Acknowledge immediately, work afterwards

Paysafe expects a `2xx` within **10 seconds**. Do not do the work first.

```javascript
res.sendStatus(200);          // acknowledge
void queue.enqueue(event);    // then process, out of band
```

Slow handlers get retried, which turns one event into many.
{% endstep %}

{% step %}
### Be idempotent

Retries mean you **will** see the same event more than once. Deduplicate on `event.id`.

```javascript
async function handle(event) {
  const inserted = await db.processedEvents.insertIfAbsent(event.id);
  if (!inserted) return;                    // already handled

  switch (event.type) {
    case "PAYMENT_COMPLETED":
      await fulfilOrder(event.data.merchantRefNum);
      break;
    case "DISPUTE_OPENED":
      await freezeOrder(event.data.merchantRefNum);
      break;
  }
}
```

A unique index on the event id makes this correct even with concurrent deliveries.
{% endstep %}

{% step %}
### Do not assume order

Events can arrive out of sequence. A `SETTLEMENT_COMPLETED` may land before the `PAYMENT_COMPLETED` it belongs to.

Drive your state machine from the event's own payload and your stored state — never from "the previous event must have arrived".
{% endstep %}
{% endstepper %}

## Retry schedule

A non-`2xx` or a timeout is retried with exponential backoff:

| Attempt | Delay after previous |
|---|---|
| 1 | immediate |
| 2 | 1 minute |
| 3 | 5 minutes |
| 4 | 30 minutes |
| 5 | 2 hours |
| 6 | 12 hours |

After six failures the event is marked undeliverable. Use the deliveries endpoint to inspect what happened and redeliver by hand.

```bash
curl "$PAYSAFE_BASE/paymenthub/v1/webhooks/$WEBHOOK_ID/deliveries" \
  -u "$PAYSAFE_API_KEY:$PAYSAFE_API_SECRET"
```

## Local development

Your laptop has no public URL. Tunnel instead of weakening verification:

```bash
ngrok http 3000
# then subscribe to https://<id>.ngrok.app/webhooks/paysafe
```

{% hint style="warning" %}
Never add a "skip verification in development" flag. It is the single most common way verification ends up disabled in production.
{% endhint %}
