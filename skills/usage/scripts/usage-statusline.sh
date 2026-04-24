#!/bin/bash
# Claude Usage Statusline
# Shows: [agent] context% | 5h rate + reset | 7d rate + reset
# Also caches Claude Code context JSON for the /usage skill.
#
# Optional agent label detection (in priority order):
#   1. Env var CLAUDE_AGENT_LABEL  — overrides everything
#   2. Config file $HOME/.claude/agents.conf  (format: pattern|label per line,
#      # comments allowed). First matching pattern wins.
#   3. Generic: cwd matches */agents/<name>/ or */<n>.agents/<name>/
#   4. No label (just metrics — original behavior)

input=$(cat)

# Cache for /usage skill
echo "$input" > /tmp/claude-usage-cache.json 2>/dev/null

cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty' 2>/dev/null)
ctx_used=$(echo "$input" | jq -r '.context_window.used_percentage // empty' 2>/dev/null)
five=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty' 2>/dev/null)
five_reset=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty' 2>/dev/null)
week=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty' 2>/dev/null)
week_reset=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty' 2>/dev/null)

detect_agent() {
  [ -n "$CLAUDE_AGENT_LABEL" ] && { echo "$CLAUDE_AGENT_LABEL"; return; }

  local conf="${CLAUDE_AGENTS_CONF:-$HOME/.claude/agents.conf}"
  if [ -f "$conf" ] && [ -n "$cwd" ]; then
    while IFS='|' read -r pattern label; do
      [ -z "$pattern" ] && continue
      case "$pattern" in \#*) continue ;; esac
      case "$cwd" in
        *"$pattern"*) echo "$label"; return ;;
      esac
    done < "$conf"
  fi

  if [ -n "$cwd" ] && [[ "$cwd" =~ /[0-9]*\.?agents/([^/]+) ]]; then
    local name="${BASH_REMATCH[1]}"
    echo "🤖 ${name^}"
    return
  fi
}

colorize() {
  local pct="$1" label="$2" suffix="$3"
  if [ "$pct" -ge 90 ]; then echo "🔴 ${label}:${pct}%${suffix}"
  elif [ "$pct" -ge 70 ]; then echo "🟡 ${label}:${pct}%${suffix}"
  else echo "🟢 ${label}:${pct}%${suffix}"
  fi
}

time_remaining() {
  local resets_at="$1"
  [ -z "$resets_at" ] && return
  local now reset_ts diff d h m
  now=$(date +%s)
  if [[ "$resets_at" =~ ^[0-9]+$ ]]; then
    reset_ts="$resets_at"
  else
    reset_ts=$(date -d "$resets_at" +%s 2>/dev/null || date -j -f "%Y-%m-%dT%H:%M:%S" "${resets_at%%.*}" +%s 2>/dev/null)
  fi
  [ -z "$reset_ts" ] && return
  diff=$(( reset_ts - now ))
  [ "$diff" -le 0 ] && echo "resetting" && return
  d=$(( diff / 86400 ))
  h=$(( (diff % 86400) / 3600 ))
  m=$(( (diff % 3600) / 60 ))
  if [ "$d" -gt 0 ]; then echo "${d}d ${h}h"
  elif [ "$h" -gt 0 ]; then echo "${h}h ${m}m"
  else echo "${m}m"
  fi
}

append() { out="${out:+$out   }$1"; }

out=""
agent_str=$(detect_agent)
[ -n "$agent_str" ] && append "$agent_str"

if [ -n "$ctx_used" ]; then
  append "$(colorize "$(printf '%.0f' "$ctx_used")" ctx "")"
fi

if [ -n "$five" ]; then
  r=$(time_remaining "$five_reset")
  append "$(colorize "$(printf '%.0f' "$five")" 5h "${r:+ ↺${r}}")"
fi

if [ -n "$week" ]; then
  r=$(time_remaining "$week_reset")
  append "$(colorize "$(printf '%.0f' "$week")" 7d "${r:+ ↺${r}}")"
fi

echo "$out"
