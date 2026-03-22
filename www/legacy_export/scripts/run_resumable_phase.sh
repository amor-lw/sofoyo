#!/usr/bin/env bash
set -euo pipefail

ROOT="/home/mo/sofoyo/www"
OUT="$ROOT/legacy_export"
STATE="$OUT/state/checkpoint.env"
LOG="$OUT/reports/run_$(date +%F_%H%M%S).log"

mkdir -p "$OUT/state" "$OUT/reports" "$OUT/site_assets" "$OUT/db" "$OUT/tmp"
[[ -f "$STATE" ]] && source "$STATE"

: "${STEP:=0}"

save_state(){
  cat > "$STATE" <<EOF
STEP=$STEP
UPDATED_AT=$(date +%s)
EOF
}

run_step(){
  local n="$1"; shift
  local name="$1"; shift
  if (( STEP >= n )); then
    echo "[skip] step$n $name" | tee -a "$LOG"
    return 0
  fi
  echo "[start] step$n $name" | tee -a "$LOG"
  timeout 540 "$@" 2>&1 | tee -a "$LOG"
  STEP=$n
  save_state
  echo "[done] step$n $name" | tee -a "$LOG"
}

# Step plan is intentionally fine-grained (< 10 min each)
run_step 1 "copy banner" bash -lc "mkdir -p '$OUT/site_assets/banner' && cp -a '$ROOT/banner/.' '$OUT/site_assets/banner/'"
run_step 2 "copy image" bash -lc "mkdir -p '$OUT/site_assets/image' && cp -a '$ROOT/image/.' '$OUT/site_assets/image/'"
run_step 3 "copy img" bash -lc "mkdir -p '$OUT/site_assets/img' && cp -a '$ROOT/img/.' '$OUT/site_assets/img/'"
run_step 4 "copy propic" bash -lc "mkdir -p '$OUT/site_assets/propic' && cp -a '$ROOT/propic/.' '$OUT/site_assets/propic/'"
run_step 5 "copy uploadpic" bash -lc "mkdir -p '$OUT/site_assets/uploadpic' && cp -a '$ROOT/uploadpic/.' '$OUT/site_assets/uploadpic/'"
run_step 6 "copy uploads" bash -lc "mkdir -p '$OUT/site_assets/uploads' && cp -a '$ROOT/uploads/.' '$OUT/site_assets/uploads/'"
run_step 7 "snapshot checksums" bash -lc "find '$OUT/site_assets' -type f -print0 | xargs -0 sha1sum > '$OUT/reports/site_assets.sha1'"

echo "ALL_DONE log=$LOG state=$STATE"
