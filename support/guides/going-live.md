---
description: What to verify before you switch to production credentials.
icon: rocket
---

# Go live checklist

Work through this before the switch, not after. Most production incidents in the first week trace back to one of these.

## Credentials and configuration

* [ ] Production API keys issued and stored in a secret manager — **not** in environment files committed to a repository
* [ ] Test keys removed from production configuration
* [ ] Base URL switched to `https://api.paysafe.com`
* [ ] Paysafe JS or Checkout `environment` set to `LIVE`
* [ ] Key rotation procedure documented and tried once in test

## Payment flow

* [ ] `merchantRefNum` is **deterministic**, derived from your own order id — not a timestamp or a fresh UUID
* [ ] Retries only on `429`, `5xx` and timeouts; never on `4xx`
* [ ] Timeout recovery looks the transaction up by `merchantRefNum` before re-attempting
* [ ] Amounts computed in the minor unit with integer arithmetic, never floating point
* [ ] Decline codes mapped to customer-facing messages
* [ ] Hard declines (`3022`, `3040`) never retried

## Webhooks

* [ ] Endpoint is publicly reachable over HTTPS with a valid certificate
* [ ] Signature verified on **every** delivery, using the raw request body
* [ ] Handler acknowledges within 10 seconds and does its work asynchronously
* [ ] Deduplication on `event.id` with a unique index
* [ ] Alerting on undeliverable events

## Security

* [ ] API secret never reaches a browser or a mobile binary
* [ ] Card data never touches your servers or your logs
* [ ] Logs redact card numbers, CVVs and credentials
* [ ] TLS 1.2 or higher everywhere
* [ ] PCI SAQ completed for your integration type

## Compliance

* [ ] Credentials-on-file consent captured and stored where you can produce it
* [ ] Stored-credential transactions flagged with the correct `type` and `occurrence`
* [ ] 3-D Secure enabled where SCA applies
* [ ] Refund and cancellation policy published

## Operations

* [ ] Reconciliation against settlement reports, running daily
* [ ] Dashboards for approval rate, decline codes and latency
* [ ] Alerting on approval-rate drops, not just errors
* [ ] Runbook for a payment outage, naming who is on call
* [ ] Support knows how to find a transaction by `merchantRefNum`

{% hint style="warning" %}
**Ramp, do not switch.** Send a small percentage of live traffic first and watch the approval rate for a full business day. Real issuer behaviour is the one thing the sandbox cannot show you.
{% endhint %}

## After go-live

{% stepper %}
{% step %}
### Day one

Watch approval rate and decline-code distribution hourly. An unexpected concentration of one code usually means a configuration problem, not fraud.
{% endstep %}

{% step %}
### Week one

Reconcile every day. Confirm settlement amounts match your orders and that refunds appear where you expect.
{% endstep %}

{% step %}
### Month one

Review declines with your implementation manager. Retry timing, network tokens and 3-D Secure configuration are usually worth a few points of approval rate.
{% endstep %}
{% endstepper %}
