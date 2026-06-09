#!/usr/bin/env bash
cd "$(dirname "$0")/.." || exit 1
source tests/lib.sh
source lib.sh

ROOT="$(mktemp -d)"
trap 'rm -rf "$ROOT"' EXIT
mkdir -p "$ROOT/digests/2026-06-08" "$ROOT/digests/2026-06-09" "$ROOT/digests/2026-06-07"

regen_index "$ROOT/digests" "$ROOT/index.md"

assert_file_contains "$ROOT/index.md" "2026-06-09" "индекс содержит свежую дату"
assert_file_contains "$ROOT/index.md" "2026-06-07" "индекс содержит старую дату"
assert_file_contains "$ROOT/index.md" "digests/2026-06-09/_daily.html" "ссылка на .html (Jekyll)"

# обратный хронологический порядок: 09 раньше 07 в файле
line09="$(grep -n '2026-06-09' "$ROOT/index.md" | head -1 | cut -d: -f1)"
line07="$(grep -n '2026-06-07' "$ROOT/index.md" | head -1 | cut -d: -f1)"
if [ "$line09" -ge "$line07" ]; then
  echo "FAIL: порядок не обратный (09 строка $line09, 07 строка $line07)"; ASSERT_FAILS=$((ASSERT_FAILS+1))
fi
finish
