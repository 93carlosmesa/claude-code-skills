#!/bin/bash
# claude-code-skills — usage skill standalone installer
# Installs only the usage skill without cloning the full repo
# Usage: curl -fsSL https://raw.githubusercontent.com/93carlosmesa/claude-code-skills/main/skills/usage/install-single.sh | bash

set -e

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

BASE_URL="https://raw.githubusercontent.com/93carlosmesa/claude-code-skills/main/skills/usage"
CLAUDE_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"

echo ""
echo "  Installing claude-code-skills/usage..."
echo ""

# Check dependencies
if ! command -v jq &> /dev/null; then
  echo -e "${RED}Error: jq is required.${NC}"
  echo "  Ubuntu/Debian:  sudo apt install jq"
  echo "  macOS:          brew install jq"
  exit 1
fi

if [ ! -d "$CLAUDE_DIR" ]; then
  echo -e "${RED}Error: Claude Code not found at $CLAUDE_DIR${NC}"
  echo "  Install Claude Code first: https://claude.ai/code"
  exit 1
fi

# Create dirs
mkdir -p "$CLAUDE_DIR/scripts" "$CLAUDE_DIR/commands"

# Download files
curl -fsSL "$BASE_URL/scripts/usage-statusline.sh" -o "$CLAUDE_DIR/scripts/usage-statusline.sh"
chmod +x "$CLAUDE_DIR/scripts/usage-statusline.sh"
echo -e "  ${GREEN}✓${NC} Statusline script installed"

curl -fsSL "$BASE_URL/scripts/usage-alert.sh" -o "$CLAUDE_DIR/scripts/usage-alert.sh"
chmod +x "$CLAUDE_DIR/scripts/usage-alert.sh"
echo -e "  ${GREEN}✓${NC} Alert hook script installed"

curl -fsSL "$BASE_URL/commands/usage.md" -o "$CLAUDE_DIR/commands/usage.md"
echo -e "  ${GREEN}✓${NC} /usage command installed"

# Update settings.json
SETTINGS="$CLAUDE_DIR/settings.json"
STATUS_CMD="bash $CLAUDE_DIR/scripts/usage-statusline.sh"
ALERT_CMD="bash $CLAUDE_DIR/scripts/usage-alert.sh"

if [ -f "$SETTINGS" ]; then
  tmp=$(mktemp)
  jq --arg status "$STATUS_CMD" --arg alert "$ALERT_CMD" '
    . + {
      "statusLine": {"type": "command", "command": $status},
      "hooks": ((.hooks // {}) + {
        "Stop": ([
          (.hooks.Stop // [])[] | select(.hooks[0].command != $alert)
        ] + [{
          "hooks": [{"type": "command", "command": $alert, "timeout": 5}]
        }])
      })
    }
  ' "$SETTINGS" > "$tmp" && mv "$tmp" "$SETTINGS"
else
  jq -n --arg status "$STATUS_CMD" --arg alert "$ALERT_CMD" '{
    "statusLine": {"type": "command", "command": $status},
    "hooks": {
      "Stop": [{"hooks": [{"type": "command", "command": $alert, "timeout": 5}]}]
    }
  }' > "$SETTINGS"
fi
echo -e "  ${GREEN}✓${NC} settings.json updated (statusLine + Stop hook)"

echo ""
echo -e "  ${GREEN}Done!${NC} Restart Claude Code to activate."
echo ""
echo "  Status bar will show:  🟢 5h:22% ↺2h 30m   🟢 7d:39%"
echo "  Alerts fire in chat at 80% and 90% — once per threshold."
echo "  Type /usage for the full dashboard."
echo ""
