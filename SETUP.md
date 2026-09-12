# Setup — complete

The site is live, synced and published. This file is now a record of how it is
wired and what to do when you change things.

| | |
|---|---|
| **Live site** | https://paysafe.gitbook.io/paysafe-docs/ |
| **Repository** | `louissteen/paysafe-developer-portal` (public) |
| **Branch** | `main` |
| **GitBook site** | `site_gP85b` |
| **Organization** | Paysafe — `kqsYHgfyM6lAFN5jPss0` |
| **Dashboard** | https://app.gitbook.com/o/kqsYHgfyM6lAFN5jPss0/sites/site_gP85b |

## How it is wired

**Git Sync** connects the site to the repo once, at site level. `gitbook-docs.yaml`
declares the sections and spaces, so GitBook created all four spaces itself and
maps each to its directory. Editing is two-way: UI edits arrive here as commits.

| Space | Directory | Space id |
|---|---|---|
| Home | `./home` | `VQHBBY7AKKsm5pK8l7Ix` |
| APIs & SDKs | `./apis-and-sdks` | `YjnAGVmcGiEiZme2Neu4` |
| Support & Resources | `./support` | `s32UcT9FwtQGR4UN7RvJ` |
| Changelog | `./changelog` | `mH0d2WOfwPMJtdaq2oGk` |

**OpenAPI specs** are registered at organization level by URL, pointing at this
repo's raw files on `main`. GitBook re-fetches every 6 hours.

## Changing things

```bash
# content, structure or specs — just merge
git push origin main

# force an immediate spec refresh instead of waiting up to 6 hours
scripts/publish-specs.sh
```

> **Always `git pull` before you push.** Git Sync is two-way: edits made in the
> GitBook UI arrive here as commits, and pushing stale files over them erases
> that work silently.

## Three things that bit us, so they do not bite again

1. **Exactly one section needs `default: true`** in `gitbook-docs.yaml` — the one
   served at the site root. Zero or two fails the whole sync with
   *"Site configs with sections must include exactly one section with default: true"*.
   The `default: true` on a *space* is unrelated (it picks the default variant).

2. **`.gitbook/tags.yaml` is a bare array**, not an object with a `tags:` key.
   Entries are `tag` / `label` / `icon` — there is no `color` field. The wrong
   shape fails only that space, so the rest of the site syncs and it looks like
   the changelog is merely empty.

3. **Cross-space links need real space ids**, which only exist after the first
   sync. They are written as `XSPACE_*` sentinels and resolved afterwards with
   `scripts/resolve-cross-space-links.sh` (ids live in `cross-space-links.yaml`).
   Already done — the table above is the record.

---

## Notes for the Paysafe conversation

* **This repo is on GitHub; Saurabh asked about GitLab.** Git Sync works
  identically against GitLab — same file layout, same `gitbook-docs.yaml`, same
  one-connection flow. Only Step 1 changes (choose GitLab instead of GitHub).
* **The second site** — the gated internal API catalog — is not built here. It
  would be a separate GitBook site with `visibility: visitor-auth` and SAML SSO,
  and can share this repo or use its own.
* **Every OpenAPI spec in `specs/` is fabricated.** The reference tables
  (82 currencies, 249 countries, 13 provinces, 62 states, invalid characters)
  and all 40 changelog entries are real content from developer.paysafe.com.
