---
name: usage
description: Real-time Claude usage % and reset countdown in the status bar. No cookies, no scraping — reads data already in your Claude Code session.
version: 1.0.0
metadata:
  openclaw:
    emoji: 📊
    homepage: https://github.com/93carlosmesa/claude-code-skills/tree/main/skills/usage
    requires:
      bins: [jq]
    os: [linux, macos]
---

Show Claude usage stats. First check if `/tmp/claude-usage-cache.json` exists and has data.

If the cache exists, run this and display the results as a clean dashboard:

```bash
cat /tmp/claude-usage-cache.json | jq '{five_hour: .rate_limits.five_hour, seven_day: .rate_limits.seven_day, context: {used: .context_window.used_percentage, remaining: .context_window.remaining_percentage}}' 2>/dev/null
```

Format the output showing:
- 5-hour window: usage % and time until reset
- 7-day window: usage % and time until reset  
- Context window: % used and % remaining
- Color indicators: 🟢 <70%  🟡 70-90%  🔴 >90%

If the cache is empty or missing, the statusline has not populated it yet. In that case, offer to install the statusline so it appears automatically on every response:

```bash
curl -fsSL https://raw.githubusercontent.com/93carlosmesa/claude-code-skills/main/skills/usage/install-single.sh | bash
```

The statusline will then show live in the Claude Code status bar:
```
🟢 5h:32% ↺3h 15m   🟢 7d:8% ↺5d 0h
```
