#!/usr/bin/env bash
# Replace XSPACE_* sentinels with real GitBook space ids.
#
# Usage: scripts/resolve-cross-space-links.sh
# Reads the id map from cross-space-links.yaml. Refuses to run if any id is blank.

set -euo pipefail
cd "$(dirname "$0")/.."

declare -a KEYS=(XSPACE_HOME XSPACE_APIS XSPACE_SUPPORT XSPACE_CHANGELOG)
declare -a SED_ARGS=()

for key in "${KEYS[@]}"; do
  id=$(sed -n "s/^  ${key}:[[:space:]]*\"\{0,1\}\([^\"]*\)\"\{0,1\}.*/\1/p" cross-space-links.yaml | head -1)
  if [[ -z "$id" ]]; then
    echo "error: ${key} has no space id in cross-space-links.yaml" >&2
    echo "       read ids from GET /v1/orgs/{orgId}/sites/{siteId}/structure" >&2
    exit 1
  fi
  echo "  ${key} -> ${id}"
  SED_ARGS+=(-e "s|${key}|${id}|g")
done

mapfile -t FILES < <(find . -name '*.md' -not -path './.git/*')
sed -i '' "${SED_ARGS[@]}" "${FILES[@]}"

remaining=$(grep -rl 'XSPACE_' --include='*.md' . | wc -l | tr -d ' ')
echo "done — ${#FILES[@]} files scanned, ${remaining} still containing a sentinel"
