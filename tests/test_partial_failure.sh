#!/usr/bin/env bash
cd "$(dirname "$0")/.." || exit 1
export RETRY_SLEEP=0   # без задержек в тесте
source tests/lib.sh
source config.sh
source lib.sh

OUT="$(mktemp -d)"
trap 'rm -rf "$OUT"' EXIT

# Мок: codex и cursor «падают», остальные пишут бриф.
run_topic() {
  local slug="$1" name="$2" outdir="$3"
  case "$slug" in
    codex|cursor) return 1 ;;
    *) printf -- '- top item for %s\n' "$name" > "$outdir/$slug.md"; return 0 ;;
  esac
}

ok="$(run_all "$OUT")"
assert_eq "$ok" "4" "4 темы успешны, 2 упали"

aggregate_daily "$OUT" "2026-06-09"
assert_file_contains "$OUT/_daily.md" "## vibe coding" "успешная тема в дайджесте"
# упавшие темы не должны иметь секции
if grep -qF "## Codex" "$OUT/_daily.md"; then
  echo "FAIL: упавшая тема Codex попала в дайджест"; ASSERT_FAILS=$((ASSERT_FAILS+1))
fi
finish
