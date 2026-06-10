# Template Pack

The starting point for a new pack. A **pack** is a self-contained bundle of project-specific
capability that you layer on top of the lean base starter when you start a particular kind of
project (e.g. ML, iOS, journal).

## Anatomy

```
packs/<name>/
  pack.json            # manifest: id, description, lists of skills/agents/mcp, requirements
  skills/<skill>/SKILL.md   # skills added to .claude/skills/ on install
  agents/<agent>.md         # subagents added to .claude/agents/ on install
  mcp.partial.json     # MCP servers merged into .mcp.json on install
  CLAUDE.pack.md       # rulebook fragment appended to CLAUDE.md on install
  README.md            # what the pack is and how to use it
```

## Make your own

```bash
make new-pack name=ml      # scaffolds packs/ml from this template
# …edit packs/ml/…
make use-pack name=ml      # installs it into the active .claude/ config + .mcp.json + CLAUDE.md
make unuse-pack name=ml    # removes it again
```

Everything a pack installs is reversible. `make use-pack` never overwrites an existing MCP server
key and edits `CLAUDE.md` only inside the managed `AGR-LAUNCHPAD:PACKS` markers.
