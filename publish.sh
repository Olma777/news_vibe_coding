#!/usr/bin/env bash
# Публикует дайджест в web-архив docs/ (источник для GitHub Pages).
# Копирует _daily.md + _telegram_*.md в docs/digests/<date>/ и регенерит docs/index.md.
# Usage: publish.sh <OUTDIR> <DATE>
set -uo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR" || exit 1
# shellcheck disable=SC1091
source lib.sh

OUTDIR="${1:?usage: publish.sh <OUTDIR> <DATE>}"
DATE="${2:?usage: publish.sh <OUTDIR> <DATE>}"

dest="docs/digests/$DATE"
mkdir -p "$dest"
# Jekyll игнорирует файлы на '_', поэтому публикуем без подчёркивания.
# _daily.md → index.md (URL каталога даты), _telegram_<lang>.md → telegram_<lang>.md.
cp "$OUTDIR/_daily.md" "$dest/index.md" 2>/dev/null || true
for f in "$OUTDIR"/_telegram_*.md; do
  [ -e "$f" ] && cp "$f" "$dest/$(basename "$f" | sed 's/^_//')"
done
regen_index "docs/digests" "docs/index.md"
echo "published → $dest"
