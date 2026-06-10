---
name: agr-sources
description: Manage the YouTube channels feeding the briefing — add, remove, or list sources. Use when the user says /sources, "add this channel", "remove a channel", "what channels am I following", or pastes a YouTube channel URL.
---

# /agr-sources — manage briefing sources

Sources live in `sources.txt`, one YouTube channel URL per line (`#` = comment).
Any form works: `@handle`, `/channel/UC...`, with or without `/videos`.

## list
Read `sources.txt` and `state/channels.json` (resolved names). Show a clean
numbered list: name + URL.

## add <url or @handle>
1. Normalize: bare handles like `benai92` → `https://www.youtube.com/@benai92`.
   If the user gives a *video* URL, find the channel it belongs to
   (`yt-dlp --print channel_url <video-url>`).
2. Append to `sources.txt` (skip if already present).
3. Verify it resolves:
   ```bash
   python3 -c "
   import sys; sys.path.insert(0,'pipeline')
   from discover import resolve_channel
   print(resolve_channel('<URL>', {}))"
   ```
4. Confirm with the resolved channel name. New channels are picked up on the
   next `/briefing` (their recent videos appear once, then only new ones).

## remove <name or url>
Match loosely against names in `state/channels.json` and lines in `sources.txt`.
Remove the line; also remove its cache entry from `state/channels.json`.
Confirm what was removed.

Keep it conversational — "add Matt Wolfe" should work: search for the channel
handle with yt-dlp or your knowledge, confirm with the user if ambiguous.
