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
  claude -p "Use the last30days skill to research \"$name\" over the last 30 days. \
Free sources only: Reddit, Hacker News, GitHub, YouTube, Polymarket. \
Output a markdown brief with citations and a Best Takes section. \
Save it to $outdir/$slug.md" \
    --allowedTools "Skill,Bash,WebFetch,Read,Write" \
    --output-format text
  [ -s "$outdir/$slug.md" ]
}

ok="$(run_all "$OUTDIR")"
echo "topics succeeded: $ok"

aggregate_daily "$OUTDIR" "$DATE"

if [ "$ok" -eq 0 ]; then
  tg_send_message "$TELEGRAM_BOT_TOKEN" "$TELEGRAM_CHAT_ID" \
    "⚠️ News Vibe: прогон $DATE провалился — все темы упали. См. run.log"
else
  ./notify_telegram.sh "$OUTDIR/_daily.md"
fi
echo "=== done ==="
