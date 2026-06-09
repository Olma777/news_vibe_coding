#!/usr/bin/env bash
cd "$(dirname "$0")/.." || exit 1
source tests/lib.sh
assert_eq "a" "a" "eq works"
assert_contains "hello world" "world" "contains works"
finish
