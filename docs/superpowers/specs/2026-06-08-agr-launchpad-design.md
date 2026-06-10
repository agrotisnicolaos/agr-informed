# agr-launchpad — design spec

**Date:** 2026-06-08
**Status:** Approved (brainstorming + grill-me)
**Location:** `/Users/nicolasagrotis/Projects/agr-launchpad` — fresh repo, independent of `agr-starter`.

## Purpose

A clean, robust Claude Code starter repository to share with friends and family. Cloned from
GitHub, it gives the recipient a versatile, solid foundation — the most useful general-purpose
skills, plugins, MCP servers, and agents — so they can build whatever they have in mind. It is the
*starting place*. Project-specific capability is layered on top via a `packs/` system (ML, iOS,
journal, …) that the owner builds out over time.

Design principle for the base: **lean universal core**. Domain-specific assets are NOT in the base;
they live in packs.

## Distribution model

`git clone` → open in Claude Code → trust folder → approve plugin installs → approve MCP servers →
build. Designed so the least-technical recipient can follow it. No build step, no compiler.

## Decisions (resolved via grilling)

| Decision | Resolution |
| --- | --- |
| Relationship to agr-starter | Fresh build; borrow only universal assets |
| Distribution | GitHub repo they clone |
| Pack system | In-repo `packs/` + installer script |
| Base curation | Lean universal core only |
| Pack scope (now) | Mechanism + empty `_template` only |
| Repo name | `agr-launchpad` |
| Onboarding | README **and** rich `onboarding.html` |
| Dashboard | Excluded (keep base lean) |
| GitHub MCP token | Env var + documented `.env.example` |
| gsd delivery | Documented external install; assume user installs it |

## Plugin & MCP delivery (verified against live Claude Code config)

**Declarative plugins** — `.claude/settings.json` `enabledPlugins` + `extraKnownMarketplaces`.
On folder-trust, Claude Code prompts to add marketplaces and install plugins (~3 clicks).

Enabled plugins:
- `superpowers@claude-plugins-official`
- `skill-creator@claude-plugins-official`
- `frontend-design@claude-plugins-official`
- `code-review@claude-plugins-official`  ← provides `/code-review` incl. ultra review
- `context-mode@context-mode`  (marketplace `mksglu/context-mode`)
- `claude-mem@thedotmack`  (marketplace `thedotmack/claude-mem`)

`extraKnownMarketplaces`: `context-mode` → `mksglu/context-mode`; `thedotmack` →
`thedotmack/claude-mem`. (`claude-plugins-official` is a built-in known marketplace.)

**Not declarative — documented external installs:**
- **gsd** — installed as global skills/hooks under `~/.claude/`, not a marketplace plugin. Onboarding
  documents its install; the repo assumes the user runs it.
- **BioInfo/vscode-markitdown** — a VS Code extension. Recommended via `.vscode/extensions.json`
  and documented in onboarding (any-file → Markdown conversion).

**MCP servers** — committed `.mcp.json`, approved once interactively after folder-trust:
- `context7` — live library/framework docs.
- `github` — GitHub API; token via `${GITHUB_PAT}` from `.env` (gitignored). `.env.example` shipped.
- `jupyter` — Datalayer `jupyter-mcp-server`; token via `${JUPYTER_TOKEN:-agr-local-dev}`;
  `make jupyter` starts the kernel.

## Bundled (zero-install) assets — base

`.claude/skills/` (vendored as plain `SKILL.md`, auto-discovered):
- `grill-me` — relentless plan/design interview.
- `coding-standards` — universal code quality conventions.
- `error-handling` — defensive error-handling patterns.
- `html` — single-file styled HTML artifacts.
- `dashboard-builder` — quick local dashboards.
- `code-tour` — guided codebase walkthroughs.
- `skill-stocktake` — audit/inventory the skill set.

`.claude/agents/` — a small set of universal subagents (general explore/review helpers) if a clean
domain-agnostic one exists in the source repo; otherwise omit rather than ship domain-coupled ones.

Source for vendored skills: the existing `agr-starter/skills/` (universal ones only). Licenses
carried into `ATTRIBUTIONS.md`.

## Pack system

A pack is a self-contained capability bundle:

```
packs/<name>/
  pack.json            id, description, version, lists of skills/agents, mcp servers, requires
  skills/<skill>/SKILL.md
  agents/<agent>.md
  mcp.partial.json     MCP servers to merge into .mcp.json
  CLAUDE.pack.md       rulebook fragment appended to active context
  README.md            what the pack is + how to use
```

Installer behavior (`scripts/use-pack.sh <name>`, exposed as `make use-pack name=<name>`):
1. Copy `packs/<name>/skills/*` → `.claude/skills/`.
2. Copy `packs/<name>/agents/*` → `.claude/agents/`.
3. Merge `packs/<name>/mcp.partial.json` servers into `.mcp.json` (no duplicate keys).
4. Append `CLAUDE.pack.md` to a managed block in `CLAUDE.md` (idempotent, marker-delimited).
5. Record the active pack in `manifests/active-packs.json`.

Scaffolder (`scripts/new-pack.sh <name>` / `make new-pack name=<name>`): copies `_template` to
`packs/<name>` with placeholders filled.

**Ships with only `_template` populated** — empty, fully documented, ready to copy. `packs/README.md`
describes the model and names ML / iOS / journal as future examples.

Scripts are POSIX `sh`, defensive (`set -eu`), idempotent, and merge JSON via `python3` (always
present on macOS) — no jq dependency.

## CLAUDE.md

The recipient-facing rulebook is the user-provided 4-principle text verbatim (Think Before Coding,
Simplicity First, Surgical Changes, Goal-Driven Execution). The `use-pack` managed block is appended
below it under clear markers; the 4 principles are never edited by tooling.

## Onboarding

- `README.md` — GitHub landing: one-paragraph what/why, prerequisites, the clone→trust→approve→build
  quickstart, link to `docs/onboarding.html`, pack system in brief, attribution.
- `docs/onboarding.html` — single-file, self-styled, no external assets. Sections: what this is;
  prerequisites (Claude Code, Node, optional gsd); the exact setup flow with the prompts they'll see;
  what each plugin does; what each MCP does; using a pack; building a pack; markitdown; gsd;
  troubleshooting; FAQ. Verified by rendering before claiming done (anti-pattern rule).

## Out of scope (YAGNI)

No dashboard, no second-brain/memory layer, no gstack/ECC residue, no pre-built domain packs, no CI,
no compiled components, no fake gsd plugin shim.

## Success criteria

1. `agr-launchpad` is a standalone git repo with no agr-starter coupling.
2. A fresh clone + folder-trust surfaces install prompts for all 6 declarative plugins and the 2
   marketplaces (verified by inspecting `.claude/settings.json` against live identifiers).
3. `.mcp.json` lists context7 + github + jupyter with env-var tokens; `.env.example` present;
   `.env` gitignored.
4. The 7 base skills are present and valid (`SKILL.md` with name + description frontmatter).
5. `make use-pack` and `make new-pack` run against `_template` without error (round-trip test:
   scaffold a throwaway pack, install it, confirm files land, then remove it).
6. README renders on GitHub; `onboarding.html` renders correctly in a browser (visually verified).
7. CLAUDE.md contains the 4 principles verbatim.
8. ATTRIBUTIONS.md credits every vendored skill, jupyter-mcp-server, and markitdown.
