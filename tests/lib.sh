# shellcheck shell=bash
# Минимальные assert-хелперы для bash-тестов (без внешних фреймворков).
ASSERT_FAILS=0

assert_eq() {  # actual expected msg
  if [ "$1" != "$2" ]; then
    echo "FAIL: expected [$2] got [$1] ($3)"; ASSERT_FAILS=$((ASSERT_FAILS+1))
  fi
}

assert_contains() {  # haystack needle msg
  if ! printf '%s' "$1" | grep -qF "$2"; then
    echo "FAIL: [$1] missing [$2] ($3)"; ASSERT_FAILS=$((ASSERT_FAILS+1))
  fi
}

assert_file_contains() {  # file needle msg
  if ! grep -qF "$2" "$1"; then
    echo "FAIL: file $1 missing [$2] ($3)"; ASSERT_FAILS=$((ASSERT_FAILS+1))
  fi
}

finish() {
  if [ "$ASSERT_FAILS" -eq 0 ]; then
    echo "PASS: $0"
  else
    echo "FAILED: $ASSERT_FAILS assertion(s) ($0)"; exit 1
  fi
}
