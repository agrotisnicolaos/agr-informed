# Wiki schema — the second brain

This wiki is the project's persistent, compounding knowledge base, built on
Andrej Karpathy's LLM-wiki pattern: **the LLM writes and maintains all of it;
the user only reads it and asks questions against it.** Knowledge is compiled
once at ingest and kept current — never re-derived from raw transcripts.

This file is the contract. Every `/briefing` run MUST follow it.

## Layout

```
wiki/
  SCHEMA.md         ← this file (committed; everything else is gitignored/private)
  index.md          ← catalog: every page, one-line current state, last updated
  log.md            ← one appended line per briefing run (provenance)
  topics/<slug>.md  ← one living page per concept, tool, model, or trend
```

## Topic page format

```markdown
# <Topic name>

- aka: <aliases / related terms>
- first seen: YYYY-MM-DD · last updated: YYYY-MM-DD
- related: [[other-topic]], [[another-topic]]

## What it is
1-3 sentences, plain language, kept current (rewrite when understanding improves).

## Timeline
- YYYY-MM-DD — <claim/development> (<channel>, [video](url))
- (append-only; newest at the bottom)

## Current state
The living synthesis: where this stands today. REWRITE this section each time
the picture changes — this is the section that compounds.

## Contradictions & open questions
- <claim A> vs <claim B> (who said what, when) — unresolved/resolved on <date>
```

## Ingest rules (every /briefing run)

1. Read `wiki/index.md` first to know what already exists. Never create a
   duplicate page for an alias — extend the existing page and add the alias.
2. For each cluster and radar item in today's briefing:
   - Update existing topic pages: append Timeline entries, rewrite Current
     state if it changed, file contradictions explicitly.
   - Create a new topic page only for things likely to recur (tools, models,
     patterns, recurring debates) — not for one-off news.
3. Update `index.md` (add new pages, refresh one-liners and dates).
4. Append one line to `log.md`:
   `- YYYY-MM-DD — run N · X videos · pages touched: [[a]], [[b]], [[c]]`
5. Slugs: kebab-case (`agent-os.md`, `mcp.md`, `fable-5.md`). Cross-link with
   `[[slug]]` wherever topics relate.
6. Be honest in Timeline entries: distinguish "X demoed Y" from "X claimed Y".
7. Radar items get a Timeline entry on their topic page marked `(radar)`. When
   a radar-tracked topic recurs and gets promoted to a story cluster, note the
   promotion in its Timeline ("promoted from radar, first spotted YYYY-MM-DD")
   — this powers "first spotted on your radar" callouts in reports.

## Connections rules (the report section)

After updating the wiki, if `state/runs.json` shows **7 or more runs**, derive
2-4 connections for `briefing.json` by diffing today's claims against the wiki:

- `builds_on` — today's development extends something previously filed
- `contradicts` — today's claim conflicts with a filed claim (name both sides)
- `reinforces` — an earlier weak signal got independent confirmation today
- `new_thread` — a genuinely new topic worth tracking opened today

Quality bar: a connection must cite the specific earlier finding ("On Jun 9,
Ben AI showed X — today's Y replaces that approach"), not just note repetition
("MCP was mentioned again" is NOT a connection). Fewer, sharper connections
beat filler. Zero is acceptable.

## Maintenance (lint)

Every ~10 runs, health-check the wiki: contradictions between pages, stale
Current state sections superseded by newer Timeline entries, orphan pages with
no inbound links, concepts mentioned across 3+ pages that deserve their own
page, missing cross-links. Fix what you find; note the lint in log.md.
