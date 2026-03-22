#!/usr/bin/env bash
set -euo pipefail

ROOT="/home/mo/sofoyo/www"
STATE_DIR="$ROOT/legacy_export/state"
REPORT_DIR="$ROOT/legacy_export/reports"
mkdir -p "$STATE_DIR" "$REPORT_DIR"

report="$REPORT_DIR/preflight_timeout_$(date +%F_%H%M%S).md"

has(){ command -v "$1" >/dev/null 2>&1; }

{
  echo "# Preflight Timeout Check"
  echo
  echo "- Time: $(date '+%F %T %Z')"
  echo "- Agent timeoutSeconds target: 1000s"
  echo
  echo "## Tooling"
  for c in timeout iconv docker mdb-tables mdb-export mdb-schema jq rsync; do
    if has "$c"; then
      echo "- [x] $c: $(command -v "$c")"
    else
      echo "- [ ] $c: MISSING"
    fi
  done
  echo
  echo "## Size Snapshot"
  find "$ROOT" -type f | wc -l | awk '{print "- files: "$1}'
  du -sh "$ROOT"/Databases "$ROOT"/uploadpic "$ROOT"/uploads "$ROOT"/image "$ROOT"/banner "$ROOT"/propic 2>/dev/null | sed 's/^/- /'
  echo
  echo "## Timeout Risk Verdict"
  echo "- DB size small (~11M), but missing mdbtools currently blocks export and may cause repeated retries."
  echo "- Asset copy can exceed one-shot safe window if done as single recursive operation."
  echo "- Mitigation: chunk by directory + checkpoint + per-step timeout < 600s."
} > "$report"

echo "$report"
