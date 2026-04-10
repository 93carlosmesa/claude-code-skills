# claude-usage-skill

A skill for [Claude Code](https://claude.ai/code) that shows your **real-time usage percentages** directly in the status bar — no cookies, no scraping, no extra setup.

Works by reading the `rate_limits` data that Claude Code already receives from Anthropic's API on every response.

```
🟢5h:22%  🟢7d:39%
```

## What it shows

| Indicator | Meaning |
|-----------|---------|
| `5h` | Usage of your current 5-hour session window |
| `7d` | Usage of your 7-day weekly window |
| 🟢 | Under 70% — you're good |
| 🟡 | 70–90% — getting close |
| 🔴 | Over 90% — slow down or wait for reset |

## Requirements

- [Claude Code](https://claude.ai/code) installed and authenticated
- `jq` installed (`sudo apt install jq` / `brew install jq`)

## Installation

### One-liner

```bash
git clone https://github.com/93carlosmesa/claude-usage-skill.git /tmp/claude-usage-skill && bash /tmp/claude-usage-skill/install.sh
```

### Manual

```bash
git clone https://github.com/93carlosmesa/claude-usage-skill.git
cd claude-usage-skill
bash install.sh
```

Then **restart Claude Code** to activate the status bar.

## Usage

### Status bar (automatic)

After installation and restart, the usage percentages appear automatically at the bottom of every Claude Code session.

### `/usage` command

Type `/usage` in any conversation for a full dashboard:

```
🟢 5h window:   22% used  (resets in 3h 45m)
🟢 7-day:       39% used  (resets in 4 days)
📊 Context:     12% used  (88% remaining)
```

## How it works

Claude Code exposes `rate_limits` data in the statusline context on every API response. This skill reads that data and displays it — **no authentication required beyond your existing Claude Code session**.

No tokens, no cookies, no API keys needed.

## Custom config dir

If you use a custom `CLAUDE_CONFIG_DIR`:

```bash
CLAUDE_CONFIG_DIR=~/.claude-custom bash install.sh
```

## License

MIT
