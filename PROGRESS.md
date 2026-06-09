---
project: news_vibe_coding
head: 6903476
tests: "bash 5/5"
status: "MVP в продакшене: облачный GitHub Actions прогон green end-to-end (run 27207760831, success 13:31), дайджест доставлен в Telegram. Репо public OSS."
last_session: "2026-06-09"
next_actions:
  - "Pack #1: языковой переключатель DIGEST_LANG (ru/en/both)"
  - "Pack #2: персистентность дайджестов + публичный канал + web-архив (GitHub Pages)"
  - "Pack #3: богаче подача в TG (по теме отдельное сообщение + Best Takes + inline-кнопки)"
  - "Pack #4: итоги недели (понедельничный cron, агрегация 7 дней)"
  - "Pack #5: трекинг трендов (--store SQLite, коммит БД для персистентности)"
links:
  spec: "docs/superpowers/specs/2026-06-09-news-vibe-coding-design.md"
  plan: "docs/superpowers/plans/2026-06-09-news-vibe-coding.md"
---

# PROGRESS — News Vibe Coding

## Текущее состояние

HEAD `e4104ed` — `fix: quote brief path in claude prompt, single-truncate, fix plist log dir`.

Код-часть завершена (Tasks 1-7 по плану), оба ревью (spec + quality) пройдены, фиксы внесены.
Тесты: `bash 5/5` (smoke, config_parse, aggregate, telegram_dryrun, partial_failure).

Осталось — **Task 8** (интерактивная, требует секретов/сети/установки скилла):
установка `last30days-skill`, `.env`, первый реальный прогон, загрузка launchd-агента.

## Сделано (сессия 01, 2026-06-09)

- Брейнсторм → спека (`a2c74a9`) → план (`dc72b89`).
- Task 1: assert-хелперы + smoke (`ccb885c`).
- Task 2: `config.sh` — 6 тем (`cedd10a`).
- Task 3: `aggregate_daily` (`5e1e427`).
- Task 4: Telegram dry-run + усечение (`badde84`).
- Task 5: `run_all` оркестрация + per-topic isolation/retry (`0ce3327`).
- Code-review fix ядра: UTF-8-safe усечение + чистый stdout `run_all` (`d53dce4`).
- Task 6: `run_digest.sh` + `notify_telegram.sh` + `.env.example` (`1fcb21e`).
- Task 7: launchd-плист (`b997e0e`).
- Code-review fix скриптов: quote brief, single-truncate, plist log в /tmp (`e4104ed`).
- Доки: README, CLAUDE.md, PROGRESS.md.

## Backlog (YAGNI, вне текущего scope)

- SQLite-накопление и тренды (`--store`).
- Кросс-темный дедуп одинаковых стори.
- HTML-экспорт дайджеста.
- Платные источники: X/Twitter, TikTok, Brave/Perplexity.

## Env vars

- `TELEGRAM_BOT_TOKEN`, `TELEGRAM_CHAT_ID` — в `.env` (gitignored), шаблон в `.env.example`.
- `LAST30DAYS_MEMORY_DIR` — экспортится `run_digest.sh` в каталог дня.
- `RETRY_SLEEP` — пауза retry (по умолчанию 30с; тесты ставят 0).
- `DRY_RUN=1` — telegram-функции печатают вместо отправки (для тестов).
