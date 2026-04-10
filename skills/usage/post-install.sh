#!/bin/bash
# Post-install: add statusLine to Claude Code settings.json

CLAUDE_DIR="$1"
SETTINGS="$CLAUDE_DIR/settings.json"
STATUS_CMD="bash $CLAUDE_DIR/scripts/usage-statusline.sh"

if [ -f "$SETTINGS" ]; then
  tmp=$(mktemp)
  jq --arg cmd "$STATUS_CMD" '. + {"statusLine": {"type": "command", "command": $cmd}}' "$SETTINGS" > "$tmp" && mv "$tmp" "$SETTINGS"
else
  jq -n --arg cmd "$STATUS_CMD" '{"statusLine": {"type": "command", "command": $cmd}}' > "$SETTINGS"
fi

echo -e "  \033[0;32m✓\033[0m settings.json updated"
