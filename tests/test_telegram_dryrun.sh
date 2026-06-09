#!/usr/bin/env bash
cd "$(dirname "$0")/.." || exit 1
source tests/lib.sh
source lib.sh

export DRY_RUN=1

# 5000 символов 'x' → должно обрезаться до 3500 в выводе len=
long="$(head -c 5000 /dev/zero | tr '\0' x)"
out_msg="$(tg_send_message "TOK" "12345" "$long")"
assert_contains "$out_msg" "DRYRUN sendMessage" "dry-run печатает sendMessage"
assert_contains "$out_msg" "chat=12345" "правильный chat_id"
assert_contains "$out_msg" "len=3500" "текст обрезан до 3500"

out_doc="$(tg_send_document "TOK" "12345" "/tmp/x.md")"
assert_contains "$out_doc" "DRYRUN sendDocument" "dry-run печатает sendDocument"
assert_contains "$out_doc" "file=/tmp/x.md" "правильный путь файла"
finish
