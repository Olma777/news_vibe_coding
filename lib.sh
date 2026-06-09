# shellcheck shell=bash
# Чистые функции обёртки. Сеть только в tg_* и только при DRY_RUN!=1.

# Язык дайджеста: ru | en | both. Канонически задаётся в config.sh; здесь — дефолт.
DIGEST_LANG="${DIGEST_LANG:-ru}"

# Языки доставки в Telegram: на каких языках слать дайджест.
lang_targets() {
  case "$DIGEST_LANG" in
    both) echo "ru en" ;;
    en)   echo "en" ;;
    *)    echo "ru" ;;
  esac
}

# Язык брифов тем: для both берём en как нейтральную базу (summarize переведёт).
brief_lang() {
  case "$DIGEST_LANG" in
    en|both) echo "en" ;;
    *)       echo "ru" ;;
  esac
}

# Инструкция языка вывода для промпта claude. Аргумент: ru | en.
lang_clause() {
  case "$1" in
    en) echo "Write the result in English." ;;
    *)  echo "Пиши результат на русском языке." ;;
  esac
}

# Собирает сводный _daily.md из per-topic брифов, лежащих в OUTDIR/<slug>.md.
# Темы без файла (упавшие) пропускаются. Аргументы: OUTDIR DATE.
# Требует глобального массива TOPICS (source config.sh).
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
  # Усечение до TG_LIMIT СИМВОЛОВ через весь текст (многострочный), UTF-8-safe.
  # python3 надёжен и на macOS, и на ubuntu-CI; cut -c режет по строкам (баг),
  # head -c режет по байтам (ломает кириллицу) — оба не годятся.
  text="$(printf '%s' "$text" | TG_LIMIT="$TG_LIMIT" python3 -c \
    'import os,sys; sys.stdout.write(sys.stdin.read()[:int(os.environ["TG_LIMIT"])])')"
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

# Пауза между retry (сек). В тестах переопределяется RETRY_SLEEP=0.
RETRY_SLEEP="${RETRY_SLEEP:-30}"

# Дефолтная заглушка. Переопределяется в run_digest.sh (реальный claude)
# и в тестах (мок). Существует, чтобы run_all всегда имел что вызвать.
run_topic() {
  echo "run_topic not implemented (override me)" >&2
  return 99
}

# Прогон всех тем с per-topic isolation + 1 retry на тему.
# Падение одной темы не рушит прогон. Печатает в stdout число успешных.
# Аргумент: OUTDIR. Требует глобального массива TOPICS (source config.sh).
run_all() {
  local outdir="$1" ok=0 e name slug
  for e in "${TOPICS[@]}"; do
    name="${e%%|*}"; slug="${e##*|}"
    if run_topic "$slug" "$name" "$outdir" >&2; then
      ok=$((ok+1))
    else
      echo "RETRY $slug" >&2
      sleep "$RETRY_SLEEP"
      if run_topic "$slug" "$name" "$outdir" >&2; then
        ok=$((ok+1))
      else
        echo "FAIL $slug" >&2
      fi
    fi
  done
  echo "$ok"
}
