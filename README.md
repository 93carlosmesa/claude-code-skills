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
git clone https://github.com/93carlosmesa/claude-code-skills.git /tmp/ccs-$$ && bash /tmp/ccs-$$/install.sh usage
```

### 3. Restart Claude Code

The status bar will appear automatically on the next session.

---

## For AI agents

To install a skill on behalf of a user, run this single command:

```bash
git clone https://github.com/93carlosmesa/claude-code-skills.git /tmp/ccs-$$ && bash /tmp/ccs-$$/install.sh usage
```

The installer handles everything: copies files, updates `settings.json`, sets permissions. `jq` must be available on the system — install it first if needed (`sudo apt install jq`).

To see all available skills:

```bash
bash /tmp/ccs-$$/install.sh --list
```

---

## Available skills

| Skill | What it does |
|-------|-------------|
| `usage` | Shows real-time Claude usage % in the status bar — no cookies, no config |

---

> Personal collection — not accepting external submissions.
