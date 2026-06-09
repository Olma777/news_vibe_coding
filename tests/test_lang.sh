#!/usr/bin/env bash
cd "$(dirname "$0")/.." || exit 1
source tests/lib.sh
source lib.sh

# lang_targets: какие языки слать
DIGEST_LANG=ru;   assert_eq "$(lang_targets)" "ru" "ru → ru"
DIGEST_LANG=en;   assert_eq "$(lang_targets)" "en" "en → en"
DIGEST_LANG=both; assert_eq "$(lang_targets)" "ru en" "both → ru en"
DIGEST_LANG=xx;   assert_eq "$(lang_targets)" "ru" "неизвестное → ru (fallback)"

# brief_lang: язык брифов (both → en как нейтральная база)
DIGEST_LANG=ru;   assert_eq "$(brief_lang)" "ru" "brief ru"
DIGEST_LANG=en;   assert_eq "$(brief_lang)" "en" "brief en"
DIGEST_LANG=both; assert_eq "$(brief_lang)" "en" "brief both → en"

# lang_clause: инструкция языка вывода
assert_contains "$(lang_clause ru)" "русск" "ru clause — кириллица"
assert_contains "$(lang_clause en)" "English" "en clause — English"
finish
