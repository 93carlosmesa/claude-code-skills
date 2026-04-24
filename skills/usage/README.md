# usage — Claude usage monitor

Shows live usage percentages, time until reset, **context-window usage**, and (optionally) an **agent label** for the current workspace — right in the Claude Code status bar. Also **alerts you in chat** when you're approaching your token limits.

```
💜 Sam   🟢 ctx:8%   🟢 5h:32% ↺3h 15m   🟢 7d:8% ↺5d 0h
```

No cookies, no scraping, no extra configuration. Works by reading the session JSON (including `rate_limits` and `context_window`) that Claude Code already receives from Anthropic's API on every response.

## What it shows

| Indicator | Meaning |
|-----------|---------|
| `[label]` | Agent / workspace label (optional — see *Agent labels* below) |
| `ctx` | Context window usage for the current turn |
| `5h` | 5-hour session rate-limit window |
| `7d` | 7-day rate-limit window |
| `↺` | Time remaining until that window resets |
| 🟢 | Under 70% |
| 🟡 | 70–90% — getting close |
| 🔴 | Over 90% — slow down |

The `ctx` indicator lets you know when your session context is growing large — handy to decide if you should start a fresh session.

## Agent labels (optional)

If you run several Claude Code sessions with different roles (different bots, projects, or repos), the statusline can prefix each one with a short label. Detection order:

1. **`CLAUDE_AGENT_LABEL` env var** — set it in the shell that launches Claude Code and it wins over everything. Great for ad-hoc sessions.
2. **`~/.claude/agents.conf`** — map cwd substrings to labels. First match wins:
   ```
   # pattern|label
   /projects/acme|🏢 Acme
   /home/me/work|💼 Work
   /opt/bots/alice|🤖 Alice
   ```
   Override the file path with `CLAUDE_AGENTS_CONF=/some/path`.
3. **Generic fallback** — if your cwd looks like `.../agents/<name>/` or `.../<n>.agents/<name>/`, it auto-labels as `🤖 <Name>`.
4. **Nothing** — original behavior, metrics only.

The installer drops a commented-out `agents.conf` next to Claude's config; edit it or delete it, nothing is forced.

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
