# usage — Claude usage monitor

Shows live usage percentages and time until reset directly in the Claude Code status bar. **Alerts you in chat** when you're approaching your token limits.

```
🟢 ctx:12%   🟢 5h:32% ↺3h 15m   🟢 7d:8% ↺5d 0h
```

No cookies, no scraping, no extra configuration. Works by reading `rate_limits` and `context_window` data that Claude Code already receives from Anthropic's API on every response.

## What it shows

| Indicator | Meaning |
|-----------|---------|
| `ctx` | Context window usage for the current session |
| `5h` | Current 5-hour session window usage |
| `7d` | Current 7-day weekly window usage |
| `↺` | Time remaining until that window resets |
| 🟢 | Under 70% |
| 🟡 | 70–90% — getting close |
| 🔴 | Over 90% — slow down |

The `ctx` indicator lets you know when your session context is growing large — handy to decide if you should start a fresh session.

## Chat alerts

When either window crosses a threshold, a message appears directly in the conversation:

- **80%** → warning, asks if you want to pause *(default)*
- **90%** → critical alert, asks if you want to stop *(default)*

Alerts fire **once per threshold** — no spam. Resets automatically when the window resets.

### Custom thresholds

Set environment variables to override defaults — useful for shared or limited accounts:

```bash
# Example: cap at 50% for a shared account
export USAGE_WARN_PCT=40
export USAGE_STOP_PCT=50
```

Add them to your shell profile (`~/.bashrc`, `~/.zshrc`) so they persist.

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
