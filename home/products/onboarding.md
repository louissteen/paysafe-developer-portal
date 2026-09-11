---
description: >-
  Board and underwrite your own sub-merchants, white-labelled or through a
  ready-made form.
icon: id-card
---

# Onboarding

If you are a marketplace, platform or payment facilitator, you take on merchants of your own. Paysafe can underwrite and board them for you — either behind your own UI, or through a hosted form.

## Two routes

{% columns %}
{% column width="50%" %}
### Applications API

A fully white-labelled flow. You collect business details, ownership and documents in your own interface and submit them over REST. Supports bulk submission for platforms boarding hundreds of merchants at a time.

**Choose this when** onboarding is part of your product experience and you want to control every screen.
{% endcolumn %}

{% column width="50%" %}
### Simplified Onboarding

A ready-made application form hosted by Paysafe. Send merchants a link; track decisions in the Merchant Portal. No development work at all.

**Choose this when** you want to start boarding merchants this week.
{% endcolumn %}
{% endcolumns %}

## Underwriting states

An application moves through a fixed set of states. Your webhook receives an event on every transition.

| State | Meaning | Your next action |
|---|---|---|
| `DRAFT` | Created but not yet submitted | Collect remaining fields |
| `SUBMITTED` | With underwriting | Wait — no action needed |
| `PENDING_DOCUMENTS` | More evidence required | Upload the requested documents |
| `APPROVED` | Boarded; a sub-merchant account exists | Start processing |
| `DECLINED` | Not approved | Inform the merchant; reasons are in the response |
| `WITHDRAWN` | Cancelled before decision | None |

{% hint style="info" %}
Before boarding a merchant, screen them with a **termination inquiry** — it checks Mastercard MATCH Pro and the Visa Terminated Merchant File. Boarding a listed merchant can put your own account at risk.
{% endhint %}

<table data-view="cards"><thead><tr><th></th><th></th><th data-hidden data-card-target data-type="content-ref"></th></tr></thead><tbody><tr><td><strong>Applications API</strong></td><td>25 endpoints — applications, businesses, owners, documents, sub-merchants.</td><td><a href="https://app.gitbook.com/s/XSPACE_APIS/applications-api/">Applications API</a></td></tr><tr><td><strong>Simplified Onboarding</strong></td><td>The no-code route, end to end.</td><td><a href="https://app.gitbook.com/s/XSPACE_SUPPORT/guides/simplified-onboarding.md">Simplified Onboarding</a></td></tr></tbody></table>
