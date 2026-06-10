# Attributions

agr-launchpad bundles a small set of vendored skills/agents and points at several external plugins,
MCP servers, and tools. Credit and licenses below.

## Vendored skills (in `.claude/skills/`)

| Skill | Origin | Notes |
| --- | --- | --- |
| `grill-me` | Adapted from [mattpocock/skills](https://github.com/mattpocock/skills) (MIT) | Relentless plan/design interview. |
| `coding-standards` | ECC community skills | Universal code conventions. |
| `error-handling` | ECC community skills | Defensive error-handling patterns. |
| `code-tour` | ECC community skills | Guided codebase walkthroughs. |
| `skill-stocktake` | ECC community skills | Skill inventory/audit. |
| `html` | first-party | Single-file styled HTML artifacts. |
| `dashboard-builder` | first-party | Quick local dashboards. |

## Vendored agents (in `.claude/agents/`)

`architect`, `code-architect`, `code-explorer` — adapted from ECC community agents. Domain-agnostic
planning/exploration subagents.

## External plugins (installed via Claude Code, not bundled here)

- **superpowers**, **skill-creator**, **frontend-design**, **code-review** — `claude-plugins-official`
  marketplace (`anthropics/claude-plugins-official`).
- **context-mode** — by Mert Köseoğlu, marketplace `mksglu/context-mode`.
- **claude-mem** — by Alex Newman (thedotmack), marketplace `thedotmack/claude-mem`.
- **gsd** — "get sh*t done" planning toolkit, installed separately into `~/.claude`.

Each plugin is governed by its own upstream license.

## MCP servers (referenced in `.mcp.json`)

- **context7** — Upstash `@upstash/context7-mcp`.
- **github** — `@modelcontextprotocol/server-github`.
- **jupyter** — Datalayer [`jupyter-mcp-server`](https://github.com/datalayer/jupyter-mcp-server) (BSD-3-Clause).

## Tools

- **vscode-markitdown** — [BioInfo/vscode-markitdown](https://github.com/BioInfo/vscode-markitdown),
  a VS Code wrapper around Microsoft's [markitdown](https://github.com/microsoft/markitdown).

If any attribution here is incomplete or incorrect, please open an issue — it will be fixed promptly.
