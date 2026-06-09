# CLAUDE.md — News Vibe Coding

Проектные правила и конвенции для агентов/контрибьюторов.

## Что это

Тонкая обёртка-автоматизация поверх агентного скилла `last30days-skill`: ежедневный
дайджест новостей по темам вайб-кодинга/AI с доставкой в файлы + Telegram.

## Стек

- **bash** — вся логика (`config.sh`, `lib.sh`, `run_digest.sh`, `notify_telegram.sh`).
- **curl** — Telegram Bot API.
- **claude CLI** (headless `claude -p`) — запускает скилл `last30days` по теме.
- **macOS launchd** — ежедневный триггер 08:00 (`com.newsvibe.digest.plist`).
- Зависимость сбора: установленный скилл `mvanhorn/last30days-skill` + `yt-dlp`, `node`.

## Архитектура

`config.sh` — темы/источники/расписание. `lib.sh` — чистые функции (агрегация,
telegram, оркестрация `run_all`), покрыты тестами без сети. `run_digest.sh` — entrypoint:
грузит `.env`+config+lib, цикл тем через `claude -p`, агрегация, доставка.

## Конвенции

- Пути с пробелом в имени каталога — ВСЕГДА в кавычках в скриптах (`"$DIR"`, `"$OUTDIR"`).
- Тесты bash без фреймворка: `tests/lib.sh` (assert-хелперы) + `tests/test_*.sh`.
  Запуск: `for t in tests/test_*.sh; do bash "$t" || exit 1; done`.
- Чистые функции в `lib.sh` тестируемы; сеть только в `tg_*` и только при `DRY_RUN!=1`.
- Усечение текста для Telegram — по символам (`cut -c`), UTF-8-safe (дайджест русскоязычный).
- Коммиты: conventional prefixes (`feat:`/`fix:`/`test:`/`docs:`).

## Навигация

- `README.md` — публичное описание, установка.
- `PROGRESS.md` — текущее состояние, HEAD, backlog.
- `docs/superpowers/specs/` — дизайн. `docs/superpowers/plans/` — план реализации.

## Не версионируем

`.env`, `.claude/`, `digests/` (результаты прогонов) — в `.gitignore`.
