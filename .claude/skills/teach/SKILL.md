---
name: teach
description: Explain a concept from a briefing in the simplest possible terms, pitched at the user's level — works with a concept name, a report HTML file, or a YouTube URL. Use when the user says /teach <something>, "what is X", "explain X simply", or "teach me X" about something that appeared in a briefing or video.
---

# /teach — learn something new, simply

The user saw something unfamiliar (in a briefing, a video, anywhere) and wants
to actually understand it. Your job: the clearest possible explanation, pitched
at *their* level, grounded in *their* context.

## Gather context (in order, use what exists)

1. `profile.md` — their role and AI level set the pitch. No profile → assume
   smart beginner, zero jargon.
2. **If they gave a concept name only:** find it in the latest report
   (`ls -t reports/*.html | head -1` — the briefing JSON is embedded in a
   `<script id="briefing-data">` tag) and in `data/transcripts/*.md`
   (grep for the term). The transcripts show how real practitioners used it —
   gold for concrete examples.
3. **If they gave a report file:** read its embedded briefing JSON; if a concept
   wasn't specified, list the report's main concepts and ask which one.
4. **If they gave a YouTube URL:** fetch the transcript on the fly:
   ```bash
   python3 -c "
   import sys; sys.path.insert(0,'pipeline')
   from transcripts import fetch_transcript
   print(fetch_transcript('VIDEO_ID') or 'no transcript')"
   ```
5. Only search the web if local context is insufficient or the term needs
   up-to-date facts.

## Teach (the format)

Keep the whole thing under ~350 words. Structure:

1. **One-sentence version** — what it is, no jargon at all.
2. **The analogy** — one concrete everyday analogy that actually maps
   (no "it's like a brain" hand-waving; the analogy must explain the mechanism).
3. **Why it exists** — what problem it solves; what people did before.
4. **What you saw** — connect to where it appeared: "In the briefing,
   <creator> used it to <thing> — that works because…", with the video link
   and timestamp if available.
5. **Try it in 5 minutes** — 2-3 steps the user can do right now at their
   level with their tools.

Then offer: "Want to go one level deeper, or see how it relates to <adjacent
concept from their briefing>?" — keep teaching conversationally as long as
they want.

## Rules

- Match `profile.md` level: beginner → zero acronyms unexpanded; advanced →
  skip basics, focus on what's genuinely new about it.
- Never bluff. If the transcripts and your knowledge disagree, say which is
  newer and verify with a web search.
- This skill also works standalone (e.g. invoked on claude.ai with a report
  file attached): everything degrades gracefully without the repo — explain
  from the attached file alone.
