# Finishing the setup

Everything that GitBook's API can do is done. Two steps remain: one in the
GitBook UI (Git Sync cannot be configured over the API), and one afterwards to
resolve the cross-space links.

| | |
|---|---|
| **Repository** | `louissteen/paysafe-developer-portal` (private) |
| **Branch** | `main` |
| **GitBook site** | Paysafe Developer Portal — `site_V9Mee` |
| **Organization** | Paysafe — `kqsYHgfyM6lAFN5jPss0` |
| **Dashboard** | https://app.gitbook.com/o/kqsYHgfyM6lAFN5jPss0/sites/site_V9Mee |

---

## Step 1 — Connect Git Sync (one connection, not four)

Because the site structure is declared in `gitbook-docs.yaml`, you connect the
**site** to the repo once. GitBook then creates all four spaces and maps each to
its directory automatically.

1. Open the site dashboard:
   **https://app.gitbook.com/o/kqsYHgfyM6lAFN5jPss0/sites/site_V9Mee**
2. Go to **Settings → Git Sync**.
3. Choose **GitHub** and authorize the GitBook app if prompted.
   Grant it access to **`louissteen/paysafe-developer-portal`** — it is a private
   repo, so it must be selected explicitly in the GitHub app permissions screen.
4. Repository: **`louissteen/paysafe-developer-portal`**
5. Branch: **`main`**
6. Project directory: **leave empty** (`gitbook-docs.yaml` is at the repo root).
7. Initial sync direction: **GitHub → GitBook** — the repo is the source of truth.
8. Click **Initialize** and wait for the import.

### What to expect on that first import

GitBook creates four spaces in one merge. Two documented quirks apply:

> **Each new space exports its own empty initial revision back to the repo**, which
> races the import. When the export wins, it overwrites that directory's
> `README.md` with `# Page` and truncates its `SUMMARY.md`.

Check for it once the import settles:

```bash
git pull
git log --oneline | grep "GitBook: Export content from" || echo "no export commits - clean"
git diff HEAD~1 --stat
```

If any `README.md` or `SUMMARY.md` came back blank, restore it and push again:

```bash
git checkout <the-commit-before-the-export> -- home/ apis-and-sdks/ support/ changelog/
git commit -m "Restore content clobbered by initial space export"
git push
```

---

## Step 2 — Resolve the cross-space links

44 links cross a space boundary. They are written as `XSPACE_*` sentinels because
real space ids do not exist until Step 1 creates the spaces.

1. Read the ids back:

```bash
curl -s -H "Authorization: Bearer $(cat ~/.gitbook_token)" \
  "https://api.gitbook.com/v1/orgs/kqsYHgfyM6lAFN5jPss0/sites/site_V9Mee/structure" \
| python3 -c "
import json,sys
def walk(n):
    for x in n:
        if x.get('object')=='site-space': print(f\"  {x['space']['title']:24s} {x['space']['id']}\")
        for k in ('sections','siteSpaces','children'):
            if k in x: walk(x[k])
walk(json.load(sys.stdin).get('structure',{}).get('sections',[]))"
```

2. Paste them into `cross-space-links.yaml`.
3. Run the resolver and push:

```bash
scripts/resolve-cross-space-links.sh
git commit -am "Resolve cross-space link sentinels"
git push
```

Until this runs, those links point at a non-existent space. Everything else works.

> **Resolver lag.** Cross-space content references can take 30+ minutes to start
> resolving, and published pages are cached per content revision — so a page
> rendered before the resolver caught up stays stale. If links still look wrong an
> hour later, make a no-op commit touching the affected space directory to force a
> re-render.

---

## Step 3 — Publish the site

The site is created but **not yet published**. Once the content looks right:

**Site dashboard → Publish**.

---

## The OpenAPI specs — already done

All 8 specs are registered and processed (`complete`, zero errors). They are
registered **by URL** against this repository, so GitBook re-fetches them every
6 hours on its own.

| Spec | Operations |
|---|---|
| `paysafe-payments-v1` | 38 |
| `paysafe-embedded-wallets-v1` | 30 |
| `paysafe-cards-v1` | 29 |
| `paysafe-customer-vault-v1` | 27 |
| `paysafe-applications-v1` | 25 |
| `paysafe-digital-wallets-v1` | 21 |
| `paysafe-threeds-v2` | 16 |
| `paysafe-payment-handles-v1` | 14 |
| **Total** | **200** |

Changing a spec means merging to `main` and waiting, or forcing a refresh:

```bash
scripts/publish-specs.sh
```

Manage them at
https://app.gitbook.com/o/kqsYHgfyM6lAFN5jPss0/openapi

> **The repository must stay public** for URL-based refresh to keep working.
> Making it private again will not break what is already rendered — GitBook keeps
> the last good version — but future refreshes will silently stop.

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
