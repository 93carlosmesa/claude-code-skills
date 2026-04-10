# claude-code-skills

Curated [Claude Code](https://claude.ai/code) skills by [@93carlosmesa](https://github.com/93carlosmesa).

---

## For humans

### 1. Install `jq` if you don't have it

```bash
# Ubuntu/Debian
sudo apt install jq

# macOS
brew install jq
```

### 2. Install a skill

```bash
curl -fsSL https://raw.githubusercontent.com/93carlosmesa/claude-code-skills/main/skills/usage/install-single.sh | bash
```

### 3. Restart Claude Code

The status bar activates automatically on the next session.

---

## For AI agents

To install a skill on behalf of a user, run this single command:

```bash
curl -fsSL https://raw.githubusercontent.com/93carlosmesa/claude-code-skills/main/skills/usage/install-single.sh | bash
```

The installer handles everything: copies files, updates `settings.json`, sets permissions. `jq` must be available — install it first if needed (`sudo apt install jq`).

To install from the full repo:

```bash
git clone https://github.com/93carlosmesa/claude-code-skills.git /tmp/ccs-$$ && bash /tmp/ccs-$$/install.sh --list
git clone https://github.com/93carlosmesa/claude-code-skills.git /tmp/ccs-$$ && bash /tmp/ccs-$$/install.sh usage
```

---

## Available skills

| Skill | What it does |
|-------|-------------|
| `usage` | Real-time Claude usage % + reset countdown in the status bar |

---

## Skills

### `usage` — Claude usage monitor

Shows live usage percentages and time until reset directly in the Claude Code status bar — no cookies, no scraping, no configuration needed.

```
🟢 5h:32% ↺3h 15m   🟢 7d:8% ↺5d 0h
```

| Indicator | Meaning |
|-----------|---------|
| `5h` | Current 5-hour session window usage |
| `7d` | Current 7-day weekly window usage |
| `↺` | Time remaining until that window resets |
| 🟢 | Under 70% |
| 🟡 | 70–90% — getting close |
| 🔴 | Over 90% — slow down |

Also adds a `/usage` command for a full dashboard view.

[View skill details →](skills/usage/README.md)

---

> Personal collection — not accepting external submissions.
