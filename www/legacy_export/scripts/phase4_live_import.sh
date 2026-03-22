#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="$ROOT/state/strapi_import.env"

if [[ -f "$ENV_FILE" ]]; then
  # shellcheck disable=SC1090
  source "$ENV_FILE"
fi

: "${STRAPI_URL:=}"
: "${STRAPI_TOKEN:=}"

if [[ -z "$STRAPI_URL" || -z "$STRAPI_TOKEN" ]]; then
  echo "[ERR] missing STRAPI_URL or STRAPI_TOKEN"
  echo "Create $ENV_FILE with:"
  echo "  STRAPI_URL=http://localhost:1337"
  echo "  STRAPI_TOKEN=xxxx"
  exit 1
fi

echo "[INFO] live import start: $(date -Iseconds)"
DRY_RUN=0 STRAPI_URL="$STRAPI_URL" STRAPI_TOKEN="$STRAPI_TOKEN" \
  node "$ROOT/scripts/import_to_strapi.js" --type=all

echo "[INFO] live import done: $(date -Iseconds)"
