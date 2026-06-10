#!/usr/bin/env python3
"""Discover new videos from the channels in sources.txt.

No API keys: channel IDs are resolved by fetching the channel page once
(cached in state/channels.json), then new videos come from YouTube's public
RSS feeds. Videos not yet in state/seen.json are written to data/queue.json.

Usage:
  python3 pipeline/discover.py            # new videos since last run
  python3 pipeline/discover.py --days 3   # cap lookback (also first-run default)
"""
import argparse
import json
import re
import sys
import urllib.request
import xml.etree.ElementTree as ET
from datetime import datetime, timedelta, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SOURCES = ROOT / "sources.txt"
CHANNELS_CACHE = ROOT / "state" / "channels.json"
SEEN = ROOT / "state" / "seen.json"
QUEUE = ROOT / "data" / "queue.json"

UA = {"User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)"}
ATOM = "{http://www.w3.org/2005/Atom}"
YT = "{http://www.youtube.com/xml/schemas/2015}"
MEDIA = "{http://search.yahoo.com/mrss/}"


def fetch(url: str) -> str:
    req = urllib.request.Request(url, headers=UA)
    with urllib.request.urlopen(req, timeout=30) as r:
        return r.read().decode("utf-8", errors="replace")


def load_json(path: Path, default):
    if path.exists():
        return json.loads(path.read_text())
    return default


def save_json(path: Path, data):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(data, indent=2, ensure_ascii=False))


def read_sources() -> list[str]:
    urls = []
    for line in SOURCES.read_text().splitlines():
        line = line.strip()
        if line and not line.startswith("#"):
            urls.append(line.rstrip("/").removesuffix("/videos").removesuffix("/featured"))
    return list(dict.fromkeys(urls))  # dedupe, keep order


def resolve_channel(url: str, cache: dict) -> dict | None:
    """Return {'id': UC..., 'name': ...} for a channel URL, using cache."""
    if url in cache:
        return cache[url]
    m = re.search(r"/channel/(UC[\w-]{22})", url)
    if m:
        info = {"id": m.group(1), "name": None}
    else:
        try:
            html = fetch(url)
        except Exception as e:
            print(f"  ! could not fetch {url}: {e}", file=sys.stderr)
            return None
        cid = (re.search(r'<link rel="canonical" href="https://www\.youtube\.com/channel/(UC[\w-]{22})"', html)
               or re.search(r'"externalId":"(UC[\w-]{22})"', html)
               or re.search(r'<meta itemprop="identifier" content="(UC[\w-]{22})"', html)
               or re.search(r'"channelId":"(UC[\w-]{22})"', html))
        if not cid:
            print(f"  ! no channel ID found at {url}", file=sys.stderr)
            return None
        name = re.search(r'<meta property="og:title" content="([^"]+)"', html)
        info = {"id": cid.group(1), "name": name.group(1) if name else None}
    if not info["name"]:
        info["name"] = url.rsplit("/", 1)[-1].lstrip("@")
    cache[url] = info
    return info


def channel_feed(channel_id: str) -> tuple[str | None, list[dict]]:
    xml = fetch(f"https://www.youtube.com/feeds/videos.xml?channel_id={channel_id}")
    root = ET.fromstring(xml)
    feed_title = root.findtext(f"{ATOM}title")
    videos = []
    for entry in root.findall(f"{ATOM}entry"):
        vid = entry.findtext(f"{YT}videoId")
        published = entry.findtext(f"{ATOM}published")
        title = entry.findtext(f"{ATOM}title")
        desc = entry.findtext(f"{MEDIA}group/{MEDIA}description") or ""
        if vid and published:
            videos.append({
                "video_id": vid,
                "title": title,
                "published": published,
                "description": desc[:500],
            })
    return feed_title, videos


def yt_dlp_fallback(url: str, seen_ids: set, first_run: bool) -> list[dict]:
    """For channels whose RSS feed is broken (YouTube 404/500s some feeds),
    list the videos tab with yt-dlp. No dates in flat mode, so 'new' means
    'not seen yet', capped on first run."""
    import subprocess
    entries = []
    for tab in (f"{url}/videos", url):
        try:
            out = subprocess.run(
                ["yt-dlp", "--flat-playlist", "--playlist-end", "8", "-J", tab],
                capture_output=True, timeout=60, check=True)
        except Exception as e:
            print(f"  ! yt-dlp fallback failed for {tab}: {e}", file=sys.stderr)
            continue
        data = json.loads(out.stdout)
        entries = data.get("entries") or []
        # channel root returns tabs as nested playlists; flatten one level
        if entries and entries[0].get("_type") == "playlist":
            entries = [e for t in entries for e in (t.get("entries") or [])]
        if entries:
            break
    fresh = []
    for e in entries:
        if e.get("id") and e["id"] not in seen_ids:
            fresh.append({
                "video_id": e["id"],
                "title": e.get("title"),
                "published": None,
                "description": (e.get("description") or "")[:500],
            })
    return fresh[:3] if first_run else fresh


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--days", type=float, default=None,
                    help="lookback window in days (default: since last run; 3 on first run)")
    args = ap.parse_args()

    state = load_json(SEEN, {"last_run": None, "seen_ids": []})
    seen_ids = set(state["seen_ids"])

    if args.days is not None:
        cutoff = datetime.now(timezone.utc) - timedelta(days=args.days)
    elif state["last_run"]:
        cutoff = datetime.fromisoformat(state["last_run"])
    else:
        cutoff = datetime.now(timezone.utc) - timedelta(days=3)

    cache = load_json(CHANNELS_CACHE, {})
    queue = []
    for url in read_sources():
        ch = resolve_channel(url, cache)
        if not ch:
            continue
        try:
            feed_title, feed = channel_feed(ch["id"])
            if feed_title:
                ch["name"] = feed_title
                cache[url]["name"] = feed_title
            fresh = [v for v in feed
                     if datetime.fromisoformat(v["published"]) >= cutoff
                     and v["video_id"] not in seen_ids]
        except Exception:
            fresh = yt_dlp_fallback(url, seen_ids, first_run=state["last_run"] is None)
            if fresh:
                print(f"  {ch['name']}: RSS unavailable, used yt-dlp fallback")
        for v in fresh:
            v["channel"] = ch["name"]
            v["channel_id"] = ch["id"]
            v["url"] = f"https://www.youtube.com/watch?v={v['video_id']}"
        queue.extend(fresh)
        print(f"  {ch['name']}: {len(fresh)} new")

    save_json(CHANNELS_CACHE, cache)
    queue.sort(key=lambda v: v["published"] or "9999", reverse=True)
    save_json(QUEUE, {
        "generated": datetime.now(timezone.utc).isoformat(),
        "cutoff": cutoff.isoformat(),
        "videos": queue,
    })
    print(f"\n{len(queue)} new video(s) since {cutoff:%Y-%m-%d %H:%M} UTC -> data/queue.json")


if __name__ == "__main__":
    main()
