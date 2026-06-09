# News Vibe Coding

Ежедневный автоматический дайджест новостей по темам вайб-кодинга и AI-research,
построенный поверх агентного скилла [`last30days-skill`](https://github.com/mvanhorn/last30days-skill).

Тонкая обёртка-автоматизация: сбор и синтез делает скилл, проект добавляет планировщик
(`launchd`), агрегацию дневной сводки и доставку в файлы + Telegram.

## Темы

`vibe coding`, `Claude Code`, `AI agents`, `LLM research`, `Cursor`, `Codex`
(см. `config.sh`).

## Источники

Только бесплатные: Reddit, Hacker News, GitHub, YouTube, Polymarket.

## Как работает

```
launchd 08:00 → run_digest.sh
  → для каждой темы: claude -p (skill last30days) → digests/<date>/<slug>.md
  → aggregate_daily → digests/<date>/_daily.md (TL;DR + секции тем)
  → notify_telegram.sh → TL;DR-сообщение + _daily.md документом в Telegram
```

Падение одной темы не рушит прогон (per-topic isolation + 1 retry). Если упали все —
в Telegram уходит алерт.

## Установка

1. Установить скилл в Claude Code: `/plugin marketplace add mvanhorn/last30days-skill`
2. Тулзы скилла: `brew install yt-dlp node` (для YouTube и пр.)
3. Секреты: `cp .env.example .env` и заполнить `TELEGRAM_BOT_TOKEN`, `TELEGRAM_CHAT_ID`.
4. Загрузить launchd-агент (см. `docs/superpowers/plans/2026-06-09-news-vibe-coding.md`, Task 7).

## Запуск вручную

```bash
./run_digest.sh                      # полный прогон (нужен .env + скилл)
./notify_telegram.sh digests/<date>/_daily.md   # переотправить готовый дайджест
```

## Тесты

```bash
for t in tests/test_*.sh; do bash "$t" || exit 1; done
```

Покрывают чистую логику без сети: config, агрегация, telegram dry-run, partial failure.

## Документация

- `docs/superpowers/specs/2026-06-09-news-vibe-coding-design.md` — дизайн.
- `docs/superpowers/plans/2026-06-09-news-vibe-coding.md` — план реализации.
- `PROGRESS.md` — текущее состояние.
