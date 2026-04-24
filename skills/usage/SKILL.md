---
name: usage
description: Real-time Claude usage dashboard — context %, 5h/7d rate limits with reset countdown, and active agent label. No cookies, no scraping — reads the Claude Code session JSON already on disk.
version: 1.1.0
metadata:
  openclaw:
    emoji: 📊
    homepage: https://github.com/93carlosmesa/claude-code-skills/tree/main/skills/usage
    requires:
      bins: [jq]
    os: [linux, macos]
---
Run this and print the stdout verbatim (it is already formatted):

```bash
[ -s /tmp/claude-usage-cache.json ] \
  && "${CLAUDE_USAGE_STATUSLINE:-$HOME/.claude/scripts/usage-statusline.sh}" < /tmp/claude-usage-cache.json \
  || echo "no cache yet — install the statusline with: curl -fsSL https://raw.githubusercontent.com/93carlosmesa/claude-code-skills/main/skills/usage/install-single.sh | bash"
```
