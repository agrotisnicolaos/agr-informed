---
name: agr-setup
description: First-run setup for agr-informed — check dependencies, interview the user to build profile.md, confirm sources. Use when the user says /setup, /agr-setup, "set up my briefing", or runs /briefing without a profile.
---

# /agr-setup — first-run setup

Goal: in ~3 minutes the user has working dependencies, a personal profile, and
confirmed sources. Be warm and brief — many users are non-developers.

## Step 1 — Dependencies

```bash
python3 --version && yt-dlp --version
```

If yt-dlp is missing: `brew install yt-dlp` (macOS) or `pip3 install --user yt-dlp`.
If brew is also missing, guide them to https://brew.sh first. Verify after install.

## Step 2 — Profile interview

Ask these one at a time (AskUserQuestion where natural, free text welcome):

1. **Role** — what do you do? (e.g. founder, PM, developer, student, consultant)
2. **AI level** — beginner / intermediate / advanced? (calibrates explanations and
   how much jargon the briefing may assume)
3. **Building/doing** — what are you currently building or trying to achieve with AI?
4. **Care about** — topics to prioritize (e.g. agents, coding tools, automations,
   making money with AI, research)
5. **Ignore** — topics to filter out (e.g. crypto, drama, GPU rumors)

Write the answers to `profile.md`:

```markdown
# My profile
- Role: ...
- AI level: ...
- Currently building: ...
- Prioritize: ...
- Ignore: ...
- Briefing voice: simple, concrete, no hype
```

profile.md is gitignored — it stays private on this machine.

## Step 3 — Sources

Show the current `sources.txt` channel list. Ask if they want to add/remove any
(any YouTube URL form works). Apply edits directly.

## Step 4 — Finish

Offer to run the first briefing now (`/briefing` — first run covers the last
3 days). Mention `/schedule-briefing` for automation and `/teach` for learning.
