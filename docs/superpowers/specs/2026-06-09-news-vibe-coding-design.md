# News Vibe Coding — дизайн автоматизации новостного дайджеста

**Дата:** 2026-06-09
**Статус:** утверждён, готов к плану реализации

## Цель

Ежедневный автоматический дайджест новостей по темам вайб-кодинга и AI-research
поверх готового агентного скилла [`last30days-skill`](https://github.com/mvanhorn/last30days-skill).
Тонкая обёртка-автоматизация: сам сбор и синтез делает скилл, мы пишем только
планировщик, агрегацию и доставку.

## Контекст и ключевой факт

`last30days` — это **агентный скилл Claude Code**, не самостоятельный CLI. Он работает
внутри агента: Claude параллельно дёргает источники своими тулзами (Reddit JSON, HN API,
GitHub, `yt-dlp`, Polymarket) и синтезирует markdown-бриф с цитатами и разделом «Best Takes».
Поэтому автоматизация = ежедневный headless-запуск `claude -p` со скилла по каждой теме.

## Решения (зафиксированы при брейнсторме)

| Параметр | Решение |
|---|---|
| Объём | Тонкая обёртка (скилл as-is, пишем только планировщик/агрегацию/доставку) |
| Источники | Только бесплатные: Reddit, Hacker News, GitHub, YouTube, Polymarket |
| Частота | Ежедневно, 08:00 |
| Доставка | Файлы в проект (`digests/`) + Telegram |
| Темы | vibe coding, Claude Code, AI agents, LLM research, Cursor, Codex |
| Оркестрация | macOS `launchd` (`StartCalendarInterval`) — переживает сон, догоняет пропуск |

Отклонённые варианты оркестрации:
- **Claude Code `/schedule` (облако)** — у облачного агента нет локальных тулзов
  (`yt-dlp`, Reddit-доступ) и он не пишет в файлы на X10. Не подходит.
- **Обычный `cron`** — на маке не догоняет пропуски во сне. `launchd` лучше.

## Структура проекта

```
news_vibe_coding/
├── config.yaml              # темы, расписание, источники
├── .env                     # TELEGRAM_BOT_TOKEN, CHAT_ID (gitignored)
├── .env.example             # шаблон без секретов
├── run_digest.sh            # раннер: цикл по темам → claude -p → агрегация → TG
├── notify_telegram.sh       # отправка дайджеста в Telegram
├── com.newsvibe.digest.plist  # launchd, ежедневно 08:00
├── digests/
│   └── 2026-06-09/
│       ├── vibe-coding.md
│       ├── claude-code.md
│       ├── ...
│       ├── _daily.md        # сводный за день (его шлём в TG)
│       └── run.log          # лог прогона (stdout+stderr)
├── tests/
│   ├── test_aggregate.sh
│   ├── test_config_parse.sh
│   ├── test_telegram_dryrun.sh
│   └── test_partial_failure.sh
├── CLAUDE.md
├── PROGRESS.md
└── README.md
```

## Поток данных

```
launchd 08:00
  → run_digest.sh
      LAST30DAYS_MEMORY_DIR=digests/<date>/  export
      for TOPIC in config.topics:
        claude -p "<prompt: last30days, free sources, save to <slug>.md>"
          → digests/<date>/<slug>.md         (per-topic isolation: fail → log+continue, 1 retry)
      claude -p "<сжать 6 брифов в _daily.md с TL;DR сверху>"
          → digests/<date>/_daily.md
  → notify_telegram.sh
      sendMessage(TL;DR, ≤3500 символов) + sendDocument(_daily.md)
```

## Компоненты

### config.yaml
```yaml
topics:
  - {name: "vibe coding",  slug: vibe-coding}
  - {name: "Claude Code",  slug: claude-code}
  - {name: "AI agents",    slug: ai-agents}
  - {name: "LLM research", slug: llm-research}
  - {name: "Cursor",       slug: cursor}
  - {name: "Codex",        slug: codex}
sources: [reddit, hackernews, github, youtube, polymarket]
schedule: "08:00"
```

### run_digest.sh
Запуск на тему:
```bash
claude -p "Use the last30days skill to research \"$TOPIC\" over the last 30 days. \
Free sources only: Reddit, Hacker News, GitHub, YouTube, Polymarket. \
Output a markdown brief with citations and a Best Takes section. \
Save it to $OUTDIR/$SLUG.md" \
  --allowedTools "Skill,Bash,WebFetch,Read,Write" \
  --output-format text
```
- `LAST30DAYS_MEMORY_DIR=$OUTDIR` экспортится, чтобы скилл писал в нашу папку.
- Темы последовательно (rate limits источников + один claude-процесс надёжнее), без параллели.
- Агрегация: отдельный короткий `claude -p` склеивает 6 брифов в `_daily.md`
  с разделом «Главное за день» сверху (дешевле и читабельнее тупой склейки).

### notify_telegram.sh
Telegram limit 4096 символов/сообщение. Шлём TL;DR текстом + `_daily.md` документом:
```bash
curl -s "https://api.telegram.org/bot$TOKEN/sendMessage" \
  -d chat_id="$CHAT_ID" --data-urlencode text@<(head -c 3500 "$DAILY")
curl -s "https://api.telegram.org/bot$TOKEN/sendDocument" \
  -F chat_id="$CHAT_ID" -F document=@"$DAILY"
```

### com.newsvibe.digest.plist
`launchd` с `StartCalendarInterval` (Hour 8, Minute 0). `RunAtLoad=false`.
`StandardOutPath`/`StandardErrorPath` → `digests/launchd.log`.

## Обработка ошибок

- **Per-topic isolation:** каждая тема в блоке `|| { log "FAIL $TOPIC"; continue; }`.
  Падение одной не рушит прогон; дайджест собирается из успевших.
- **Retry:** один повтор на тему при ненулевом exit (сеть/rate limit), пауза 30с, потом skip.
- **Все упали:** если `_daily.md` пуст — в Telegram короткий алерт «прогон провалился, см. log», не молчим.
- **Telegram:** проверяем HTTP-код `curl`; non-200 → один retry.
- **Fail-fast по конфигу:** отсутствие `TELEGRAM_BOT_TOKEN`/`CHAT_ID` → скрипт падает рано
  с понятным сообщением.
- **Лог:** `digests/<date>/run.log` (stdout+stderr скрипта и claude).

## Идемпотентность

- Папка дня = `digests/$(date +%F)/`. Повторный запуск в тот же день перезаписывает
  (свежее побеждает) — без дублей.
- `launchd StartCalendarInterval` = 1 запуск/сутки; ручной повторный прогон безопасен.

## Тесты (bash, без сети)

| Тест | Проверяет |
|---|---|
| `test_aggregate.sh` | 6 фейковых `<topic>.md` → `_daily.md` содержит все 6 H2 + TL;DR |
| `test_config_parse.sh` | `config.yaml` парсится, 6 тем, слаги валидны |
| `test_telegram_dryrun.sh` | `DRY_RUN=1` печатает curl вместо отправки; chat_id/text не пусты, обрезка до 3500 |
| `test_partial_failure.sh` | 2 темы «упали» → дайджест из 4, алерта нет (не все упали) |

Реальный `claude -p` в CI не мокаем — проверяем первым ручным прогоном.
**Success criteria:** 6 файлов тем + `_daily.md` + сообщение в Telegram.

## YAGNI (вне scope)

SQLite-накопление/тренды, кросс-темный дедуп, HTML-экспорт, X/TikTok/Brave.
Добавляем позже при необходимости.
