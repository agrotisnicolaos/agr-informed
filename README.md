# agr-launchpad

**A batteries-included starting point for building anything with [Claude Code](https://claude.com/claude-code).**

Clone it, open it, approve a few prompts — and you have a solid, versatile setup: the most useful
general-purpose skills, plugins, MCP servers, and agents, ready to go. It's the *starting place*.
When you start a specific kind of project (ML, an iOS app, a journal…), you add a **pack** on top.

> New here? Open **[`docs/onboarding.html`](docs/onboarding.html)** in your browser — it's a friendly,
> step-by-step guide written for non-developers.

## Quickstart

1. **Install prerequisites:** [Claude Code](https://claude.com/claude-code) and [Node.js](https://nodejs.org) (LTS).
2. **Clone & open:**
   ```bash
   git clone <your-fork-url> agr-launchpad
   cd agr-launchpad
   ```
   Open the folder in Claude Code (or VS Code with the Claude Code extension).
3. **Install the plugins.** Trust the folder and **approve** the install prompts, *or* run one command:
   ```bash
   make install-plugins
   ```
   (Plugins live in your global Claude setup, so they can't ship pre-installed in a repo — this repo
   just pre-configures them. Confirm with `/plugin` or `claude plugin list`.)
4. **Approve the MCP servers** when asked (context7, github, jupyter). Check with `claude mcp list`.
5. **Add secrets (optional):** `cp .env.example .env`, then paste a GitHub token if you want the
   GitHub MCP. Run `make setup` for a guided walkthrough.
6. **Restart Claude Code.** You're ready — just start describing what you want to build.

## What you get out of the box

**Plugins** (auto-offered on folder-trust, or `make install-plugins`):
- **superpowers** — disciplined workflows: brainstorming, planning, TDD, debugging, verification.
- **skill-creator** — build your own skills.
- **frontend-design** — distinctive, production-grade UI (by Anthropic).
- **code-review** — `/code-review` for diff review, plus `/code-review ultra` cloud multi-agent review.
- **context-mode** — keeps big tool output out of the context window.
- **claude-mem** — persistent memory across sessions.

**MCP servers** (`.mcp.json`): **context7** (live docs), **github** (your repos/issues/PRs),
**jupyter** (live notebooks — `make jupyter`).

**Bundled skills** (zero-install, in `.claude/skills/`): `grill-me`, `coding-standards`,
`error-handling`, `html`, `dashboard-builder`, `code-tour`, `skill-stocktake`.

**Bundled agents:** `architect`, `code-architect`, `code-explorer`.

**Installed separately** (see onboarding): **gsd** planning toolkit, **markitdown** VS Code extension.

## Packs

The base stays lean. Add project-specific capability with packs:

```bash
make list-packs              # see what's available
make new-pack name=ml        # scaffold a new pack from the template
make use-pack name=ml        # install a pack into the active config
make unuse-pack name=ml      # remove it
```

A pack bundles skills, agents, MCP servers, plugins, or a rulebook fragment. Local packs live in
`packs/` (only `_template` ships populated). Published packs install from the **agr·hub** marketplace
— already pre-registered here — with one command:

```
/plugin install <pack>@agr-hub
```

Browse available packs and projects at **[agrotisnicolaos.github.io/agr-hub](https://agrotisnicolaos.github.io/agr-hub/)**.
See [`packs/README.md`](packs/README.md) for building your own.

## Conventions

`CLAUDE.md` holds four behavioral principles (Think Before Coding · Simplicity First · Surgical
Changes · Goal-Driven Execution) that apply to every project. Packs append to it; the principles
stay put.

## Attribution

See [`ATTRIBUTIONS.md`](ATTRIBUTIONS.md). Licenses belong to their respective upstream authors.
