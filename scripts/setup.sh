#!/usr/bin/env sh
# agr-launchpad — first-time setup guide. Prints the few manual steps; safe to run repeatedly.
set -eu
ROOT="$(CDPATH= cd "$(dirname "$0")/.." && pwd)"
bold() { printf '\033[1m%s\033[0m\n' "$1"; }

bold "== agr-launchpad setup =="
echo "Most of the setup happens automatically when you open this folder in Claude Code and TRUST it."
echo "This script just covers the handful of manual bits."
echo

bold "1. Secrets (.env)"
if [ -f "$ROOT/.env" ]; then
  echo "   .env already exists — good."
else
  cp "$ROOT/.env.example" "$ROOT/.env"
  echo "   Created .env from .env.example. Open it and add a GitHub token if you want the GitHub MCP."
fi
echo

bold "2. Plugins"
cat <<'EOF'
   These live in your global Claude setup, not in the repo — so the repo pre-configures them
   and Claude Code installs them for you. Two ways:
     A) Trust the folder and approve the prompts (superpowers, skill-creator, frontend-design,
        code-review, context-mode, claude-mem), OR
     B) Run one command:   make install-plugins
   Confirm with /plugin  (or 'claude plugin list').
EOF
echo

bold "3. MCP servers (one approval)"
cat <<'EOF'
   .mcp.json ships context7 + github + jupyter. After trusting the folder, approve them when asked
   (or run `claude mcp list`). The GitHub one needs GITHUB_PAT in your .env.
EOF
echo

bold "4. gsd (optional, installed separately — NOT a repo plugin)"
cat <<'EOF'
   gsd ("get sh*t done") is a planning toolkit installed globally into ~/.claude, not via this repo.
   Install it from its project per its README, then its /gsd-* commands appear in every project.
EOF
echo

bold "5. markitdown VS Code extension (optional)"
cat <<'EOF'
   Converts PDFs/Office/HTML/images to clean Markdown. VS Code will recommend it automatically
   (.vscode/extensions.json). Or install from https://github.com/BioInfo/vscode-markitdown
EOF
echo

bold "6. Live notebooks (optional)"
echo "   Run 'make jupyter' to start a local kernel for the jupyter MCP."
echo
bold "Done. Restart Claude Code after approving plugins/MCP so everything loads."
