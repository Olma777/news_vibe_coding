# Чистые функции обёртки. Сеть только в tg_* и только при DRY_RUN!=1.

# Собирает сводный _daily.md из per-topic брифов, лежащих в OUTDIR/<slug>.md.
# Темы без файла (упавшие) пропускаются. Аргументы: OUTDIR DATE.
aggregate_daily() {
  local outdir="$1" date="$2"
  local daily="$outdir/_daily.md"
  {
    printf '# News Vibe Digest — %s\n\n' "$date"
    printf '## Главное за день\n\n'
    local e name slug f teaser
    for e in "${TOPICS[@]}"; do
      name="${e%%|*}"; slug="${e##*|}"; f="$outdir/$slug.md"
      [ -f "$f" ] || continue
      # тизер = первый markdown-буллет, иначе первая непустая строка
      teaser="$(grep -m1 -E '^[-*] ' "$f" | sed -E 's/^[-*] //')"
      [ -n "$teaser" ] || teaser="$(grep -m1 -E '\S' "$f")"
      printf -- '- **%s:** %s\n' "$name" "$teaser"
    done
    printf '\n---\n\n'
    for e in "${TOPICS[@]}"; do
      name="${e%%|*}"; slug="${e##*|}"; f="$outdir/$slug.md"
      [ -f "$f" ] || continue
      printf '## %s\n\n' "$name"
      cat "$f"
      printf '\n'
    done
  } > "$daily"
}
