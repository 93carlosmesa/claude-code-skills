Show Claude usage stats from cache. Run this bash command and display the results formatted:

```bash
if [ -f /tmp/claude-usage-cache.json ]; then
  cat /tmp/claude-usage-cache.json | jq '{
    five_hour: .rate_limits.five_hour,
    seven_day: .rate_limits.seven_day,
    context: {
      used: .context_window.used_percentage,
      remaining: .context_window.remaining_percentage
    }
  }' 2>/dev/null
else
  echo "No data yet — statusline needs at least one response to populate the cache."
fi
```

Format the output as a clear dashboard with percentages, color indicators (🟢 <70%, 🟡 70-90%, 🔴 >90%), and reset times in human-readable format (use system timezone).
