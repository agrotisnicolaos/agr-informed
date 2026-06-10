# agr-informed

**Let AI keep up with AI.** Your favorite YouTube creators publish ~30 hours of AI
content a week. agr-informed turns it into a beautiful 3-minute morning briefing —
clustered across sources, filtered for what's novel, contrarian, and relevant to *you*.

No API keys. No servers. No cost beyond the paid Claude account you already have:
**Claude Code is the brain.** Transcripts are fetched with free public tools, and your
Claude subscription does the analysis.

Inspired by Dave Killeen's intake system (as shared by Aakash Gupta): he follows
60 channels and 120 newsletters and reads none of them — his system does.

## Quickstart

1. Install [Claude Code](https://claude.com/claude-code) (any paid Claude plan).
2. Clone and open:
   ```bash
   git clone https://github.com/agrotisnicolaos/agr-informed.git
   cd agr-informed && claude
   ```
3. Run `/agr-setup` — checks dependencies (installs `yt-dlp`), interviews you to build
   your profile, and confirms your channel list.
4. Run `/briefing` — your first report opens in the browser.

## The commands

| Command | What it does |
|---|---|
| `/briefing` | Fetch everything new since last run → cluster → render today's report |
| `/agr-setup` | First-run setup: dependencies + profile interview |
| `/sources` | Add/remove/list YouTube channels (any URL form, or just "add Matt Wolfe") |
| `/agr-schedule` | Automate it: every morning via launchd, Claude cloud routine, or manual |
| `/teach <concept>` | Saw something unfamiliar? Get it explained simply, at your level |

## How it works

```
sources.txt ──▶ discover.py ──▶ transcripts.py ──▶ Claude Code ──▶ render.py ──▶ reports/YYYY-MM-DD.html
(your channels)  (RSS, no keys)  (yt-dlp subs)     (clusters,      (magazine
                                                    novelty,        template)
                                                    your profile)
```

- **Deterministic scripts** (`pipeline/`) fetch new videos via YouTube RSS (with a
  yt-dlp fallback for channels whose feeds are broken) and download transcripts.
- **Claude does the thinking**: clusters stories *across* sources, badges them
  (NOVEL / CONTRARIAN / TOOLS / NEWS / LEARNING), writes a scannable brief
  (What's new / How to act on it), and scores relevance against your `profile.md`.
- **The report** is a single self-contained HTML file: thumbnail-forward magazine
  layout, bulleted story cards (about / why it helps / get started), timestamp
  deep-links into each video, ★ bookmarks (saved in your browser), and a
  saved-stories filter. Share it by sending the file — it works anywhere.

## The second brain (wiki)

Every briefing is also filed into a private, Karpathy-style LLM wiki
(`wiki/topics/*.md`): one living page per concept, tool, or trend, with a dated
timeline, a current-state synthesis, and explicitly flagged contradictions.
Claude maintains it; you just read it — or ask questions against it.

After 7 runs, reports gain a **🧠 Second Brain — Connections** section showing
how today's news *builds on*, *contradicts*, or *reinforces* earlier findings.
Until then, reports show a warming-up progress bar. See `wiki/SCHEMA.md` for
the conventions.

## Privacy

Everything stays on your machine. `data/`, `reports/`, `state/`, and `profile.md`
and the wiki are gitignored. Sharing is opt-in: you send the HTML file, or you choose the
cloud-routine scheduler knowing reports get committed to your repo.

## Make it yours

- Edit `sources.txt` — one YouTube URL per line. That's the whole config.
- Edit `profile.md` — the relevance filter. Better profile, sharper briefings.
- Fork it. Anyone with a paid Claude account can run their own in 5 minutes.

---

Built with [Claude Code](https://claude.com/claude-code) on top of
[agr-launchpad](https://github.com/agrotisnicolaos/agr-launchpad).
See `ATTRIBUTIONS.md` for bundled-skill credits.
