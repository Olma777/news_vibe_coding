#!/usr/bin/env bash
# Шлёт дайджест в Telegram: читаемое сообщение в чат + полный файл документом.
# Usage: notify_telegram.sh <message.md> [document.md]
#   message.md  — компактный текст в тело сообщения (усекается до лимита).
#   document.md — опциональный полный файл вложением.
set -uo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR" || exit 1
# shellcheck disable=SC1091
[ -f .env ] && { set -a; . ./.env; set +a; }
source lib.sh

MSG="${1:?usage: notify_telegram.sh <message.md> [document.md]}"
DOC="${2:-}"
: "${TELEGRAM_BOT_TOKEN:?TELEGRAM_BOT_TOKEN missing (см. .env)}"
: "${TELEGRAM_CHAT_ID:?TELEGRAM_CHAT_ID missing (см. .env)}"

tg_send_message "$TELEGRAM_BOT_TOKEN" "$TELEGRAM_CHAT_ID" "$(cat "$MSG")"
[ -n "$DOC" ] && tg_send_document "$TELEGRAM_BOT_TOKEN" "$TELEGRAM_CHAT_ID" "$DOC"
