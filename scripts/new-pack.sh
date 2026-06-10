#!/usr/bin/env sh
# agr-launchpad — scaffold a new pack from packs/_template.
#   scripts/new-pack.sh <name>
set -eu

ROOT="$(CDPATH= cd "$(dirname "$0")/.." && pwd)"
TEMPLATE="$ROOT/packs/_template"
NAME="${1:-}"

die() { echo "error: $*" >&2; exit 1; }
[ -n "$NAME" ] || die "usage: new-pack.sh <name>"
echo "$NAME" | grep -Eq '^[a-z][a-z0-9-]*$' || die "pack name must be lowercase letters/digits/hyphens, e.g. 'ml' or 'ios-app'."
DEST="$ROOT/packs/$NAME"
[ -e "$DEST" ] && die "packs/$NAME already exists."
[ -d "$TEMPLATE" ] || die "packs/_template is missing."

cp -R "$TEMPLATE" "$DEST"

# fill the id/name in pack.json
python3 - "$DEST/pack.json" "$NAME" <<'PY'
import json, sys
path, name = sys.argv[1], sys.argv[2]
m = json.load(open(path))
m["id"] = name
m["name"] = name.replace("-", " ").title() + " Pack"
m["description"] = f"TODO: describe the {name} pack."
json.dump(m, open(path, "w"), indent=2)
open(path, "a").write("\n")
PY

echo "Scaffolded packs/$NAME from _template."
echo "Next: edit packs/$NAME/, then run  make use-pack name=$NAME"
