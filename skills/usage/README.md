# usage — Claude usage monitor

Shows live usage percentages and time until reset directly in the Claude Code status bar.

```
🟢 5h:32% ↺3h 15m   🟢 7d:8% ↺5d 0h
```

No cookies, no scraping, no extra configuration. Works by reading `rate_limits` data that Claude Code already receives from Anthropic's API on every response.

## What it shows

| Indicator | Meaning |
|-----------|---------|
| `5h` | Current 5-hour session window usage |
| `7d` | Current 7-day weekly window usage |
| `↺` | Time remaining until that window resets |
| 🟢 | Under 70% |
| 🟡 | 70–90% — getting close |
| 🔴 | Over 90% — slow down |

## Installation

```bash
curl -fsSL https://raw.githubusercontent.com/93carlosmesa/claude-code-skills/main/skills/usage/install-single.sh | bash
```

Restart Claude Code after installing.

## Requirements

- [Claude Code](https://claude.ai/code) installed and authenticated
- `jq` (`sudo apt install jq` / `brew install jq`)

## Custom config dir

```bash
CLAUDE_CONFIG_DIR=~/.claude-custom bash install-single.sh
```

## License

MIT
