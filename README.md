# 📰 News Vibe Coding

> A daily, fully automated news digest about **vibe coding & AI** — delivered to Telegram every morning, with **zero servers** to run.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Daily digest](https://github.com/Olma777/news_vibe_coding/actions/workflows/digest.yml/badge.svg)](https://github.com/Olma777/news_vibe_coding/actions/workflows/digest.yml)
![bash](https://img.shields.io/badge/made%20with-bash-1f425f.svg)

News Vibe Coding is a thin automation layer on top of the excellent
[`last30days-skill`](https://github.com/mvanhorn/last30days-skill) — a Claude Code agent
skill that aggregates the last 30 days of community signal (Reddit, Hacker News, GitHub,
YouTube, Polymarket) on any topic and synthesizes a cited brief.

This repo wires that skill into a **scheduled pipeline**: every morning it researches a
fixed list of AI/coding topics, condenses them into one phone-readable digest, and pushes
it to Telegram. Run it locally (macOS `launchd`) or in the cloud (GitHub Actions — free).

## What the digest looks like

A single, scannable Telegram message — one takeaway + key link per topic:

```
📰 News Vibe — 2026-06-09

• AI agents: The conversation shifted from "do agents work?" to "why do they
  break in prod" — ~88% never reach production; reliability and context
  engineering are the pain, MCP became the connection standard (10K+ servers).
  https://www.digitalapplied.com/blog/88-percent-ai-agents-never-reach-production-failure-framework

• Claude Code: Opus 4.8 is the new default; Dynamic Workflows let Claude write
  its own orchestration and fan out to up to 1000 subagents. Mixed reception:
  real upgrade vs. token-cost anxiety.
  https://claude.com/blog/introducing-dynamic-workflows-in-claude-code

• Cursor: Composer 2.5 lands (Opus-4.7-level on SWE-Bench at ~1/10 the cost),
  but no external API. Backdrop: pricing grumbles + a 90% Polymarket contract
  on a SpaceX acquisition.
  https://cursor.com/blog/composer-2-5
  ...
```

The full per-topic briefs (with Best Takes, prediction-market signals and full
citations) are saved as markdown and attached to the message as a document.

## How it works

```
schedule (06:00 UTC / launchd 08:00 local)
  → run_digest.sh
      for each topic:
        claude -p  →  last30days skill  →  digests/<date>/<topic>.md   (Russian brief)
      aggregate_daily   →  digests/<date>/_daily.md   (full archive)
      summarize_telegram →  digests/<date>/_telegram.md (compact, ≤3000 chars)
  → Telegram: compact digest in chat + full file as attachment
```

Per-topic isolation: a failure in one topic doesn't sink the run (one retry, then skip);
if every topic fails, an alert is sent instead.

## Topics & sources

- **Topics** (edit in [`config.sh`](config.sh)): `vibe coding`, `Claude Code`, `AI agents`,
  `LLM research`, `Cursor`, `Codex`.
- **Sources** (free, no API keys): Reddit · Hacker News · GitHub · YouTube · Polymarket.
- **Language** (`DIGEST_LANG` in [`config.sh`](config.sh)): `ru` | `en` | `both` — get the
  digest in Russian, English, or both versions side by side.

## Setup

### Prerequisites
- [`claude` CLI](https://claude.com/claude-code) (Claude Code)
- `node`, `yt-dlp`
- The skill: `claude plugin marketplace add mvanhorn/last30days-skill && claude plugin install last30days@last30days-skill`
- A Telegram bot (via [@BotFather](https://t.me/BotFather)) and your chat id

### Secrets
```bash
cp .env.example .env   # fill TELEGRAM_BOT_TOKEN, TELEGRAM_CHAT_ID
```

### Option A — Cloud (GitHub Actions, recommended)
Runs every morning with no machine on. Add repository **secrets**:
`TELEGRAM_BOT_TOKEN`, `TELEGRAM_CHAT_ID`, `CLAUDE_CODE_OAUTH_TOKEN`
(the last from `claude setup-token` — uses your Claude subscription, no separate API bill).
The workflow ([`.github/workflows/digest.yml`](.github/workflows/digest.yml)) runs daily at
**06:00 UTC** and is also runnable on demand via **Run workflow**.

### Option B — Local (macOS launchd)
The plist ships with a `__PROJECT_DIR__` placeholder — fill it with your absolute project
path on install:
```bash
sed "s|__PROJECT_DIR__|$PWD|" com.newsvibe.digest.plist \
  > ~/Library/LaunchAgents/com.newsvibe.digest.plist
launchctl load ~/Library/LaunchAgents/com.newsvibe.digest.plist
```
Runs daily at 08:00 local; `StartCalendarInterval` catches up missed runs after sleep.

### Run manually
```bash
./run_digest.sh
```

## Tests

Pure logic (config parsing, aggregation, Telegram truncation, partial-failure handling)
is covered by dependency-free bash tests:

```bash
for t in tests/test_*.sh; do bash "$t"; done
```

## Credits

- Built on [`last30days-skill`](https://github.com/mvanhorn/last30days-skill) by
  [@mvanhorn](https://github.com/mvanhorn) — it does the actual research and synthesis.
- Powered by [Claude Code](https://claude.com/claude-code).

## License

[MIT](LICENSE) © 2026 Mr. Di ([@Olma777](https://github.com/Olma777))
