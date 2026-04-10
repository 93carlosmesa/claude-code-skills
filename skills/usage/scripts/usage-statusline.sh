#!/bin/bash
# Claude Usage Statusline
# Reads rate_limits from Claude Code context and displays usage percentages
# Also caches data for /usage command

input=$(cat)

# Cache for /usage command
echo "$input" > /tmp/claude-usage-cache.json 2>/dev/null

five=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty' 2>/dev/null)
week=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty' 2>/dev/null)

out=""
if [ -n "$five" ]; then
  five_int=$(printf '%.0f' "$five")
  if [ "$five_int" -ge 90 ]; then
    out="🔴5h:${five_int}%"
  elif [ "$five_int" -ge 70 ]; then
    out="🟡5h:${five_int}%"
  else
    out="🟢5h:${five_int}%"
  fi
fi

if [ -n "$week" ]; then
  week_int=$(printf '%.0f' "$week")
  if [ "$week_int" -ge 90 ]; then
    week_str="🔴7d:${week_int}%"
  elif [ "$week_int" -ge 70 ]; then
    week_str="🟡7d:${week_int}%"
  else
    week_str="🟢7d:${week_int}%"
  fi
  out="${out:+$out }$week_str"
fi

echo "$out"
