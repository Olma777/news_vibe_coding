#!/usr/bin/env bash
cd "$(dirname "$0")/.." || exit 1
source tests/lib.sh
source config.sh
source lib.sh

OUT="$(mktemp -d)"
trap 'rm -rf "$OUT"' EXIT

# Фейковые брифы для всех 6 тем — по одному буллету.
for e in "${TOPICS[@]}"; do
  name="${e%%|*}"; slug="${e##*|}"
  printf -- '- top story about %s\n\nbody text\n' "$name" > "$OUT/$slug.md"
done

aggregate_daily "$OUT" "2026-06-09"

assert_file_contains "$OUT/_daily.md" "## Главное за день" "есть TL;DR-секция"
assert_file_contains "$OUT/_daily.md" "News Vibe Digest — 2026-06-09" "есть заголовок с датой"
for e in "${TOPICS[@]}"; do
  name="${e%%|*}"
  assert_file_contains "$OUT/_daily.md" "## $name" "секция темы: $name"
done
finish
