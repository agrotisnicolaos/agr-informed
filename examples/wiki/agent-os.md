# Agent OS (personal agent operating system)

- aka: agentic OS, AIOS, command center, second-brain dashboard
- first seen: 2026-06-09 · last updated: 2026-06-09
- related: [[claude-managed-agents]], [[claude-subagents]], [[hermes-agent]]

## What it is
The pattern of wrapping an LLM (usually Claude) in a persistent personal system —
skills for deterministic behavior, MCP/CLI connectors for reach, and memory that
compounds — instead of using it as a stateless chat window.

## Timeline
- 2026-06-09 — Ben AI demoed three builds (live artifacts, Obsidian overlay, custom web app) and argued 80% of the value is the personalized daily overview; recommended starting with Obsidian (Ben AI, [video](https://www.youtube.com/watch?v=1x32W8zAtrg))
- 2026-06-09 — Liam Ottley ran the same architecture (Claude skills + Notion + Apify + Higgsfield MCPs) as a one-person creative agency with a live competitor-scraping loop (Liam Ottley, [video](https://www.youtube.com/watch?v=3BatQW63C8g))

## Current state
Three creators converged on this blueprint independently in one week — strong
consensus signal, not one influencer's framing. The recommended entry point is
deliberately low-tech (Obsidian overlay) rather than custom web apps. Selling
the pattern to clients runs through [[claude-managed-agents]].

## Contradictions & open questions
- Ben AI claims web dashboards are worse ROI than Obsidian despite being more flexible — untested against teams who already live in browsers.
