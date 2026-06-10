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
- **TL;DR**: exactly 2 paragraphs. Paragraph 1: today's strongest signal and why.
  Paragraph 2: the pattern across sources + what to do about it. Write like a
  sharp analyst briefing a friend, not a press release.

## Step 5 — Write data/briefing.json

```json
{
  "date": "YYYY-MM-DD",
  "title": "One evocative line naming today's theme",
  "stats": {"videos": 12, "channels": 8, "hours_covered": 4.5},
  "tldr": ["paragraph 1", "paragraph 2"],
  "clusters": [
    {
      "id": "kebab-case-slug",
      "badge": "NOVEL",
      "headline": "Editorial headline, max ~10 words",
      "why_it_matters": "One sentence, tailored to the user's profile",
      "summary": "2-4 sentences of substance: what was shown, what's actually new",
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
  ]
}
```

Rules: `seconds` = timestamp converted to integer seconds (link target).
First source in a cluster is the lead (its thumbnail is shown). First cluster
is the feature story — make it the strongest one. `hours_covered` ≈ sum of video
lengths (estimate 15 min/video if unknown), one decimal.

## Step 6 — Render and deliver

```bash
python3 pipeline/render.py
open "reports/$(date +%Y-%m-%d).html"
```

Confirm to the user in 2-3 lines: how many videos processed, the top story,
and the report path. Remind them: ★ saves a story, `/teach <concept>` explains
anything unfamiliar.
