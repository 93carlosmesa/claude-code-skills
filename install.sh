#!/bin/bash
# claude-code-skills installer
# Usage: bash install.sh <skill-name>
# Usage: bash install.sh --list
# Repo: https://github.com/93carlosmesa/claude-code-skills

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

SKILLS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/skills" && pwd)"
CLAUDE_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"

list_skills() {
  echo ""
  echo -e "${BOLD}Available skills:${NC}"
  echo ""
  for skill in "$SKILLS_DIR"/*/; do
    name=$(basename "$skill")
    desc=$(head -3 "$skill/README.md" 2>/dev/null | grep -v "^#" | head -1 | sed 's/^[[:space:]]*//')
    echo -e "  ${GREEN}$name${NC}  —  $desc"
  done
  echo ""
}

install_skill() {
  local skill="$1"
  local skill_dir="$SKILLS_DIR/$skill"

  if [ ! -d "$skill_dir" ]; then
    echo -e "${RED}Error: skill '$skill' not found.${NC}"
    echo "Run 'bash install.sh --list' to see available skills."
    exit 1
  fi

  echo ""
  echo -e "  Installing ${BOLD}$skill${NC}..."
  echo ""

  # Check jq dependency
  if ! command -v jq &> /dev/null; then
    echo -e "${RED}Error: jq is required.${NC}"
    echo "  Ubuntu/Debian:  sudo apt install jq"
    echo "  macOS:          brew install jq"
    exit 1
  fi

  # Check Claude Code is installed
  if [ ! -d "$CLAUDE_DIR" ]; then
    echo -e "${RED}Error: Claude Code config not found at $CLAUDE_DIR${NC}"
    echo "Install Claude Code first: https://claude.ai/code"
    exit 1
  fi

  # Copy scripts
  if [ -d "$skill_dir/scripts" ]; then
    mkdir -p "$CLAUDE_DIR/scripts"
    cp "$skill_dir/scripts/"* "$CLAUDE_DIR/scripts/"
    chmod +x "$CLAUDE_DIR/scripts/"*
    echo -e "  ${GREEN}✓${NC} Scripts installed"
  fi

  # Copy commands
  if [ -d "$skill_dir/commands" ]; then
    mkdir -p "$CLAUDE_DIR/commands"
    cp "$skill_dir/commands/"* "$CLAUDE_DIR/commands/"
    echo -e "  ${GREEN}✓${NC} Commands installed"
  fi

  # Run skill-specific post-install if exists
  if [ -f "$skill_dir/post-install.sh" ]; then
    bash "$skill_dir/post-install.sh" "$CLAUDE_DIR"
  fi

  echo -e "  ${GREEN}✓${NC} Done!"
  echo ""

  # Show skill-specific next steps if available
  if [ -f "$skill_dir/INSTALL_NOTE.md" ]; then
    cat "$skill_dir/INSTALL_NOTE.md"
  fi
}

# Parse args
case "${1:-}" in
  --list|-l)
    list_skills
    ;;
  "")
    echo -e "${RED}Usage:${NC} bash install.sh <skill-name>"
    echo "       bash install.sh --list"
    exit 1
    ;;
  *)
    install_skill "$1"
    ;;
esac
