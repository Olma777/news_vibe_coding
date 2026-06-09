#!/usr/bin/env bash
cd "$(dirname "$0")/.." || exit 1
source tests/lib.sh
source lib.sh

export DRY_RUN=1

# 8000 кириллических символов → обрезается до 3500 знаков (не байт).
# head -c обрезал бы по байтам (каждый кирилл. символ = 2 байта → len≠3500).
long="$(python3 -c "print('тест'*2000, end='')")"
out_msg="$(tg_send_message "TOK" "12345" "$long")"
assert_contains "$out_msg" "DRYRUN sendMessage" "dry-run печатает sendMessage"
assert_contains "$out_msg" "chat=12345" "правильный chat_id"
assert_contains "$out_msg" "len=3500" "текст обрезан до 3500"

out_doc="$(tg_send_document "TOK" "12345" "/tmp/x.md")"
assert_contains "$out_doc" "DRYRUN sendDocument" "dry-run печатает sendDocument"
assert_contains "$out_doc" "file=/tmp/x.md" "правильный путь файла"
finish
