#!/usr/bin/env bash
set -euo pipefail

ROOT="/home/mo/sofoyo/www"
MDB="$ROOT/Databases/lskajdflkjasdf.mdb"
OUT="$ROOT/legacy_export/db"
STATE="$ROOT/legacy_export/state/db_export.env"
REPORTS="$ROOT/legacy_export/reports"
mkdir -p "$OUT/csv" "$OUT/schema" "$OUT/meta" "$(dirname "$STATE")" "$REPORTS"

[[ -f "$STATE" ]] && source "$STATE"
: "${INDEX:=0}"

mapfile -t TABLES < <(mdb-tables -1 "$MDB")

save_state(){
  cat > "$STATE" <<EOF
INDEX=$INDEX
UPDATED_AT=$(date +%s)
EOF
}

log="$REPORTS/db_export_$(date +%F_%H%M%S).log"

echo "[info] tables=${#TABLES[@]} start_index=$INDEX" | tee -a "$log"

# schema (single file)
if [[ ! -f "$OUT/schema/schema.postgres.sql" ]]; then
  timeout 540 mdb-schema "$MDB" postgres > "$OUT/schema/schema.postgres.sql"
fi

for ((i=INDEX; i<${#TABLES[@]}; i++)); do
  t="${TABLES[$i]}"
  safe="$(echo "$t" | tr ' /' '__')"
  echo "[start] ($((i+1))/${#TABLES[@]}) $t" | tee -a "$log"

  timeout 540 mdb-export -I postgres -Q "$MDB" "$t" > "$OUT/csv/${safe}.csv"

  # row count quick check (minus header)
  rows=$(awk 'END{print NR>0?NR-1:0}' "$OUT/csv/${safe}.csv" 2>/dev/null || echo 0)
  printf '%s,%s\n' "$t" "$rows" >> "$OUT/meta/table_rows.csv"

  INDEX=$((i+1))
  save_state
  echo "[done] $t rows=$rows" | tee -a "$log"
done

# manifest
python3 - <<'PY'
import csv, json, os, time
root='/home/mo/sofoyo/www/legacy_export/db'
rows=[]
path=os.path.join(root,'meta','table_rows.csv')
if os.path.exists(path):
    with open(path,'r',encoding='utf-8',errors='ignore') as f:
        for line in f:
            line=line.strip()
            if not line or ',' not in line: continue
            t,r=line.split(',',1)
            rows.append({'table':t,'rows':int(r) if r.isdigit() else r})
manifest={
  'generatedAt': int(time.time()),
  'csvDir': os.path.join(root,'csv'),
  'schema': os.path.join(root,'schema','schema.postgres.sql'),
  'tables': rows,
  'tableCount': len(rows)
}
with open(os.path.join(root,'meta','manifest.json'),'w',encoding='utf-8') as f:
    json.dump(manifest,f,ensure_ascii=False,indent=2)
print('manifest written')
PY

echo "ALL_DONE log=$log state=$STATE"
