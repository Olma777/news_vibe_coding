#!/usr/bin/env bash
# Entrypoint ежедневного дайджеста. Запускается launchd или вручную.
set -uo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR" || exit 1
# shellcheck disable=SC1091
[ -f .env ] && { set -a; . ./.env; set +a; }
source config.sh
source lib.sh

: "${TELEGRAM_BOT_TOKEN:?TELEGRAM_BOT_TOKEN missing (см. .env)}"
: "${TELEGRAM_CHAT_ID:?TELEGRAM_CHAT_ID missing (см. .env)}"

DATE="$(date +%F)"
OUTDIR="$DIR/digests/$DATE"
mkdir -p "$OUTDIR"
# дублируем весь вывод в run.log
exec > >(tee -a "$OUTDIR/run.log") 2>&1
echo "=== run $DATE ==="

# Скилл last30days пишет брифы сюда.
export LAST30DAYS_MEMORY_DIR="$OUTDIR"

# Реальный сбор по теме через headless claude + скилл last30days.
# Успех = непустой файл брифа.
run_topic() {
  local slug="$1" name="$2" outdir="$3"
  local brief="$outdir/$slug.md"
  claude -p "Use the last30days skill to research \"$name\" over the last 30 days. \
Free sources only: Reddit, Hacker News, GitHub, YouTube, Polymarket. \
$(lang_clause "$(brief_lang)") Заголовки, текст и раздел Best Takes — на этом языке; \
цитаты/названия источников можно оставить в оригинале, все ссылки сохрани. \
Save the markdown brief to \"$brief\"" \
    --allowedTools "Skill,Bash,WebFetch,WebSearch,Read,Write" \
    --output-format text ${CLAUDE_EXTRA_FLAGS:-}
  [ -s "$brief" ]
}

# Сжимает дневные брифы в компактный читаемый дайджест для Telegram на языке LANG.
# Простой текст ≤3000 символов, голые ссылки (Telegram сам их линкует).
# Пишет в _telegram_<lang>.md. Аргументы: OUTDIR LANG(ru|en).
summarize_telegram() {
  local outdir="$1" lang="${2:-ru}"
  local out="$outdir/_telegram_$lang.md"
  claude -p "Прочитай markdown-брифы тем в каталоге \"$outdir\" (все *.md, КРОМЕ _daily.md, файлов _telegram_* и файлов с '-raw-' в имени). \
Собери ОДИН компактный дайджест для Telegram, не длиннее 3000 символов. $(lang_clause "$lang") \
Формат строго простым текстом (без markdown, без #, без жирного, без таблиц): \
первая строка '📰 News Vibe — $DATE'; пустая строка; затем по каждой теме блок из двух строк — \
'• <Тема>: <1-2 предложения главного за месяц>' и на следующей строке одна ключевая ссылка голым URL. \
Сохрани результат в \"$out\"" \
    --allowedTools "Bash,Read,Write" \
    --output-format text ${CLAUDE_EXTRA_FLAGS:-}
  # запасной вариант, если claude не записал файл
  [ -s "$out" ] || head -c 3000 "$outdir/_daily.md" > "$out"
}

ok="$(run_all "$OUTDIR")"
echo "topics succeeded: $ok"

aggregate_daily "$OUTDIR" "$DATE"

if [ "$ok" -eq 0 ]; then
  tg_send_message "$TELEGRAM_BOT_TOKEN" "$TELEGRAM_CHAT_ID" \
    "⚠️ News Vibe: прогон $DATE провалился — все темы упали. См. run.log"
else
  # на каждый язык — компактный дайджест в чат; полный файл вкладываем один раз
  first=1
  for L in $(lang_targets); do
    summarize_telegram "$OUTDIR" "$L"
    if [ "$first" = 1 ]; then
      ./notify_telegram.sh "$OUTDIR/_telegram_$L.md" "$OUTDIR/_daily.md"
      first=0
    else
      ./notify_telegram.sh "$OUTDIR/_telegram_$L.md"
    fi
  done
fi
echo "=== done ==="
