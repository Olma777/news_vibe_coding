#!/usr/bin/env bash
cd "$(dirname "$0")/.." || exit 1
source tests/lib.sh
source config.sh

assert_eq "${#TOPICS[@]}" "6" "должно быть 6 тем"

for e in "${TOPICS[@]}"; do
  slug="${e##*|}"
  if ! printf '%s' "$slug" | grep -qE '^[a-z0-9-]+$'; then
    echo "FAIL: невалидный slug [$slug]"; ASSERT_FAILS=$((ASSERT_FAILS+1))
  fi
done

assert_contains "$SOURCES" "reddit" "источники содержат reddit"
assert_eq "$SCHEDULE_HOUR" "8" "час запуска 8"
finish
