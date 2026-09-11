---
description: >-
  Tutorials, integration guides and the reference tables you will keep coming
  back to.
icon: life-ring
---

# Support & Resources

Everything that is not an API reference: task-shaped tutorials, guides for the decisions you make once, and the lookup tables you need at three in the morning.

## Tutorials

Follow these end to end. Each one produces something that works.

<table data-view="cards"><thead><tr><th></th><th></th><th data-hidden data-card-target data-type="content-ref"></th></tr></thead><tbody><tr><td><strong>Accept a card payment</strong></td><td>From an empty page to an approved authorization, with the client-side capture done properly.</td><td><a href="tutorials/accept-a-card-payment.md">Accept a card payment</a></td></tr><tr><td><strong>Recurring payments</strong></td><td>Store a card, flag credentials on file correctly, and bill on a schedule.</td><td><a href="tutorials/recurring-payments.md">Recurring payments</a></td></tr><tr><td><strong>Handling webhooks</strong></td><td>Verify signatures, survive retries and stay idempotent.</td><td><a href="tutorials/handling-webhooks.md">Handling webhooks</a></td></tr></tbody></table>

## Guides

<table data-view="cards"><thead><tr><th></th><th></th><th data-hidden data-card-target data-type="content-ref"></th></tr></thead><tbody><tr><td><strong>Go live checklist</strong></td><td>What to verify before you switch to production credentials.</td><td><a href="guides/going-live.md">Go live checklist</a></td></tr><tr><td><strong>Address Verification Service</strong></td><td>How AVS results work and what to do with each one.</td><td><a href="guides/address-verification-service.md">AVS</a></td></tr><tr><td><strong>Simplified Onboarding</strong></td><td>Board merchants with no development work.</td><td><a href="guides/simplified-onboarding.md">Simplified Onboarding</a></td></tr><tr><td><strong>Testing and simulations</strong></td><td>Test cards, forced declines and what the sandbox does not reproduce.</td><td><a href="guides/testing-and-simulations.md">Testing</a></td></tr></tbody></table>

## Reference information

<table data-view="cards"><thead><tr><th></th><th></th><th data-hidden data-card-target data-type="content-ref"></th></tr></thead><tbody><tr><td><strong>Currency codes</strong></td><td>82 currencies with the exponent that determines the minor unit.</td><td><a href="reference-information/currency-codes.md">Currency codes</a></td></tr><tr><td><strong>Country codes</strong></td><td>249 ISO 3166-1 alpha-2 codes.</td><td><a href="reference-information/country-codes.md">Country codes</a></td></tr><tr><td><strong>State and province codes</strong></td><td>US states and territories, Canadian provinces and territories.</td><td><a href="reference-information/state-codes.md">State codes</a></td></tr><tr><td><strong>Global invalid characters</strong></td><td>Characters rejected in every text field, across every API.</td><td><a href="reference-information/global-invalid-characters.md">Invalid characters</a></td></tr></tbody></table>

## Getting help

| Channel | Use it for | Response |
|---|---|---|
| **AI assistant** | Anything answerable from these docs | Instant |
| [Developer support](https://developer.paysafe.com/en/support/) | Integration problems, sandbox issues | Same business day |
| **Your implementation manager** | Account configuration, payment method enablement | Same business day |
| **Production incidents** | Live payments failing | 24/7 |

{% hint style="info" %}
When you open a ticket, include the `merchantRefNum` **and** the Paysafe `id` of the transaction, plus the environment. It removes an entire round trip.
{% endhint %}
