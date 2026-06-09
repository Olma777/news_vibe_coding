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

# Telegram limit 4096 символов/сообщение; держим запас.
TG_LIMIT=3500

# Отправка текстового сообщения. DRY_RUN=1 → печать вместо сети.
# Аргументы: TOKEN CHAT_ID TEXT.
tg_send_message() {
  local token="$1" chat="$2" text="$3"
  text="$(printf '%s' "$text" | head -c "$TG_LIMIT")"
  if [ "${DRY_RUN:-0}" = "1" ]; then
    printf 'DRYRUN sendMessage chat=%s len=%s\n' "$chat" "${#text}"
    return 0
  fi
  curl -s -o /dev/null -w '%{http_code}' \
    "https://api.telegram.org/bot$token/sendMessage" \
    -d chat_id="$chat" --data-urlencode "text=$text"
}

# Отправка файла-документа. DRY_RUN=1 → печать вместо сети.
# Аргументы: TOKEN CHAT_ID FILEPATH.
tg_send_document() {
  local token="$1" chat="$2" file="$3"
  if [ "${DRY_RUN:-0}" = "1" ]; then
    printf 'DRYRUN sendDocument chat=%s file=%s\n' "$chat" "$file"
    return 0
  fi
  curl -s -o /dev/null -w '%{http_code}' \
    "https://api.telegram.org/bot$token/sendDocument" \
    -F chat_id="$chat" -F document=@"$file"
}
