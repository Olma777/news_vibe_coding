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
Write the brief IN RUSSIAN (на русском языке): заголовки, текст и раздел Best Takes — по-русски; \
цитаты/названия источников можно оставить в оригинале, все ссылки сохрани. \
Save the markdown brief to \"$brief\"" \
    --allowedTools "Skill,Bash,WebFetch,WebSearch,Read,Write" \
    --output-format text ${CLAUDE_EXTRA_FLAGS:-}
  [ -s "$brief" ]
}

# Сжимает дневные брифы в компактный читаемый дайджест для Telegram.
# Русский, простой текст ≤3000 символов, голые ссылки (Telegram сам их линкует).
# Гарантирует русскоязычный результат независимо от языка брифов скилла.
summarize_telegram() {
  local outdir="$1"
  claude -p "Прочитай markdown-брифы тем в каталоге \"$outdir\" (все *.md, КРОМЕ _daily.md, _telegram.md и файлов с '-raw-' в имени). \
Собери ОДИН компактный дайджест на русском языке для Telegram, не длиннее 3000 символов. \
Формат строго простым текстом (без markdown, без #, без жирного, без таблиц): \
первая строка '📰 News Vibe — $DATE'; пустая строка; затем по каждой теме блок из двух строк — \
'• <Тема>: <1-2 предложения главного за месяц>' и на следующей строке одна ключевая ссылка голым URL. \
Сохрани результат в \"$outdir/_telegram.md\"" \
    --allowedTools "Bash,Read,Write" \
    --output-format text ${CLAUDE_EXTRA_FLAGS:-}
  # запасной вариант, если claude не записал файл
  [ -s "$outdir/_telegram.md" ] || head -c 3000 "$outdir/_daily.md" > "$outdir/_telegram.md"
}

ok="$(run_all "$OUTDIR")"
echo "topics succeeded: $ok"

aggregate_daily "$OUTDIR" "$DATE"

if [ "$ok" -eq 0 ]; then
  tg_send_message "$TELEGRAM_BOT_TOKEN" "$TELEGRAM_CHAT_ID" \
    "⚠️ News Vibe: прогон $DATE провалился — все темы упали. См. run.log"
else
  # компактный читаемый дайджест в чат + полный файл вложением
  summarize_telegram "$OUTDIR"
  ./notify_telegram.sh "$OUTDIR/_telegram.md" "$OUTDIR/_daily.md"
fi
echo "=== done ==="
