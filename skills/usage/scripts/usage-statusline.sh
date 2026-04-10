#!/bin/bash
# Claude Usage Statusline
# Reads rate_limits from Claude Code context and displays usage percentages + reset countdown
# Also caches data for /usage command

input=$(cat)

# Cache for /usage command
echo "$input" > /tmp/claude-usage-cache.json 2>/dev/null

five=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty' 2>/dev/null)
five_reset=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty' 2>/dev/null)
week=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty' 2>/dev/null)

# Calculate time remaining until reset
time_remaining() {
  local resets_at="$1"
  [ -z "$resets_at" ] && return
  local now
  now=$(date +%s)
  local reset_ts
  # Handle both Unix timestamp (number) and ISO string
  if [[ "$resets_at" =~ ^[0-9]+$ ]]; then
    reset_ts="$resets_at"
  else
    reset_ts=$(date -d "$resets_at" +%s 2>/dev/null || date -j -f "%Y-%m-%dT%H:%M:%S" "${resets_at%%.*}" +%s 2>/dev/null)
  fi
  [ -z "$reset_ts" ] && return
  local diff=$(( reset_ts - now ))
  [ "$diff" -le 0 ] && echo "resetting" && return
  local h=$(( diff / 3600 ))
  local m=$(( (diff % 3600) / 60 ))
  if [ "$h" -gt 0 ]; then
    echo "${h}h ${m}m"
  else
    echo "${m}m"
  fi
}

out=""
if [ -n "$five" ]; then
  five_int=$(printf '%.0f' "$five")
  remaining=$(time_remaining "$five_reset")
  countdown="${remaining:+ ↺${remaining}}"
  if [ "$five_int" -ge 90 ]; then
    out="🔴 5h:${five_int}%${countdown}"
  elif [ "$five_int" -ge 70 ]; then
    out="🟡 5h:${five_int}%${countdown}"
  else
    out="🟢 5h:${five_int}%${countdown}"
  fi
fi

if [ -n "$week" ]; then
  week_int=$(printf '%.0f' "$week")
  if [ "$week_int" -ge 90 ]; then
    week_str="🔴 7d:${week_int}%"
  elif [ "$week_int" -ge 70 ]; then
    week_str="🟡 7d:${week_int}%"
  else
    week_str="🟢 7d:${week_int}%"
  fi
  out="${out:+$out   }$week_str"
fi

echo "$out"
