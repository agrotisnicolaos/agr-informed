---
name: briefing
description: Generate the daily AI-intelligence briefing — fetch new videos from sources.txt, download transcripts, cluster by novelty/contrarian/relevance, render the magazine report. Use when the user says /briefing, "run my briefing", "what's new in AI today", or a scheduled run triggers it.
---

# /briefing — generate the daily briefing

You are the analyst. Scripts fetch data deterministically; **you** do the thinking:
clustering, novelty detection, and writing. The result is a beautiful self-contained
HTML report the user reads in 3 minutes.

## Step 1 — Fetch

```bash
python3 pipeline/discover.py        # new videos since last run (first run: 3 days)
python3 pipeline/transcripts.py     # downloads transcripts to data/transcripts/
```

- If discover reports **0 new videos**: tell the user "You're fully caught up — no new videos since the last briefing" and STOP. Do not fabricate a report.
- If a channel fails repeatedly, mention it at the end but continue.

## Step 2 — Load context

1. Read `profile.md` (user's role, level, interests). If it doesn't exist, note that
   the briefing will be generic and suggest running `/setup` afterwards.
2. Read `data/queue.json` for the video list.

## Step 3 — Digest transcripts

Transcripts live in `data/transcripts/<video_id>.md` with `[mm:ss]` markers.

- **≤ 8 videos:** read each transcript yourself.
- **> 8 videos:** dispatch parallel Task subagents (general-purpose), each handling
  5-6 transcripts. Each subagent reads its transcripts and returns, per video:
  key claims (with `[mm:ss]` of the strongest moment), anything genuinely NEW
  (release/capability/technique), any CONTRARIAN take (and what consensus it
  contradicts), tools demonstrated (not just mentioned), and one quotable insight.
  You then work from these notes.

## Step 4 — Cluster and analyze

This is the core value. Work **across** sources, not per-video:

- **Cluster** stories: multiple creators covering the same theme = one cluster.
  A single important video can be its own cluster. 3-6 clusters total. Order by
  relevance to the user's profile.
- **Badge** each cluster with exactly one of:
  - `NOVEL` — genuinely new capability, release, or technique (not a rehash)
  - `CONTRARIAN` — credibly argues against current consensus
  - `TOOLS` — practical tool/workflow demonstrated end-to-end
  - `NEWS` — notable announcements/events
  - `LEARNING` — evergreen technique worth studying
- **why_it_matters** must be specific to the user's profile, not generic
  ("You're building client automations — this replaces the n8n pattern you use").
- Demand evidence: prefer creators who *demo* over creators who *react*.
  If everyone is just reacting to the same announcement, say so — that IS the signal.
- Leftover minor-but-interesting items → `quick_hits` (max 6). Drop pure filler;
  the 3% that matters is the product. It is fine to drop most videos.
- **The Brief** is two bullet lists, written for readers with very little
  attention span — every bullet earns its place:
  - `whats_new`: 3-5 bullets, each ONE crisp sentence naming a concrete
    development, with `refs` pointing at the cluster id(s) it comes from.
  - `act`: 2-4 bullets, each an imperative the reader can do this week
    ("Watch X's 4-min setup, then…"), tailored to the profile.

## Step 5 — Update the wiki (second brain)

Read `wiki/SCHEMA.md` and follow it exactly: update/create topic pages for
today's clusters, refresh `wiki/index.md`, append to `wiki/log.md`. Then read
`state/runs.json` — if this will be run ≥ 7, derive `connections` (2-4 sharp
ones, or none) per the schema's quality bar. Every ~10 runs, also run the
schema's lint pass.

## Step 6 — Write data/briefing.json

```json
{
  "date": "YYYY-MM-DD",
  "title": "One evocative line naming today's theme",
  "stats": {"videos": 12, "channels": 8, "hours_covered": 4.5},
  "brief": {
    "whats_new": [
      {"text": "One-sentence development", "refs": ["cluster-id"]}
    ],
    "act": [
      {"text": "Imperative, doable this week", "refs": ["cluster-id"]}
    ]
  },
  "clusters": [
    {
      "id": "kebab-case-slug",
      "badge": "NOVEL",
      "headline": "Editorial headline, max ~10 words",
      "why_it_matters": "One sentence, tailored to the user's profile",
      "about": ["1-2 bullets: what was shown/argued, concretely"],
      "helps": ["1-2 bullets: what this lets the reader do"],
      "start": ["1-2 numbered first steps, only if actionable"],
      "sources": [
        {
          "channel": "Ben AI",
          "title": "full video title",
          "video_id": "abc123",
          "note": "what THIS source adds, ~8 words",
          "timestamp": "04:12",
          "seconds": 252
        }
      ]
    }
  ],
  "quick_hits": [
    {"text": "One-line item", "video_id": "abc123", "channel": "Jeff Su"}
  ],
  "connections": [
    {"kind": "builds_on|contradicts|reinforces|new_thread",
     "topic": "wiki-topic-slug",
     "text": "Cites the specific earlier finding and what changed today"}
  ]
}
```

Rules: every bullet ≤ ~18 words — scannable, not prose. `about`/`helps` required,
`start` optional (omit when there's nothing to do). `seconds` = timestamp as
integer seconds. First source in a cluster is the lead (thumbnail). First
cluster is the feature story. `hours_covered` ≈ 15 min/video if unknown.
Omit `connections` entirely before run 7 (render.py tracks runs and shows a
warming-up bar automatically).

## Step 7 — Render and deliver

```bash
python3 pipeline/render.py
open "reports/$(date +%Y-%m-%d).html"
```

Confirm to the user in 2-3 lines: how many videos processed, the top story,
and the report path. Remind them: ★ saves a story, `/teach <concept>` explains
anything unfamiliar.
