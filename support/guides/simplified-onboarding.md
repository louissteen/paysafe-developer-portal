---
description: >-
  Board merchants through a ready-made Paysafe-hosted application form, with no
  development work.
icon: clipboard-check
---

# Simplified Onboarding

Simplified Onboarding is the no-code counterpart to the [Applications API](https://app.gitbook.com/s/YjnAGVmcGiEiZme2Neu4/applications-api/). Paysafe hosts the application form; you send merchants a link and watch decisions land in the Merchant Portal.

## When to choose it

{% columns %}
{% column width="50%" %}
### Simplified Onboarding

* No development work
* Live in days
* Paysafe-branded form
* Decisions tracked in the portal

**Choose this when** onboarding volume is modest, or you want to start before the API integration is built.
{% endcolumn %}

{% column width="50%" %}
### Applications API

* Full white-labelling
* Weeks of integration
* Your UI end to end
* Decisions delivered by webhook

**Choose this when** onboarding is part of your product and you board merchants continuously.
{% endcolumn %}
{% endcolumns %}

## How it works

{% stepper %}
{% step %}
### Request your onboarding link

Your account manager configures a link scoped to your partner account. Every application submitted through it is attributed to you.
{% endstep %}

{% step %}
### Send it to the merchant

The merchant completes the form themselves: business details, beneficial ownership, bank account and supporting documents.
{% endstep %}

{% step %}
### Underwriting reviews

Turnaround depends on risk profile and document completeness — typically two to five business days, longer if evidence is missing.
{% endstep %}

{% step %}
### Track the decision

Applications and their states appear in the Merchant Portal under **Onboarding**. Approved merchants become sub-merchant accounts under your partner account.
{% endstep %}
{% endstepper %}

## What the merchant needs to hand

| Category | Examples |
|---|---|
| Business | Legal name, registration number, trading address, website |
| Ownership | Beneficial owners above the disclosure threshold, with ID |
| Financial | Bank account details, expected monthly volume, average ticket |
| Documents | Certificate of incorporation, recent bank statement, proof of ID |

{% hint style="info" %}
Incomplete documents are the single biggest cause of slow onboarding. Sending merchants the list above **before** they open the form typically halves the time to a decision.
{% endhint %}

## Moving to the API later

Merchants boarded through Simplified Onboarding are ordinary sub-merchants. When you integrate the Applications API afterwards, they appear through the sub-merchant endpoints with no migration — the two routes produce the same accounts.
