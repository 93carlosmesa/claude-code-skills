# claude-code-skills

A curated collection of skills for [Claude Code](https://claude.ai/code).

> This is a personal collection maintained by [@93carlosmesa](https://github.com/93carlosmesa). Not accepting external skill submissions.

## Available skills

| Skill | Description |
|-------|-------------|
| [usage](skills/usage/) | Real-time usage percentages in the Claude Code status bar |

## Installation

### Quick install (one-liner)

```bash
git clone https://github.com/93carlosmesa/claude-code-skills.git /tmp/claude-code-skills && bash /tmp/claude-code-skills/install.sh usage
```

### Manual

```bash
git clone https://github.com/93carlosmesa/claude-code-skills.git
cd claude-code-skills
bash install.sh --list       # see all skills
bash install.sh usage        # install a specific skill
```

## Requirements

- [Claude Code](https://claude.ai/code) installed and authenticated
- `jq` (`sudo apt install jq` / `brew install jq`)

## Skills

### `usage` — Claude usage monitor

Shows your real-time usage percentages directly in the Claude Code status bar.

```
🟢5h:22%  🟢7d:39%
```

Reads `rate_limits` data from Claude Code's own API responses — no cookies, no scraping, no extra configuration needed. Works with any Claude plan (Pro, Max, Team).

[View details →](skills/usage/README.md)
