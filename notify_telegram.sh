#!/usr/bin/env bash
# Шлёт _daily.md в Telegram: TL;DR текстом + файл документом.
# Usage: notify_telegram.sh <path-to-_daily.md>
set -uo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR" || exit 1
# shellcheck disable=SC1091
[ -f .env ] && { set -a; . ./.env; set +a; }
source lib.sh

DAILY="${1:?usage: notify_telegram.sh <path-to-_daily.md>}"
: "${TELEGRAM_BOT_TOKEN:?TELEGRAM_BOT_TOKEN missing (см. .env)}"
: "${TELEGRAM_CHAT_ID:?TELEGRAM_CHAT_ID missing (см. .env)}"

tg_send_message "$TELEGRAM_BOT_TOKEN" "$TELEGRAM_CHAT_ID" "$(head -c 3500 "$DAILY")"
tg_send_document "$TELEGRAM_BOT_TOKEN" "$TELEGRAM_CHAT_ID" "$DAILY"
