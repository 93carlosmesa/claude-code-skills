#!/bin/bash
# usage-alert.sh — Stop hook: warns in chat when usage crosses 80% or 90%
#
# Output to stdout → becomes a user message Claude responds to.
# Uses a state file to avoid alerting on every response (only fires once per level).

CACHE="/tmp/claude-usage-cache.json"
STATE="/tmp/claude-usage-alert-state"

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
[ "$max" -ge 80 ] && level=80
[ "$max" -ge 90 ] && level=90

# Read last alerted level (default 0)
last=$(cat "$STATE" 2>/dev/null || echo 0)

# If usage dropped back below 80%, reset state silently
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
if [ -n "$five" ]; then
  detail="ventana 5h: ${five_int}%"
fi
if [ -n "$week" ]; then
  detail="${detail:+$detail  |  }ventana 7d: ${week_int}%"
fi

if [ "$level" -ge 90 ]; then
  cat <<EOF
⚠️ **USO CRÍTICO — +90%** ($detail)
Estás muy cerca del límite de tokens. Puedo parar aquí o continuar con precaución.
¿Quieres que siga o prefieres dejar la sesión por ahora?
EOF
else
  cat <<EOF
⚠️ **Aviso de uso — +80%** ($detail)
Llevamos bastante consumo. ¿Continuamos o prefieres pausar la sesión para no agotar el límite?
EOF
fi
