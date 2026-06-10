#!/usr/bin/env sh
# agr-launchpad — install or remove a pack.
#   scripts/use-pack.sh <name>            install pack <name>
#   scripts/use-pack.sh --remove <name>   remove pack <name>
#   scripts/use-pack.sh --list            list available + installed packs
#
# Reversible and idempotent. Merges pack skills/agents/MCP/rulebook into the active config.
set -eu

ROOT="$(CDPATH= cd "$(dirname "$0")/.." && pwd)"
PACKS_DIR="$ROOT/packs"
SKILLS_DIR="$ROOT/.claude/skills"
AGENTS_DIR="$ROOT/.claude/agents"
MCP_FILE="$ROOT/.mcp.json"
CLAUDE_FILE="$ROOT/CLAUDE.md"
ACTIVE="$ROOT/manifests/active-packs.json"
MARK_START="<!-- AGR-LAUNCHPAD:PACKS:START -->"
MARK_END="<!-- AGR-LAUNCHPAD:PACKS:END -->"

die() { echo "error: $*" >&2; exit 1; }
command -v python3 >/dev/null 2>&1 || die "python3 is required (used for JSON merge)."

list_packs() {
  echo "Available packs:"
  for d in "$PACKS_DIR"/*/; do
    name="$(basename "$d")"
    [ "$name" = "_template" ] && continue
    echo "  - $name"
  done
  echo "Installed packs:"
  if [ -f "$ACTIVE" ]; then
    python3 -c "import json;print('\n'.join('  - '+p for p in json.load(open('$ACTIVE')).get('packs',[])) or '  (none)')"
  else
    echo "  (none)"
  fi
}

# ---- arg parsing ----
MODE=install
case "${1:-}" in
  --list|-l) list_packs; exit 0 ;;
  --remove|-r) MODE=remove; shift ;;
  "") die "usage: use-pack.sh <name> | --remove <name> | --list" ;;
esac
NAME="${1:-}"
[ -n "$NAME" ] || die "missing pack name."
[ "$NAME" = "_template" ] && die "_template is a scaffold, not an installable pack. Use new-pack.sh."
PACK="$PACKS_DIR/$NAME"
[ -d "$PACK" ] || die "no pack named '$NAME' in packs/."
[ -f "$PACK/pack.json" ] || die "packs/$NAME has no pack.json."

mkdir -p "$ROOT/manifests" "$SKILLS_DIR" "$AGENTS_DIR"

# ---- helpers ----
merge_mcp() {
  # merge pack mcp.partial.json into .mcp.json; never overwrite an existing server key
  partial="$PACK/mcp.partial.json"
  [ -f "$partial" ] || return 0
  python3 - "$MCP_FILE" "$partial" <<'PY'
import json, sys
mcp_path, partial_path = sys.argv[1], sys.argv[2]
mcp = json.load(open(mcp_path))
add = json.load(open(partial_path)).get("mcpServers", {})
servers = mcp.setdefault("mcpServers", {})
for k, v in add.items():
    if k in servers:
        print(f"  mcp: '{k}' already present — skipped")
    else:
        servers[k] = v
        print(f"  mcp: + {k}")
json.dump(mcp, open(mcp_path, "w"), indent=2)
open(mcp_path, "a").write("\n")
PY
}

unmerge_mcp() {
  partial="$PACK/mcp.partial.json"
  [ -f "$partial" ] || return 0
  python3 - "$MCP_FILE" "$partial" <<'PY'
import json, sys
mcp_path, partial_path = sys.argv[1], sys.argv[2]
mcp = json.load(open(mcp_path))
rem = json.load(open(partial_path)).get("mcpServers", {})
servers = mcp.get("mcpServers", {})
for k in rem:
    if servers.pop(k, None) is not None:
        print(f"  mcp: - {k}")
json.dump(mcp, open(mcp_path, "w"), indent=2)
open(mcp_path, "a").write("\n")
PY
}

# rewrite the managed CLAUDE.md block from the set of installed packs' CLAUDE.pack.md
rebuild_claude_block() {
  python3 - "$CLAUDE_FILE" "$ACTIVE" "$PACKS_DIR" "$MARK_START" "$MARK_END" <<'PY'
import json, os, sys, re
claude_path, active_path, packs_dir, m0, m1 = sys.argv[1:6]
packs = json.load(open(active_path)).get("packs", []) if os.path.exists(active_path) else []
frags = []
for name in packs:
    f = os.path.join(packs_dir, name, "CLAUDE.pack.md")
    if os.path.exists(f):
        frags.append(open(f).read().rstrip() + "\n")
body = "\n".join(frags)
note = "<!-- Installed packs append their rulebook fragments below this line. Managed by scripts/use-pack.sh — do not edit by hand. -->"
block = m0 + "\n" + note + "\n" + (("\n" + body) if body else "") + m1
text = open(claude_path).read()
pat = re.compile(re.escape(m0) + r".*?" + re.escape(m1), re.S)
if pat.search(text):
    text = pat.sub(block, text)
else:
    text = text.rstrip() + "\n\n" + block + "\n"
open(claude_path, "w").write(text)
PY
}

set_active() {  # $1 = add|remove
  python3 - "$ACTIVE" "$NAME" "$1" <<'PY'
import json, os, sys
active_path, name, op = sys.argv[1], sys.argv[2], sys.argv[3]
data = json.load(open(active_path)) if os.path.exists(active_path) else {"packs": []}
packs = data.get("packs", [])
if op == "add" and name not in packs:
    packs.append(name)
if op == "remove" and name in packs:
    packs.remove(name)
data["packs"] = packs
json.dump(data, open(active_path, "w"), indent=2)
open(active_path, "a").write("\n")
PY
}

copy_assets() {  # install: copy skills + agents
  if [ -d "$PACK/skills" ]; then
    for s in "$PACK/skills"/*/; do
      [ -d "$s" ] || continue
      cp -R "$s" "$SKILLS_DIR/$(basename "$s")"
      echo "  skill: + $(basename "$s")"
    done
  fi
  if [ -d "$PACK/agents" ]; then
    for a in "$PACK/agents"/*.md; do
      [ -f "$a" ] || continue
      cp "$a" "$AGENTS_DIR/$(basename "$a")"
      echo "  agent: + $(basename "$a" .md)"
    done
  fi
}

remove_assets() {
  if [ -d "$PACK/skills" ]; then
    for s in "$PACK/skills"/*/; do
      [ -d "$s" ] || continue
      rm -rf "$SKILLS_DIR/$(basename "$s")"
      echo "  skill: - $(basename "$s")"
    done
  fi
  if [ -d "$PACK/agents" ]; then
    for a in "$PACK/agents"/*.md; do
      [ -f "$a" ] || continue
      rm -f "$AGENTS_DIR/$(basename "$a")"
      echo "  agent: - $(basename "$a" .md)"
    done
  fi
}

# ---- run ----
if [ "$MODE" = install ]; then
  echo "Installing pack: $NAME"
  copy_assets
  merge_mcp
  set_active add
  rebuild_claude_block
  reqs="$(python3 -c "import json;print(json.load(open('$PACK/pack.json')).get('requires',{}).get('notes',''))" 2>/dev/null || true)"
  [ -n "${reqs:-}" ] && echo "  note: $reqs"
  echo "Done. Restart Claude Code so it picks up new skills/agents/MCP."
else
  echo "Removing pack: $NAME"
  remove_assets
  unmerge_mcp
  set_active remove
  rebuild_claude_block
  echo "Done. Restart Claude Code."
fi
