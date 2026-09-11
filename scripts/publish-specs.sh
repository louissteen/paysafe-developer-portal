#!/usr/bin/env bash
# Register every OpenAPI spec in specs/ with GitBook at organization level.
#
# In production this runs from CI on every merge that touches specs/, which is
# what keeps the rendered reference from ever drifting from the API.
#
#   GITBOOK_TOKEN=...  ORG_ID=...  scripts/publish-specs.sh
#
# Defaults to the Paysafe org and ~/.gitbook_token.

set -euo pipefail
cd "$(dirname "$0")/.."

ORG_ID="${ORG_ID:-kqsYHgfyM6lAFN5jPss0}"
TOKEN="${GITBOOK_TOKEN:-$(tr -d '[:space:]' < "$HOME/.gitbook_token" 2>/dev/null || true)}"

if [[ -z "$TOKEN" ]]; then
  echo "error: no token. Set GITBOOK_TOKEN or write one to ~/.gitbook_token" >&2
  exit 1
fi

if ! curl -sf -o /dev/null -H "Authorization: Bearer $TOKEN" https://api.gitbook.com/v1/user; then
  echo "error: token rejected by GitBook (401). Issue a new one under" >&2
  echo "       app.gitbook.com -> Settings -> Developer -> Personal Access Tokens" >&2
  exit 1
fi

fail=0
for f in specs/*.json; do
  slug="$(basename "$f" .json)"
  ops=$(python3 -c "
import json,sys
d=json.load(open('$f'))
print(sum(1 for p in d['paths'].values() for m in p if m in ('get','post','put','delete','patch')))")

  body=$(python3 -c "
import json
spec=open('$f').read()
print(json.dumps({'source': {'text': spec}}))")

  code=$(curl -s -o /tmp/gb-spec.out -w '%{http_code}' -X PUT \
    -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" \
    --data-binary "$body" \
    "https://api.gitbook.com/v1/orgs/$ORG_ID/openapi/$slug")

  if [[ "$code" == "200" || "$code" == "201" ]]; then
    printf '  ok   %-34s %3s operations\n' "$slug" "$ops"
  else
    printf '  FAIL %-34s HTTP %s\n' "$slug" "$code"
    sed -n '1,3p' /tmp/gb-spec.out
    fail=1
  fi
done

echo
echo "Registered specs:"
curl -s -H "Authorization: Bearer $TOKEN" \
  "https://api.gitbook.com/v1/orgs/$ORG_ID/openapi" \
| python3 -c "
import json,sys
for s in json.load(sys.stdin).get('items',[]):
    print(f\"  {s['slug']:34s} {s['processingState']:12s} errors={s.get('lastProcessedErrorCount',0)}\")"

exit $fail
