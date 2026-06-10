# The Complete Setup Guide

**agr-informed** turns hours of YouTube content into a beautiful 3-minute morning
briefing — clustered across your favorite channels, filtered for what's *new*,
what's *contrarian*, and what matters *to you specifically*.

This guide assumes **zero technical background**. Every step explains what you're
doing and why. Total setup time: about 20 minutes, most of it answering questions
about yourself.

> 👀 **Want to see the result first?**
> [View an example briefing](https://htmlpreview.github.io/?https://github.com/agrotisnicolaos/agr-informed/blob/main/examples/example-briefing.html) —
> a real one, generated from 30 videos across 12 channels.

**Contents**

1. [What you need](#1-what-you-need)
2. [Install Claude Code](#2-install-claude-code)
3. [Download agr-informed](#3-download-agr-informed)
4. [Open the folder in Claude Code](#4-open-the-folder-in-claude-code)
5. [Run the setup](#5-run-the-setup)
6. [Choose your channels (the most important step)](#6-choose-your-channels)
7. [Your first briefing](#7-your-first-briefing)
8. [Reading your brief](#reading-your-brief)
9. [The second brain, explained](#9-the-second-brain-explained)
10. [Make it run every day](#10-make-it-run-every-day)
11. [Learning mode: /teach](#11-learning-mode-teach)
12. [What NOT to do](#12-what-not-to-do)
13. [Troubleshooting & FAQ](#13-troubleshooting--faq)

---

## 1. What you need

- **A paid Claude account** (Pro or Max — [claude.com](https://claude.com)).
  This is the only cost. There are no API keys to create, no cloud accounts,
  no servers. Your subscription powers the analysis.
- **A computer** — a Mac is the smoothest path (automatic scheduling works
  out of the box); Windows and Linux work too, with small notes where they differ.
- **About 20 minutes.**

**Why no API keys?** Most AI tools ask you to create developer keys and pay per
use. agr-informed instead runs inside *Claude Code* — Anthropic's AI workspace
that's included in your paid plan. The fetching of video transcripts uses free,
public tools. Nothing else is needed.

---

## 2. Install Claude Code

Claude Code is the engine: an AI that can read files, run the pipeline, and
write your reports. Think of it as Claude, installed on your computer.

1. Go to **[claude.com/claude-code](https://claude.com/claude-code)**.
2. Download the app for your system (Mac or Windows) and install it like any
   other app — double-click the downloaded file and follow the prompts.
3. Open it and **sign in with your Claude account** when asked.

That's it. (Developers may prefer the terminal version — both work identically
for this project.)

---

## 3. Download agr-informed

You'll download the project as a simple ZIP file — no special tools needed.

1. Go to **[github.com/agrotisnicolaos/agr-informed](https://github.com/agrotisnicolaos/agr-informed)**.
2. Click the green **`<> Code`** button near the top right.
3. Click **Download ZIP** at the bottom of the menu that opens.
4. Find the downloaded file (usually in your **Downloads** folder) and
   double-click it to unzip. You'll get a folder called `agr-informed-main`.
5. **Move that folder somewhere permanent** — for example into your home folder
   or Documents — and feel free to rename it to just `agr-informed`.

**Why somewhere permanent?** This folder will become your news system: your
channel list, your daily reports, and your growing knowledge wiki all live
inside it. If it sits in Downloads, it's one "clean up my Downloads" away from
being deleted.

---

## 4. Open the folder in Claude Code

1. Open the Claude Code app.
2. Open the folder you just moved:
   - **In the app:** use *Open folder* (or drag the `agr-informed` folder onto
     the app window).
   - **From the terminal** (optional alternative): press `Cmd + Space`
     (Mac) to open Spotlight, type `Terminal`, press `Enter`. In the window that
     appears, type `cd ` (with a space), drag your agr-informed folder onto the
     window (this pastes its location), press `Enter`, then type `claude` and
     press `Enter`.
3. Claude Code will ask if you **trust this folder**. Click yes — this is a
   standard safety prompt shown for any new project. You downloaded this folder
   yourself from GitHub, and everything it contains is open source and
   inspectable.
4. You may also see prompts to enable tools or plugins. You can approve or skip
   them — none are required for agr-informed.

You should now see a chat box. Everything from here on is just *talking to
Claude* — you type short commands, Claude does the work and explains itself.

---

## 5. Run the setup

In the chat box, type:

```
/agr-setup
```

and press Enter. Claude will now:

1. **Check dependencies.** The project needs two small free tools: `python3`
   (almost certainly already on your computer) and `yt-dlp` (the standard
   open-source tool for downloading YouTube captions). If anything is missing,
   Claude installs it for you and tells you what it's doing. Approve the
   commands it suggests.
2. **Interview you to build your profile.** It asks ~5 questions: your role,
   your experience level with the topic, what you're working on, what to
   prioritize, what to ignore. Answer honestly and specifically —
   *"I'm a biology PhD student studying protein folding; ignore investor news"*
   produces dramatically better briefings than *"I like science"*.

   **Why this matters:** the profile is the lens for every single briefing.
   The system reads everything, then asks "why does this matter to *this
   person*?" Your answers are stored in a private file (`profile.md`) on your
   machine and never leave it. You can change them anytime — just edit the file
   or tell Claude.
3. **Show you the current channel list** and offer to change it — which brings
   us to the big one.

---

## 6. Choose your channels

This is where the system becomes *yours*. It works for **any topic** — AI,
science, finance, medicine, woodworking, chess. The machinery doesn't care;
only your channel list and profile define the domain.

### Where your channels go

Your channels live in one simple file: **`sources.txt`** in the project folder —
one YouTube link per line. Two ways to edit it:

- **The easy way:** just tell Claude. `add https://www.youtube.com/@veritasium`
  or even `add the channel called Two Minute Papers` — Claude finds it,
  verifies it, and updates the file. `/sources` shows your current list.
- **The manual way:** open `sources.txt` in any text editor and paste links,
  one per line. Any form works — `@handle` links, `channel/...` links, with or
  without `/videos` at the end. Lines starting with `#` are ignored.

To get a channel's link: open the channel on YouTube, copy what's in your
browser's address bar. That's it.

### How to pick channels — the playbook

The single most important rule:

> **Pick people who *show their work*, not people who react to headlines.**

A practitioner demonstrating something on screen gives the system rich,
verifiable claims with timestamps. A talking head reacting to an announcement
gives it noise. The briefing engine explicitly rewards demos over reactions —
feed it accordingly.

A strong starting list (aim for **8–15 channels**):

| Slot | How many | What to look for | Example (finance) | Example (science) |
|---|---|---|---|---|
| **Practitioners** | 4–6 | People who *do* the thing on camera: build, trade, run experiments, read papers | A fund analyst walking through actual filings | A researcher explaining their own field's papers |
| **Educators** | 2–4 | Structured explainers who teach concepts well | Channel breaking down options mechanics | Two Minute Papers-style digests |
| **News/announcements** | 1–2 | High-volume coverage so you never miss releases | Market-recap channel | Science news channel |
| **Contrarians** | 1–2 | Credible people who disagree with the consensus — this powers the CONTRARIAN badge | A known bear if your feed is bullish | A methods skeptic |

Where to find candidates: your own YouTube subscriptions (start with the ones
you *wish* you watched), "best <your topic> YouTube channels" searches, and the
channels your favorite creators themselves cite.

### Channel-picking rules

- ✅ **Check captions exist.** Open one of their videos → the `CC` button should
  be available. No captions = the system can't read the video. (Auto-generated
  captions are fine and are what most channels have.)
- ✅ **Prefer regular uploaders** (1–5 videos/week). A channel that posts daily
  shorts will flood you; one that posts quarterly adds little.
- ✅ **One domain per install.** If you want both finance *and* AI briefings,
  make two copies of the folder, each with its own channels and profile. Mixing
  domains in one install muddies the clustering and the second brain.
- ❌ Don't start with 40 channels (see [What NOT to do](#12-what-not-to-do)).

---

## 7. Your first briefing

Type:

```
/briefing
```

What happens next, in plain terms:

1. **Discovery** (seconds): the system checks each channel's public feed for
   videos published since the last run. On the very first run it looks back
   3 days.
2. **Transcripts** (1–3 minutes): it downloads the captions for each new video
   into the `data/` folder. No video files are downloaded — just text.
3. **Analysis** (a few minutes): Claude reads everything and does the part no
   script can: groups stories *across* channels, decides what's genuinely new
   vs. recycled, checks it against your profile, and writes the brief.
4. **Your report opens** in the browser, and the findings are filed into your
   second brain (more on that below).

If it says **"you're fully caught up"** — that's a feature, not an error.
No new videos means no briefing to invent.

---

<a name="reading-your-brief"></a>
## 8. Reading your brief

Open the [example briefing](https://htmlpreview.github.io/?https://github.com/agrotisnicolaos/agr-informed/blob/main/examples/example-briefing.html)
side-by-side with this section. From top to bottom:

**The masthead.** The date, plus *Edition Nº* — which run this is. The small
stats line ("30 videos processed · 12 channels") tells you exactly how much
content was distilled, and the line below it ("~7.5h of content distilled to a
3-minute read") is your time saved, every day.

**🆕 What's new (left panel).** The 3–5 developments that actually moved since
your last briefing — one sentence each. The small `#1` `#2` chips jump to the
story tile with the full picture. If you read nothing else, read this panel.

**⚡ How to act on it (right panel, blue).** The same news converted into
concrete moves for *you* — phrased as things you can do this week, based on
your profile. This panel is why the profile interview matters.

**Story clusters.** The day's stories as visual tiles. Anatomy of a tile:

- **The number & badge.** Each story is numbered, and badged with *why it
  deserves your attention*:
  - `NOVEL` — genuinely new (a release, capability, or technique, not a rehash)
  - `CONTRARIAN` — a credible voice arguing against the consensus
  - `TOOLS` — something practical demonstrated end-to-end
  - `NEWS` — notable announcements
  - `LEARNING` — evergreen technique worth studying
- **The ★ star** — bookmark a story; it's remembered by your browser. The
  *★ Saved* button at the top filters to your bookmarks.
- **The headline and the "→" line** — what happened, and why it matters *to you*.
- **Three micro-sections** — *What it's about* (the facts), *Why it helps you*
  (the payoff), *Get started* (numbered first steps, only when there's
  something to actually do).
- **The sources strip** — every channel that covered this story, each with a
  **▸ timestamp pill** that opens the video *at the exact moment* that matters.
  Clicking the thumbnail opens the lead video. Stories covered by multiple
  channels are the strongest signal — independent convergence.

**📡 On the Radar.** Items not big enough for a story *yet* — your early-warning
system. Each carries a tag telling you what to do with it:

- `tool to try` — worth 10 minutes of your time
- `early signal` — might become a story; the system is tracking it
- `claim to verify` — a notable claim with no evidence shown yet
- `contrarian take` — a dissent worth registering

If a radar item keeps showing up, it gets **promoted** to a full story cluster —
and the report will tell you it was "first spotted on your radar" on whatever date.

**🧠 Second Brain.** For your first week this shows a warming-up bar
("run 3 of 7"). From run 7 onward, it shows how today's news **builds on**,
**contradicts**, or **reinforces** what your previous briefings found.
Full explanation next section.

**The 💡 tip and footer.** A reminder that `/teach <anything>` explains
unfamiliar concepts, and a note that the report is one self-contained file —
**to share it, just send the file** (email, WhatsApp, anything). It works
offline, on any device, no account needed.

### Personalizing the brief

Everything above adapts through two files you control:

- **`profile.md`** — change your role, interests, or ignore-list anytime.
  The next briefing immediately reflects it.
- **`sources.txt`** — your channels. Add and remove freely; new channels'
  recent videos appear in the next run.

Or skip the files entirely and just tell Claude:
*"From now on, care less about funding news and more about hands-on tutorials."*

---

## 9. The second brain, explained

Most news tools have amnesia: every day starts from zero. agr-informed instead
maintains a **wiki** — a private knowledge base that compounds, based on
[Andrej Karpathy's LLM-wiki pattern](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f).

Here's what actually happens after each briefing:

1. Claude files every story into **topic pages** — one markdown file per
   concept, tool, or trend, in the `wiki/topics/` folder. A topic page has:
   - **What it is** — a plain-language definition, kept current
   - **Timeline** — dated entries: who claimed/demoed what, when, with links
   - **Current state** — the living synthesis, *rewritten* as understanding evolves
   - **Contradictions & open questions** — when source A disagrees with source B,
     it's recorded, not papered over
2. The **index** (`wiki/index.md`) catalogs every page with a one-line status.
3. From **run 7**, each briefing is compared against the wiki, and genuine
   connections appear in the report: *"Today's X contradicts what Ben AI showed
   on June 9"* — not vague "this was mentioned before" filler.

**You never write the wiki — you ask it questions.** Open the folder in Claude
Code and try:

- *"What does my wiki say about [topic]?"*
- *"What contradictions are still open?"*
- *"Summarize how [tool] evolved over the last month."*

Two example topic pages ship in [`examples/wiki/`](../examples/wiki/) so you can
see the format. Your real wiki is private and never leaves your machine.

---

## 10. Make it run every day

Three options, from simplest to most automatic. Type `/agr-schedule` and Claude
sets up whichever you pick.

**Option A — The morning ritual (no setup).**
Open Claude Code with your coffee, type `/briefing`, read the result 3 minutes
later. Honestly great: you stay in control and it becomes a habit.

**Option B — Automatic on your Mac (recommended).**
Claude installs a small scheduled task (using macOS's built-in scheduler) that
runs the briefing at your chosen time — say 7:30 every morning — even though
Claude Code isn't open. The report just appears in your `reports/` folder.
If your Mac was asleep at 7:30, it runs when it wakes. To change or remove the
schedule, run `/agr-schedule` again.
*(Windows: the equivalent is Task Scheduler — ask Claude to set it up and it
will walk you through the one manual approval Windows requires.)*

**Option C — In the cloud.**
Runs even with your laptop closed, using Claude's scheduled routines — but
reports get committed to your GitHub copy of the project, so only choose this
if you're comfortable with that (and use a private repository).

**Cadence advice:** daily is the sweet spot for 8–15 channels. If your channels
upload rarely, weekly works — the system automatically covers everything since
the last run, so nothing is ever missed, even if you skip a week.

---

## 11. Learning mode: /teach

When a briefing mentions something you don't understand, don't nod along — type:

```
/teach <the thing>
```

Claude explains it *at your level* (it knows your profile), with a concrete
analogy, why it exists, where it appeared in your briefing — linked to the
exact video moment — and a "try it in 5 minutes" section. It works with a
concept name, a report file, or any YouTube link. Keep asking follow-ups;
it keeps teaching.

---

## 12. What NOT to do

- **Don't add 40 channels on day one.** Volume isn't insight. Start with ~10;
  the briefing quality tells you within a week whether to add or prune.
- **Don't pick reaction/drama channels.** The system filters hype, but garbage
  in still degrades the signal. One contrarian ≠ five ragebait channels.
- **Don't mix unrelated domains in one install.** Finance + cooking in one
  channel list produces mushy clusters and a confused wiki. One folder per domain.
- **Don't write a vague profile.** "I like tech" gives you a generic newsletter.
  Specifics give you an analyst.
- **Don't delete the `state/`, `wiki/`, or `data/` folders.** They're the
  system's memory — deleting them resets what it has seen and learned.
- **Don't expect briefings from channels without captions** — check the CC
  button before adding.
- **Don't skip the example.** Two minutes with the
  [example briefing](https://htmlpreview.github.io/?https://github.com/agrotisnicolaos/agr-informed/blob/main/examples/example-briefing.html)
  teaches the layout faster than any documentation.

---

## 13. Troubleshooting & FAQ

**"yt-dlp not found" or transcript errors.**
Tell Claude: *"yt-dlp seems broken, please fix it."* It will reinstall it
(usually one command). This is the most common hiccup and the easiest fix.

**A channel always shows "no transcript available".**
That channel doesn't publish captions. The system falls back to video
descriptions (thin but functional). Consider replacing the channel.

**"0 new videos" every day.**
Your channels upload rarely. Either add a couple of more active channels or
switch to a weekly cadence — nothing is lost in between.

**The report didn't open.**
It's always saved in the `reports/` folder inside your project, named by date
(`2026-06-10.html`). Double-click it. `reports/index.html` is your full archive.

**Is my data private?**
Yes. Your profile, reports, transcripts, and wiki live only in your folder and
are excluded from any code sharing by default. The analysis runs through your
Claude account under Anthropic's standard privacy terms — same as chatting
with Claude.

**What does it cost to run?**
Your existing Claude subscription. A daily briefing uses a modest slice of a
Pro plan's capacity; if you ever hit a usage limit, the briefing simply tells
you to rerun later.

**How do I update agr-informed?**
Download the new ZIP, then copy these from your old folder into the new one:
`sources.txt`, `profile.md`, and the `wiki/`, `reports/`, `state/`, `data/`
folders. (They're your personal data — the update only replaces the machinery.)

**Can I run two different topics?**
Yes — two copies of the folder, each with its own channels, profile, and brain.

**Something else?**
Just describe the problem to Claude in the chat — in plain English. Debugging
itself is one of the things it's genuinely good at.

---

*Created by [agr-informed](https://github.com/agrotisnicolaos/agr-informed) — a
project by Nicolas Agrotis. Explore more projects like this at
[agr·hub](https://agrotisnicolaos.github.io/agr-hub/).*
