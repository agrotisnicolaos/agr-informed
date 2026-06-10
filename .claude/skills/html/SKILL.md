---
name: html
description: Use to produce a standalone single-file HTML artifact — dashboards, data visualizations, embeddable charts, printable reports — that opens by double-click with no build step. Owns artifact packaging and data-wiring; defers visual/design-token decisions to frontend-design.
metadata:
  origin: first-party
  domain: viz
---

# html

Author self-contained HTML artifacts. This skill owns **packaging + data-wiring**; it composes
rather than duplicates:
- **`frontend-design`** (global) owns visual taste / design tokens — the source of aesthetics.
- **`dashboard-builder`** (ECC, vendored) covers operator dashboards on Grafana/SigNoz — prefer it
  for live observability dashboards; use this skill for standalone, no-server artifacts.

## Output contract
- **Single file:** inline CSS + JS, CDN-pinned libraries (chart.js / d3 / plotly — pin exact
  versions), no build step, opens by double-click, works offline.
- **Quality bar:** responsive; accessible (semantic tags, ARIA, sufficient contrast); graceful
  empty/error states; no external state stores.
- **First-class use cases:** data dashboards and visualizations; clean print/PDF; embeddable charts.

## Method
1. Pull aesthetic direction from `frontend-design` **before** building.
2. Wire the data: inline it, or load a sibling `data.json`. Gather any data via `ctx_execute`.
3. Build one file; verify it renders offline and is responsive; check the empty-data path.

## Verification
Produce one standalone dashboard HTML that renders offline and is responsive; show how it composes
`frontend-design` rather than overlapping it.
