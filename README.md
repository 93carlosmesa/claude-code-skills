# claude-code-skills

Curated [Claude Code](https://claude.ai/code) skills by [@93carlosmesa](https://github.com/93carlosmesa).

---

## Available skills

| Skill | What it does | Install |
|-------|-------------|---------|
| [usage](skills/usage/) | Live usage % + reset countdown in the status bar | [→ details](skills/usage/README.md) |

---

## For humans

Browse the skills above, open the folder of the one you want, and follow its README.

**Requirements for all skills:** `jq` must be installed.
```bash
sudo apt install jq   # Ubuntu/Debian
brew install jq       # macOS
```

---

## For AI agents

To install a specific skill on behalf of a user, read its README inside `skills/<name>/` for the exact install command.

**Quick reference — install `usage`:**
```bash
curl -fsSL https://raw.githubusercontent.com/93carlosmesa/claude-code-skills/main/skills/usage/install-single.sh | bash
```

Each skill's installer handles everything automatically: copies files, updates `settings.json`, sets permissions. No manual steps needed.

---

> Personal collection — not accepting external submissions.
