#!/usr/bin/env bash
cd "$(dirname "$0")/.." || exit 1
source tests/lib.sh
source lib.sh

export DRY_RUN=1

# МНОГОСТРОЧНЫЙ кириллический ввод (1000 строк) → усечение до 3500 ЗНАКОВ
# через весь текст. Ловит сразу два регресса:
#  - cut -c режет по строкам (не усекает многострочный текст вообще);
#  - head -c режет по байтам (кириллица = 2 байта/символ → len≠3500).
long="$(python3 -c "print('\n'.join(['тест строка']*1000))")"   # 1000 коротких строк, кириллица
out_msg="$(tg_send_message "TOK" "12345" "$long")"
assert_contains "$out_msg" "DRYRUN sendMessage" "dry-run печатает sendMessage"
assert_contains "$out_msg" "chat=12345" "правильный chat_id"
assert_contains "$out_msg" "len=3500" "текст обрезан до 3500 знаков через весь текст"

out_doc="$(tg_send_document "TOK" "12345" "/tmp/x.md")"
assert_contains "$out_doc" "DRYRUN sendDocument" "dry-run печатает sendDocument"
assert_contains "$out_doc" "file=/tmp/x.md" "правильный путь файла"
finish
