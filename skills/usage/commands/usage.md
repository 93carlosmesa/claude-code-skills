Run this and print the stdout verbatim (it is already formatted):

```bash
[ -s /tmp/claude-usage-cache.json ] \
  && "${CLAUDE_USAGE_STATUSLINE:-$HOME/.claude/scripts/usage-statusline.sh}" < /tmp/claude-usage-cache.json \
  || echo "no cache yet — statusline needs at least one response to populate /tmp/claude-usage-cache.json"
```
