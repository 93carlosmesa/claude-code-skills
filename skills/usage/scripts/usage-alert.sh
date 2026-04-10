#!/bin/bash
# usage-alert.sh — Stop hook: warns in chat when usage crosses thresholds
#
# Output to stdout → becomes a user message Claude responds to.
# Uses a state file to avoid alerting on every response (only fires once per level).
#
# Thresholds configurable via environment variables:
#   USAGE_WARN_PCT  — warning level (default: 80)
#   USAGE_STOP_PCT  — critical level (default: 90)
#
# Example for a shared/limited account (e.g. max 50%):
#   export USAGE_WARN_PCT=40 USAGE_STOP_PCT=50

CACHE="/tmp/claude-usage-cache.json"
STATE="/tmp/claude-usage-alert-state"

WARN_PCT="${USAGE_WARN_PCT:-80}"
STOP_PCT="${USAGE_STOP_PCT:-90}"

# No data yet, nothing to do
[ ! -f "$CACHE" ] && exit 0

five=$(jq -r '.rate_limits.five_hour.used_percentage // empty' "$CACHE" 2>/dev/null)
week=$(jq -r '.rate_limits.seven_day.used_percentage // empty' "$CACHE" 2>/dev/null)

[ -z "$five" ] && [ -z "$week" ] && exit 0

five_int=$(printf '%.0f' "${five:-0}")
week_int=$(printf '%.0f' "${week:-0}")

# Highest current usage across both windows
max=$five_int
[ "$week_int" -gt "$max" ] && max=$week_int

# Determine target alert level
level=0
[ "$max" -ge "$WARN_PCT" ] && level="$WARN_PCT"
[ "$max" -ge "$STOP_PCT" ] && level="$STOP_PCT"

# Read last alerted level (default 0)
last=$(cat "$STATE" 2>/dev/null || echo 0)

# If usage dropped back below warn threshold, reset state silently
if [ "$level" -eq 0 ]; then
  echo "0" > "$STATE"
  exit 0
fi

# Already alerted at this level or higher → stay silent
[ "$level" -le "$last" ] && exit 0

# Save new level
echo "$level" > "$STATE"

# Build per-window detail
detail=""
[ -n "$five" ] && detail="5h: ${five_int}%"
[ -n "$week" ] && detail="${detail:+$detail  |  }7d: ${week_int}%"

if [ "$level" -ge "$STOP_PCT" ]; then
  cat <<EOF
⚠️ **CRITICAL USAGE — ${level}%** ($detail)
Reached the ${STOP_PCT}% threshold. Consider stopping this session to preserve your token budget.
Do you want to continue or stop here?
EOF
else
  cat <<EOF
⚠️ **Usage warning — ${level}%** ($detail)
At ${level}% usage (limit: ${STOP_PCT}%). Getting close — do you want to continue or pause the session?
EOF
fi
