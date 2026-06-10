#!/usr/bin/env bash
# agr-launchpad — local Jupyter kernel for the `jupyter` MCP server (.mcp.json).
#
# Starts a token-protected JupyterLab on 127.0.0.1:8888 that Datalayer's jupyter-mcp-server
# drives (read/write/execute/surgically-edit .ipynb cells). Run `make jupyter`, leave it running,
# then talk to Claude about your notebook.
#
# Token: defaults to a LOCAL-ONLY dev token (`agr-local-dev`); override with JUPYTER_TOKEN. The
# server binds to 127.0.0.1, so it is not reachable from other machines. If you override the token,
# export the SAME value in the shell that launches Claude Code so the MCP server can authenticate.

set -euo pipefail

PORT="${JUPYTER_PORT:-8888}"
TOKEN="${JUPYTER_TOKEN:-agr-local-dev}"
VENV="${JUPYTER_VENV:-.jupyter-venv}"

bold() { printf '\033[1m%s\033[0m\n' "$1"; }

if ! command -v uv >/dev/null 2>&1; then
  echo "ERROR: 'uv' not found. Install it first:" >&2
  echo "  pip install uv      # or: curl -LsSf https://astral.sh/uv/install.sh | sh" >&2
  exit 1
fi

if [ ! -x "$VENV/bin/jupyter" ]; then
  bold "Creating $VENV and installing the Jupyter stack (first run only)…"
  uv venv "$VENV"
  uv pip install --python "$VENV/bin/python" \
    "jupyterlab==4.4.1" "jupyter-collaboration==4.0.2" "jupyter-mcp-tools>=0.1.4" ipykernel pycrdt
fi

bold "Starting JupyterLab → http://127.0.0.1:${PORT}  (token: ${TOKEN})"
echo "  The 'jupyter' MCP server (.mcp.json) connects here. Leave this running; Ctrl-C to stop."
echo "  Override the token with JUPYTER_TOKEN (export the same value before launching Claude Code)."
exec "$VENV/bin/jupyter" lab \
  --port "$PORT" \
  --ip 127.0.0.1 \
  --no-browser \
  --IdentityProvider.token "$TOKEN"
