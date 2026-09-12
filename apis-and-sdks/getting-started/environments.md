---
description: Base URLs, what the test environment simulates, and IP allowlisting.
icon: server
---

# Environments

Paysafe runs two environments. They are the same code on separate infrastructure with separate credentials and separate data.

| | Test | Production |
|---|---|---|
| **Base URL** | `https://api.test.paysafe.com` | `https://api.paysafe.com` |
| **Credentials** | Test key pair | Production key pair |
| **Funds** | Never move | Move |
| **Data** | Wiped periodically | Retained |
| **Rate limit** | 20 requests/second | Contracted, typically 100+/second |

{% hint style="warning" %}
Credentials are **not** interchangeable. A production key against the test host returns `401`, not a helpful error.
{% endhint %}

## Base paths by API

| API | Path |
|---|---|
| Payments | `/paymenthub/v1` |
| Payment Handles | `/paymenthub/v1` |
| Cards | `/cardpayments/v1` |
| Customer Vault | `/customervault/v1` |
| 3D Secure | `/threedsecure/v2` |
| Embedded Wallets | `/embeddedwallets/v1` |
| Digital Wallets | `/digitalwallets/v1` |
| Applications | `/applications/v1` |

## What test does not reproduce

{% hint style="warning" %}
* **Settlement timing.** Instant in test. ACH, EFT and SEPA take days in production.
* **Issuer decisions.** Real declines come from the cardholder's bank. Test declines are deterministic.
* **Interchange and scheme fees.** Not calculated.
* **Throughput.** Test limits are lower — never size capacity from test.
* **3-D Secure challenge UX.** Test uses a stub ACS, not the cardholder's real bank screen.
{% endhint %}

## Network access

Outbound calls go to the base URLs above over TLS 1.2+. Paysafe does not publish a static IP range for inbound API calls, so allowlisting by hostname is the supported approach.

For **webhooks**, Paysafe calls your endpoint from a published set of ranges. Request the current list from support before you configure a firewall rule, and verify the signature on every delivery rather than relying on source IP alone — see [Handling webhooks](https://app.gitbook.com/s/s32UcT9FwtQGR4UN7RvJ/tutorials/handling-webhooks.md).

## Status

Platform status and incident history are published at [status.paysafe.com](https://www.paysafe.com/en/). Subscribe there rather than polling an API endpoint for health.
