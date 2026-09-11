#!/usr/bin/env bash
# Point GitBook at each OpenAPI spec in specs/ and trigger a re-fetch.
#
# The specs are registered by URL against raw.githubusercontent.com, so GitBook
# owns the schedule: it re-fetches every 6 hours on its own. Running this script
# re-issues the registration, which forces an immediate refresh — useful right
# after a merge when you do not want to wait.
#
#   GITBOOK_TOKEN=...  scripts/publish-specs.sh
#
# In CI this is the whole deployment step for the API reference: merge to main,
# run this, and 200 endpoint pages are up to date.

set -euo pipefail
cd "$(dirname "$0")/.."

ORG_ID="${ORG_ID:-kqsYHgfyM6lAFN5jPss0}"
REPO="${REPO:-louissteen/paysafe-developer-portal}"
BRANCH="${BRANCH:-main}"
RAW="https://raw.githubusercontent.com/$REPO/$BRANCH/specs"
TOKEN="${GITBOOK_TOKEN:-$(tr -d '[:space:]' < "$HOME/.gitbook_token" 2>/dev/null || true)}"

if [[ -z "$TOKEN" ]]; then
  echo "error: no token. Set GITBOOK_TOKEN or write one to ~/.gitbook_token" >&2
  exit 1
fi
if ! curl -sf -o /dev/null -H "Authorization: Bearer $TOKEN" https://api.gitbook.com/v1/user; then
  echo "error: GitBook rejected the token (401). Issue a new one under" >&2
  echo "       app.gitbook.com -> Settings -> Developer -> Personal Access Tokens" >&2
  exit 1
fi

fail=0
for f in specs/*.json; do
  slug="$(basename "$f" .json)"

  # The spec must be publicly fetchable for GitBook to read it.
  if ! curl -sf -o /dev/null "$RAW/$slug.json"; then
    printf '  FAIL %-34s not reachable at %s\n' "$slug" "$RAW/$slug.json"
    echo "       (is the repository still public?)"
    fail=1
    continue
  fi

  code=$(curl -s -o /tmp/gb-spec.out -w '%{http_code}' -X PUT \
    -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" \
    -d "{\"source\":{\"url\":\"$RAW/$slug.json\"}}" \
    "https://api.gitbook.com/v1/orgs/$ORG_ID/openapi/$slug")

  if [[ "$code" == "200" || "$code" == "201" ]]; then
    printf '  ok   %s\n' "$slug"
  else
    printf '  FAIL %-34s HTTP %s\n' "$slug" "$code"
    sed -n '1,3p' /tmp/gb-spec.out
    fail=1
  fi
done

echo
echo "Processing state (re-run in a few seconds if any are still 'pending'):"
curl -s -H "Authorization: Bearer $TOKEN" \
  "https://api.gitbook.com/v1/orgs/$ORG_ID/openapi" \
| python3 -c "
import json,sys
for s in sorted(json.load(sys.stdin).get('items',[]), key=lambda x: x['slug']):
    print(f\"  {s['slug']:34s} {s['processingState']:10s} errors={s.get('lastProcessedErrorCount',0)}\")"

exit $fail
