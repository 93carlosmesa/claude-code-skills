#!/bin/bash
# Claude Usage Statusline
# Reads rate_limits from Claude Code context and displays usage percentages + reset countdown
# Also caches data for /usage command

input=$(cat)

# Cache for /usage command
echo "$input" > /tmp/claude-usage-cache.json 2>/dev/null

ctx_used=$(echo "$input" | jq -r '.context_window.used_percentage // empty' 2>/dev/null)

five=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty' 2>/dev/null)
five_reset=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty' 2>/dev/null)
week=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty' 2>/dev/null)
week_reset=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty' 2>/dev/null)

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
  local d=$(( diff / 86400 ))
  local h=$(( (diff % 86400) / 3600 ))
  local m=$(( (diff % 3600) / 60 ))
  if [ "$d" -gt 0 ]; then
    echo "${d}d ${h}h"
  elif [ "$h" -gt 0 ]; then
    echo "${h}h ${m}m"
  else
    echo "${m}m"
  fi
}

out=""

# Context window usage (only shown after first API call)
if [ -n "$ctx_used" ]; then
  ctx_int=$(printf '%.0f' "$ctx_used")
  if [ "$ctx_int" -ge 90 ]; then
    ctx_str="🔴 ctx:${ctx_int}%"
  elif [ "$ctx_int" -ge 70 ]; then
    ctx_str="🟡 ctx:${ctx_int}%"
  else
    ctx_str="🟢 ctx:${ctx_int}%"
  fi
  out="$ctx_str"
fi

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
  week_remaining=$(time_remaining "$week_reset")
  week_countdown="${week_remaining:+ ↺${week_remaining}}"
  if [ "$week_int" -ge 90 ]; then
    week_str="🔴 7d:${week_int}%${week_countdown}"
  elif [ "$week_int" -ge 70 ]; then
    week_str="🟡 7d:${week_int}%${week_countdown}"
  else
    week_str="🟢 7d:${week_int}%${week_countdown}"
  fi
  out="${out:+$out   }$week_str"
fi

echo "$out"
