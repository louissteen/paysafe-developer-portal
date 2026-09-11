# Paysafe Developer Portal

Source for the Paysafe developer portal, published with [GitBook](https://gitbook.com) via Git Sync.

> **Demo build.** This repository is a proof of concept. All OpenAPI specifications under
> `specs/` contain **dummy data** and describe no live Paysafe system. Reference tables
> (currency, country, province and state codes) and the changelog are real content
> reproduced from `developer.paysafe.com`.

## Layout

This is a monorepo: each top-level content folder is a separate GitBook space, and
`gitbook-docs.yaml` declares how those folders map onto the site's navigation.

| Folder | Site section | Contents |
|---|---|---|
| `home/` | Home | Portal landing page and product overviews |
| `apis-and-sdks/` | APIs & SDKs | Getting started, 8 API references, SDK docs |
| `support/` | Support & Resources | Guides, tutorials, reference codes |
| `changelog/` | Changelog | Dated release notes (GitBook Updates block) |
| `specs/` | — | OpenAPI 3.0 source specs (200 operations total) |

## How the API reference is generated

Endpoint pages are **not** hand-written. Each spec in `specs/` is registered with GitBook
at organization level, and `apis-and-sdks/SUMMARY.md` references it with a
`type: builtin:openapi` block. GitBook expands that into one page per operation, grouped
by tag, at render time.

| Spec | Operations |
|---|---|
| `paysafe-payments-v1` | 38 |
| `paysafe-cards-v1` | 29 |
| `paysafe-embedded-wallets-v1` | 30 |
| `paysafe-customer-vault-v1` | 27 |
| `paysafe-applications-v1` | 25 |
| `paysafe-digital-wallets-v1` | 21 |
| `paysafe-threeds-v2` | 16 |
| `paysafe-payment-handles-v1` | 14 |
| **Total** | **200** |

Each spec is registered with GitBook **by URL**, pointing at this repository's
`raw.githubusercontent.com` path on `main`. GitBook re-fetches every 6 hours, so a
merge to `main` is the whole publishing step — there is nothing to upload.

To force an immediate refresh instead of waiting:

```bash
scripts/publish-specs.sh
```

In CI that runs on every merge touching `specs/`, so the 200-endpoint reference
cannot drift from the specs.

> **This repository is public** because GitBook has to be able to fetch the specs
> over plain HTTPS. Nothing here is confidential: the specs are fabricated and the
> prose is reproduced from Paysafe's own public documentation. If it is ever made
> private again, spec refreshes will start failing — switch those registrations to
> direct upload at that point.

## Editing

Content is GitBook-flavoured Markdown. Edits flow both ways once Git Sync is configured —
changes made in the GitBook editor arrive here as commits, so **always pull before you
push**.
