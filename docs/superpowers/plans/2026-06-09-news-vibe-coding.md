# News Vibe Coding — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Ежедневный автоматический дайджест новостей по 6 темам (vibe coding, Claude Code, AI agents, LLM research, Cursor, Codex) поверх агентного скилла `last30days-skill`, с доставкой в файлы проекта и Telegram.

**Architecture:** macOS `launchd` раз в сутки запускает `run_digest.sh`. Скрипт последовательно прогоняет каждую тему через headless `claude -p` (скилл `last30days`, только бесплатные источники), пишет per-topic markdown в `digests/<date>/`, структурно собирает сводный `_daily.md` и шлёт его в Telegram. Чистые функции (config, агрегация, telegram-payload) вынесены в `lib.sh` и покрыты bash-тестами без сети.

**Tech Stack:** bash, `curl` (Telegram Bot API), `claude` CLI (headless), macOS `launchd`. Зависимость для самого сбора — установленный скилл `mvanhorn/last30days-skill` (+ его тулзы: `yt-dlp`, node — для YouTube/прочего).

**Важно про пути:** если путь к проекту содержит пробел, все пути в скриптах ОБЯЗАТЕЛЬНО в кавычках (`"$DIR"`, `"$OUTDIR"`).

**Отклонения от спеки (зона технических решений):**
- `config.yaml` → `config.sh` (sourceable bash-массив) — без зависимости `yq`.
- TL;DR в `_daily.md` собирается структурно (первый буллет каждой темы), без отдельного `claude -p`. Детерминированно и тестируемо.

---

## Файловая структура

| Файл | Ответственность |
|---|---|
| `config.sh` | Список тем (`name|slug`), источники, час/минута расписания. Sourceable. |
| `lib.sh` | Чистые функции: `aggregate_daily`, `tg_send_message`, `tg_send_document`, `run_all`, дефолтный `run_topic`. Без побочной сети при `DRY_RUN=1`. |
| `run_digest.sh` | Entrypoint: грузит `.env`+config+lib, fail-fast по токену, цикл тем (реальный `run_topic` через `claude`), агрегация, доставка. |
| `notify_telegram.sh` | Отдельный reusable-скрипт отправки `_daily.md` в Telegram (вызывается из `run_digest.sh` и вручную). |
| `com.newsvibe.digest.plist` | launchd-агент, ежедневно 08:00. |
| `.env.example` | Шаблон секретов (token, chat id). |
| `tests/lib.sh` | Assert-хелперы. |
| `tests/test_*.sh` | 4 теста (config, aggregate, telegram dry-run, partial failure). |
| `CLAUDE.md`, `PROGRESS.md`, `README.md` | Проектные доки. |

---

## Task 1: Тестовая инфраструктура (assert-хелперы)

**Files:**
- Create: `tests/lib.sh`
- Create: `tests/test_smoke.sh`

- [ ] **Step 1: Написать assert-библиотеку**

Create `tests/lib.sh`:
```bash
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
```

- [ ] **Step 2: Написать smoke-тест, проверяющий сами хелперы**

Create `tests/test_smoke.sh`:
```bash
#!/usr/bin/env bash
cd "$(dirname "$0")/.." || exit 1
source tests/lib.sh
assert_eq "a" "a" "eq works"
assert_contains "hello world" "world" "contains works"
finish
```

- [ ] **Step 3: Запустить — должен пройти**

Run: `bash tests/test_smoke.sh`
Expected: `PASS: tests/test_smoke.sh`

- [ ] **Step 4: Commit**

```bash
cd "~/news_vibe_coding"
git add tests/lib.sh tests/test_smoke.sh
git commit -m "test: add bash assert helpers and smoke test"
```

---

## Task 2: Конфиг тем (`config.sh`)

**Files:**
- Create: `config.sh`
- Test: `tests/test_config_parse.sh`

- [ ] **Step 1: Написать падающий тест**

Create `tests/test_config_parse.sh`:
```bash
#!/usr/bin/env bash
cd "$(dirname "$0")/.." || exit 1
source tests/lib.sh
source config.sh

assert_eq "${#TOPICS[@]}" "6" "должно быть 6 тем"

for e in "${TOPICS[@]}"; do
  slug="${e##*|}"
  if ! printf '%s' "$slug" | grep -qE '^[a-z0-9-]+$'; then
    echo "FAIL: невалидный slug [$slug]"; ASSERT_FAILS=$((ASSERT_FAILS+1))
  fi
done

assert_contains "$SOURCES" "reddit" "источники содержат reddit"
assert_eq "$SCHEDULE_HOUR" "8" "час запуска 8"
finish
```

- [ ] **Step 2: Запустить — должен упасть**

Run: `bash tests/test_config_parse.sh`
Expected: FAIL — `config.sh: No such file` / `TOPICS: unbound`

- [ ] **Step 3: Создать `config.sh`**

Create `config.sh`:
```bash
# Темы дайджеста в формате "human name|slug". Slug → имя файла брифа.
TOPICS=(
  "vibe coding|vibe-coding"
  "Claude Code|claude-code"
  "AI agents|ai-agents"
  "LLM research|llm-research"
  "Cursor|cursor"
  "Codex|codex"
)

# Бесплатные источники (передаём в промпт скилла как ограничение).
SOURCES="reddit,hackernews,github,youtube,polymarket"

# Расписание для launchd-плиста.
SCHEDULE_HOUR=8
SCHEDULE_MIN=0
```

- [ ] **Step 4: Запустить — должен пройти**

Run: `bash tests/test_config_parse.sh`
Expected: `PASS: tests/test_config_parse.sh`

- [ ] **Step 5: Commit**

```bash
git add config.sh tests/test_config_parse.sh
git commit -m "feat: add topics config (config.sh)"
```

---

## Task 3: Структурная агрегация (`aggregate_daily`)

**Files:**
- Create: `lib.sh` (первая функция)
- Test: `tests/test_aggregate.sh`

- [ ] **Step 1: Написать падающий тест**

Create `tests/test_aggregate.sh`:
```bash
#!/usr/bin/env bash
cd "$(dirname "$0")/.." || exit 1
source tests/lib.sh
source config.sh
source lib.sh

OUT="$(mktemp -d)"
trap 'rm -rf "$OUT"' EXIT

# Фейковые брифы для всех 6 тем — по одному буллету.
for e in "${TOPICS[@]}"; do
  name="${e%%|*}"; slug="${e##*|}"
  printf -- '- top story about %s\n\nbody text\n' "$name" > "$OUT/$slug.md"
done

aggregate_daily "$OUT" "2026-06-09"

assert_file_contains "$OUT/_daily.md" "## Главное за день" "есть TL;DR-секция"
assert_file_contains "$OUT/_daily.md" "News Vibe Digest — 2026-06-09" "есть заголовок с датой"
for e in "${TOPICS[@]}"; do
  name="${e%%|*}"
  assert_file_contains "$OUT/_daily.md" "## $name" "секция темы: $name"
done
finish
```

- [ ] **Step 2: Запустить — должен упасть**

Run: `bash tests/test_aggregate.sh`
Expected: FAIL — `lib.sh: No such file` / `aggregate_daily: command not found`

- [ ] **Step 3: Создать `lib.sh` с `aggregate_daily`**

Create `lib.sh`:
```bash
# Чистые функции обёртки. Сеть только в tg_* и только при DRY_RUN!=1.

# Собирает сводный _daily.md из per-topic брифов, лежащих в OUTDIR/<slug>.md.
# Темы без файла (упавшие) пропускаются. Аргументы: OUTDIR DATE.
aggregate_daily() {
  local outdir="$1" date="$2"
  local daily="$outdir/_daily.md"
  {
    printf '# News Vibe Digest — %s\n\n' "$date"
    printf '## Главное за день\n\n'
    local e name slug f teaser
    for e in "${TOPICS[@]}"; do
      name="${e%%|*}"; slug="${e##*|}"; f="$outdir/$slug.md"
      [ -f "$f" ] || continue
      # тизер = первый markdown-буллет, иначе первая непустая строка
      teaser="$(grep -m1 -E '^[-*] ' "$f" | sed -E 's/^[-*] //')"
      [ -n "$teaser" ] || teaser="$(grep -m1 -E '\S' "$f")"
      printf -- '- **%s:** %s\n' "$name" "$teaser"
    done
    printf '\n---\n\n'
    for e in "${TOPICS[@]}"; do
      name="${e%%|*}"; slug="${e##*|}"; f="$outdir/$slug.md"
      [ -f "$f" ] || continue
      printf '## %s\n\n' "$name"
      cat "$f"
      printf '\n'
    done
  } > "$daily"
}
```

- [ ] **Step 4: Запустить — должен пройти**

Run: `bash tests/test_aggregate.sh`
Expected: `PASS: tests/test_aggregate.sh`

- [ ] **Step 5: Commit**

```bash
git add lib.sh tests/test_aggregate.sh
git commit -m "feat: add structural daily aggregation (aggregate_daily)"
```

---

## Task 4: Telegram-отправка с dry-run (`tg_send_*`)

**Files:**
- Modify: `lib.sh` (добавить функции в конец)
- Test: `tests/test_telegram_dryrun.sh`

- [ ] **Step 1: Написать падающий тест**

Create `tests/test_telegram_dryrun.sh`:
```bash
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
```

- [ ] **Step 2: Запустить — должен упасть**

Run: `bash tests/test_telegram_dryrun.sh`
Expected: FAIL — `tg_send_message: command not found`

- [ ] **Step 3: Добавить telegram-функции в `lib.sh`**

Append to `lib.sh`:
```bash
# Telegram limit 4096 символов/сообщение; держим запас.
TG_LIMIT=3500

# Отправка текстового сообщения. DRY_RUN=1 → печать вместо сети.
# Аргументы: TOKEN CHAT_ID TEXT.
tg_send_message() {
  local token="$1" chat="$2" text="$3"
  text="$(printf '%s' "$text" | head -c "$TG_LIMIT")"
  if [ "${DRY_RUN:-0}" = "1" ]; then
    printf 'DRYRUN sendMessage chat=%s len=%s\n' "$chat" "${#text}"
    return 0
  fi
  curl -s -o /dev/null -w '%{http_code}' \
    "https://api.telegram.org/bot$token/sendMessage" \
    -d chat_id="$chat" --data-urlencode "text=$text"
}

# Отправка файла-документа. DRY_RUN=1 → печать вместо сети.
# Аргументы: TOKEN CHAT_ID FILEPATH.
tg_send_document() {
  local token="$1" chat="$2" file="$3"
  if [ "${DRY_RUN:-0}" = "1" ]; then
    printf 'DRYRUN sendDocument chat=%s file=%s\n' "$chat" "$file"
    return 0
  fi
  curl -s -o /dev/null -w '%{http_code}' \
    "https://api.telegram.org/bot$token/sendDocument" \
    -F chat_id="$chat" -F document=@"$file"
}
```

- [ ] **Step 4: Запустить — должен пройти**

Run: `bash tests/test_telegram_dryrun.sh`
Expected: `PASS: tests/test_telegram_dryrun.sh`

- [ ] **Step 5: Commit**

```bash
git add lib.sh tests/test_telegram_dryrun.sh
git commit -m "feat: add Telegram send with dry-run + truncation"
```

---

## Task 5: Оркестрация прогона (`run_all` + per-topic isolation)

**Files:**
- Modify: `lib.sh` (добавить `run_topic` default + `run_all`)
- Test: `tests/test_partial_failure.sh`

- [ ] **Step 1: Написать падающий тест**

Create `tests/test_partial_failure.sh`:
```bash
#!/usr/bin/env bash
cd "$(dirname "$0")/.." || exit 1
export RETRY_SLEEP=0   # без задержек в тесте
source tests/lib.sh
source config.sh
source lib.sh

OUT="$(mktemp -d)"
trap 'rm -rf "$OUT"' EXIT

# Мок: codex и cursor «падают», остальные пишут бриф.
run_topic() {
  local slug="$1" name="$2" outdir="$3"
  case "$slug" in
    codex|cursor) return 1 ;;
    *) printf -- '- top item for %s\n' "$name" > "$outdir/$slug.md"; return 0 ;;
  esac
}

ok="$(run_all "$OUT")"
assert_eq "$ok" "4" "4 темы успешны, 2 упали"

aggregate_daily "$OUT" "2026-06-09"
assert_file_contains "$OUT/_daily.md" "## vibe coding" "успешная тема в дайджесте"
# упавшие темы не должны иметь секции
if grep -qF "## Codex" "$OUT/_daily.md"; then
  echo "FAIL: упавшая тема Codex попала в дайджест"; ASSERT_FAILS=$((ASSERT_FAILS+1))
fi
finish
```

- [ ] **Step 2: Запустить — должен упасть**

Run: `bash tests/test_partial_failure.sh`
Expected: FAIL — `run_all: command not found`

- [ ] **Step 3: Добавить `run_topic` (default) и `run_all` в `lib.sh`**

Append to `lib.sh`:
```bash
# Пауза между retry (сек). В тестах переопределяется RETRY_SLEEP=0.
RETRY_SLEEP="${RETRY_SLEEP:-30}"

# Дефолтная заглушка. Переопределяется в run_digest.sh (реальный claude)
# и в тестах (мок). Существует, чтобы run_all всегда имел что вызвать.
run_topic() {
  echo "run_topic not implemented (override me)" >&2
  return 99
}

# Прогон всех тем с per-topic isolation + 1 retry на тему.
# Падение одной темы не рушит прогон. Печатает в stdout число успешных.
# Аргумент: OUTDIR.
run_all() {
  local outdir="$1" ok=0 e name slug
  for e in "${TOPICS[@]}"; do
    name="${e%%|*}"; slug="${e##*|}"
    if run_topic "$slug" "$name" "$outdir"; then
      ok=$((ok+1))
    else
      echo "RETRY $slug" >&2
      sleep "$RETRY_SLEEP"
      if run_topic "$slug" "$name" "$outdir"; then
        ok=$((ok+1))
      else
        echo "FAIL $slug" >&2
      fi
    fi
  done
  echo "$ok"
}
```

- [ ] **Step 4: Запустить — должен пройти**

Run: `bash tests/test_partial_failure.sh`
Expected: `PASS: tests/test_partial_failure.sh`

- [ ] **Step 5: Прогнать ВСЕ тесты разом**

Run: `for t in tests/test_*.sh; do bash "$t" || exit 1; done`
Expected: 5 строк `PASS:` (smoke, config, aggregate, telegram, partial_failure)

- [ ] **Step 6: Commit**

```bash
git add lib.sh tests/test_partial_failure.sh
git commit -m "feat: add run_all orchestration with per-topic isolation and retry"
```

---

## Task 6: Telegram-скрипт и entrypoint (`notify_telegram.sh`, `run_digest.sh`)

**Files:**
- Create: `notify_telegram.sh`
- Create: `run_digest.sh`
- Create: `.env.example`

Эти скрипты дёргают сеть/`claude` — юнит-тестами не покрываем (логика уже покрыта через `lib.sh`). Проверка — синтаксис + реальный прогон в Task 8.

- [ ] **Step 1: Создать `.env.example`**

Create `.env.example`:
```bash
# Скопировать в .env и заполнить. .env в .gitignore.
TELEGRAM_BOT_TOKEN=123456:ABC-DEF...
TELEGRAM_CHAT_ID=123456789
```

- [ ] **Step 2: Создать `notify_telegram.sh`**

Create `notify_telegram.sh`:
```bash
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
```

- [ ] **Step 3: Создать `run_digest.sh`**

Create `run_digest.sh`:
```bash
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
```

- [ ] **Step 4: Проверить синтаксис обоих скриптов**

Run: `bash -n run_digest.sh && bash -n notify_telegram.sh && echo "syntax ok"`
Expected: `syntax ok`

- [ ] **Step 5: Сделать исполняемыми и закоммитить**

```bash
chmod +x run_digest.sh notify_telegram.sh
git add .env.example notify_telegram.sh run_digest.sh
git commit -m "feat: add run_digest entrypoint and Telegram notifier"
```

---

## Task 7: launchd-агент (`com.newsvibe.digest.plist`)

**Files:**
- Create: `com.newsvibe.digest.plist`

- [ ] **Step 1: Создать плист**

Create `com.newsvibe.digest.plist`:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key><string>com.newsvibe.digest</string>
  <key>ProgramArguments</key>
  <array>
    <string>/bin/bash</string>
    <string>~/news_vibe_coding/run_digest.sh</string>
  </array>
  <key>StartCalendarInterval</key>
  <dict>
    <key>Hour</key><integer>8</integer>
    <key>Minute</key><integer>0</integer>
  </dict>
  <key>EnvironmentVariables</key>
  <dict>
    <!-- launchd даёт минимальный PATH; добавляем места claude/yt-dlp/node.
         Скорректировать под факт: `which claude yt-dlp node`. -->
    <key>PATH</key>
    <string>/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin</string>
  </dict>
  <key>StandardOutPath</key>
  <string>~/news_vibe_coding/digests/launchd.log</string>
  <key>StandardErrorPath</key>
  <string>~/news_vibe_coding/digests/launchd.log</string>
  <key>RunAtLoad</key><false/>
</dict>
</plist>
```

- [ ] **Step 2: Провалидировать plist**

Run: `plutil -lint "com.newsvibe.digest.plist"`
Expected: `com.newsvibe.digest.plist: OK`

- [ ] **Step 3: Commit**

```bash
git add com.newsvibe.digest.plist
git commit -m "feat: add launchd agent for daily 08:00 run"
```

> **Загрузка агента (вручную, НЕ в этом плане — после успешного прогона Task 8):**
> ```bash
> ln -sf "~/news_vibe_coding/com.newsvibe.digest.plist" \
>   ~/Library/LaunchAgents/com.newsvibe.digest.plist
> launchctl unload ~/Library/LaunchAgents/com.newsvibe.digest.plist 2>/dev/null
> launchctl load ~/Library/LaunchAgents/com.newsvibe.digest.plist
> ```

---

## Task 8: Установка скилла и первый реальный прогон (verification)

**Files:** нет правок кода — проверка работоспособности.

- [ ] **Step 1: Установить скилл `last30days`**

В интерактивной сессии Claude Code:
```
/plugin marketplace add mvanhorn/last30days-skill
```
Подтвердить установку. Проверить, что скилл виден (`/plugin` список или доступен как Skill).

- [ ] **Step 2: Проверить наличие тулзов скилла**

Run: `command -v yt-dlp node claude && echo "tools ok"`
Expected: пути ко всем трём + `tools ok`. Если `yt-dlp`/`node` нет — поставить (`brew install yt-dlp node`).

- [ ] **Step 3: Завести `.env`**

```bash
cp .env.example .env
# отредактировать .env: вписать реальные TELEGRAM_BOT_TOKEN и TELEGRAM_CHAT_ID
```
(Токен бота — от @BotFather; chat_id — свой, через @userinfobot или getUpdates.)

- [ ] **Step 4: Dry-run доставки (без сбора)**

Проверить отправку на фейковом дайджесте:
```bash
mkdir -p digests/_smoke && printf '# test\n\n## Главное\n- ok\n' > digests/_smoke/_daily.md
./notify_telegram.sh digests/_smoke/_daily.md
rm -rf digests/_smoke
```
Expected: сообщение + документ пришли в Telegram (HTTP 200 в выводе curl).

- [ ] **Step 5: Полный реальный прогон**

Run: `./run_digest.sh`
Expected (success criteria):
- `digests/<today>/` содержит до 6 файлов `<slug>.md` (упавшие темы могут отсутствовать),
- `digests/<today>/_daily.md` существует и содержит секции успешных тем,
- в Telegram пришли TL;DR-сообщение + `_daily.md` документом,
- `digests/<today>/run.log` без фатальных ошибок.

- [ ] **Step 6: Загрузить launchd-агент**

Выполнить блок загрузки из Task 7. Проверить:
```bash
launchctl list | grep com.newsvibe.digest
```
Expected: строка с label (статус 0 = ок).

- [ ] **Step 7: Финализировать доки и зафиксировать состояние**

- Обновить `PROGRESS.md`: `head` = последний SHA, `status`, `next_actions`.
- Коммит `docs(progress): ...` + push (после настройки remote).

---

## Self-Review

**Spec coverage:**
- Тонкая обёртка → Task 6 (`run_digest.sh` дёргает готовый скилл). ✅
- Бесплатные источники → промпт в `run_topic` + `SOURCES`. ✅
- Ежедневно 08:00 → Task 7 launchd. ✅
- Файлы в проект → `digests/<date>/`. ✅
- Telegram → Task 4/6 `notify_telegram.sh`. ✅
- 6 тем → `config.sh` (Task 2). ✅
- Per-topic isolation + retry → `run_all` (Task 5). ✅
- «Все упали» алерт → `run_digest.sh` ветка `ok -eq 0`. ✅
- Идемпотентность (папка дня, перезапись) → `OUTDIR=digests/$DATE`. ✅
- 4 теста (config/aggregate/telegram/partial) → Tasks 2-5. ✅
- YAGNI (нет SQLite/дедуп/HTML/X) → не включено. ✅

**Type/имена консистентны:** `TOPICS` формат `name|slug`, `${e%%|*}`/`${e##*|}` — единообразно во всех тасках. `aggregate_daily(outdir,date)`, `run_all(outdir)`, `run_topic(slug,name,outdir)`, `tg_send_message(token,chat,text)`, `tg_send_document(token,chat,file)` — сигнатуры совпадают между определением и вызовами. ✅

**Placeholder scan:** код полный во всех шагах, без TODO/TBD. ✅
