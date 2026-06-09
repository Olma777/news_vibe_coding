# shellcheck shell=bash
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

# Язык дайджеста: ru | en | both.
#   ru   — всё на русском
#   en   — всё на английском
#   both — две версии в Telegram (русская + английская)
DIGEST_LANG="ru"

# Расписание для launchd-плиста.
SCHEDULE_HOUR=8
SCHEDULE_MIN=0
