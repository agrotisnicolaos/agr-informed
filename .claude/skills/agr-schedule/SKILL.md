---
name: agr-schedule
description: Schedule the briefing to run automatically at the user's chosen frequency — macOS launchd, Claude cloud routine, or manual. Use when the user says /schedule-briefing, /agr-schedule, "run this every morning", "automate my briefing", or wants to change/remove the schedule.
---

# /agr-schedule — automate the briefing

Ask two things (AskUserQuestion):
1. **When** — daily at what time? (default 07:30) Or weekly?
2. **How** — pick the runner:

| Runner | Pros | Cons |
|---|---|---|
| **On my Mac (launchd)** (recommended) | Reports stay local; runs on wake if the Mac was asleep | Mac must be on at some point that day |
| **Claude cloud routine** | Runs even with the laptop closed | Repo must be on GitHub; the report is committed to the repo (public repo = public report). Uses the /schedule skill. |
| **Manual** | Zero setup | You type /briefing yourself |

## On my Mac (launchd)

Write `~/Library/LaunchAgents/com.agr-informed.briefing.plist`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key><string>com.agr-informed.briefing</string>
  <key>ProgramArguments</key>
  <array>
    <string>/bin/zsh</string><string>-lc</string>
    <string>cd PROJECT_DIR && claude -p "/briefing" --permission-mode acceptEdits >> state/schedule.log 2>&1</string>
  </array>
  <key>StartCalendarInterval</key>
  <dict><key>Hour</key><integer>HH</integer><key>Minute</key><integer>MM</integer></dict>
  <key>StandardErrorPath</key><string>/tmp/agr-informed.err</string>
</dict>
</plist>
```

Replace PROJECT_DIR with the absolute project path (`pwd`) and HH/MM with the
chosen time. Then:

```bash
launchctl unload ~/Library/LaunchAgents/com.agr-informed.briefing.plist 2>/dev/null
launchctl load ~/Library/LaunchAgents/com.agr-informed.briefing.plist
launchctl list | grep agr-informed   # verify
```

Confirm `which claude` resolves in a login shell first; if not, use the absolute
path to the claude binary in the plist. Note: launchd skips runs while the Mac
sleeps; it fires at the next opportunity the Mac is awake. Logs: `state/schedule.log`.

**Remove:** `launchctl unload ... && rm` the plist.

## Claude cloud routine

Check the repo has a GitHub remote (`git remote -v`). Warn clearly if the repo
is public: scheduled reports will be committed and visible to anyone. If the
user accepts, invoke the **schedule** skill to create a routine with prompt:
"Run /briefing in this repo, then commit data/, state/ and reports/ changes with
message 'briefing: <date>' and push." at the chosen cron time. The user pulls
to get new reports locally.

## Manual

Nothing to install. Suggest making /briefing part of the morning routine.

Always end by showing how to check or change the schedule later (/agr-schedule again).
