#!/usr/bin/env sh
# agr-launchpad — install all base plugins via the Claude Code CLI.
#
# This is the "one command" alternative to approving the on-folder-trust prompts.
# It adds the two third-party marketplaces, then installs all six plugins.
# Safe to re-run; already-installed plugins are skipped by Claude Code.
set -eu

if ! command -v claude >/dev/null 2>&1; then
  echo "error: the 'claude' CLI isn't on your PATH." >&2
  echo "Install Claude Code first: https://claude.com/claude-code" >&2
  exit 1
fi

bold() { printf '\033[1m%s\033[0m\n' "$1"; }

bold "1/2 · Adding marketplaces"
# claude-plugins-official is built in; the two below are third-party. '|| true' keeps
# the script going if a marketplace is already known.
claude plugin marketplace add mksglu/context-mode    || true
claude plugin marketplace add thedotmack/claude-mem   || true

bold "2/2 · Installing plugins"
for p in \
  superpowers@claude-plugins-official \
  skill-creator@claude-plugins-official \
  frontend-design@claude-plugins-official \
  code-review@claude-plugins-official \
  context-mode@context-mode \
  claude-mem@thedotmack
do
  printf '  → %s\n' "$p"
  claude plugin install "$p" || echo "    (skipped — already installed or unavailable)"
done

echo
bold "Done. Restart Claude Code, then run /plugin (or 'claude plugin list') to confirm."
