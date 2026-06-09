---
project: news_vibe_coding
head: f6c1a17
tests: "bash 7/7"
status: "MVP в проде + Pack #1 (язык) + Pack #2 (web-архив/Pages) готовы. Облако автономно (cron 06:00 UTC). Репо public OSS, Pages: https://olma777.github.io/news_vibe_coding/"
last_session: "2026-06-09 (session 01)"
next_actions:
  - "Pack #3: богаче подача в TG (по теме отдельное сообщение + Best Takes + inline-кнопки на web-архив)"
  - "Pack #4: итоги недели (понедельничный cron, агрегация 7 дней из docs/digests)"
  - "Pack #5: трекинг трендов (--store SQLite, коммит БД для персистентности)"
  - "Опц.: публичный канал — создать, бот-админ, задать GH secret TELEGRAM_CHANNEL_ID (код уже готов, no-op пока пусто)"
  - "Проверить: следующий cloud-прогон сам коммитит docs/digests/<date>/ (шаг Publish archive) — на текущей сессии не валидировано прогоном"
links:
  spec: "docs/superpowers/specs/2026-06-09-news-vibe-coding-design.md"
  plan: "docs/superpowers/plans/2026-06-09-news-vibe-coding.md"
  pages: "https://olma777.github.io/news_vibe_coding/"
  repo: "https://github.com/Olma777/news_vibe_coding"
---

# PROGRESS — News Vibe Coding

## Текущее состояние

HEAD `f6c1a17` — `fix: publish digest as index.md (Jekyll ignores _-prefixed files)`.

MVP в продакшене + Pack #1 (язык ru/en/both) + Pack #2 (персистентность + web-архив на GitHub Pages).
Облако автономно: GitHub Actions cron `0 6 * * *` UTC, прогон 27207760831 был green end-to-end
(6/6 тем, дайджест доставлен в Telegram-бот `@v_code_news_bot`). Тесты `bash 7/7`.

**Не провалидировано прогоном:** шаг workflow `Publish archive` (авто-коммит `docs/digests/<date>/`)
— добавлен, но облачный прогон с ним ещё не гонялся. Pages-источник засеян вручную (1 дайджест) и
отдаёт `200`. Проверить на следующем cloud-прогоне.

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
- **Task 8 (деплой):** установлен скилл `last30days` (через `claude plugin`), `yt-dlp`/`node`,
  `.env` с секретами, реальный прогон 6/6, бот пересоздан (`@v_code_news_bot`, см. инцидент антиспама).
- **Облако:** GitHub Actions workflow (`feat`, OAuth-токен подписки), репо → public (Actions бесплатны),
  English OSS README + MIT + topics. Cloud-прогон green, дайджест доставлен.
- **Фидбэк-итерация:** брифы/дайджест на русском + компактная читаемая подача в Telegram
  (вместо 53KB .md документом). Фикс бага усечения (`cut -c` по строкам → python).
- **Чистка под OSS:** убраны `/Volumes/X10` пути и метка `mrdi` (plist → `com.newsvibe.digest`, placeholder).
- **Pack #1:** `DIGEST_LANG` (ru/en/both) — `lang_targets`/`brief_lang`/`lang_clause` + `test_lang.sh`.
- **Pack #2:** web-архив — `publish.sh`+`regen_index` → `docs/digests/<date>/index.md` + `docs/index.md`,
  GitHub Pages (cayman), workflow `contents:write`+commit, `.gitignore` `/digests/` (anchored),
  опц. `TELEGRAM_CHANNEL_ID`. `test_publish.sh`.

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
