#!/usr/bin/env python3
"""Download transcripts for the videos in data/queue.json using yt-dlp.

Writes one markdown file per video to data/transcripts/<video_id>.md with a
metadata header and timestamped text, then marks the video as seen in
state/seen.json. No API keys required (uses YouTube's auto-generated subs).

Usage:
  python3 pipeline/transcripts.py           # process the whole queue
  python3 pipeline/transcripts.py --limit 5
"""
import argparse
import json
import re
import subprocess
import sys
import tempfile
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
QUEUE = ROOT / "data" / "queue.json"
OUT = ROOT / "data" / "transcripts"
SEEN = ROOT / "state" / "seen.json"


def vtt_to_blocks(vtt: str) -> list[tuple[str, str]]:
    """Parse a VTT file into (start_time, text) cues, deduplicating the
    rolling repetition YouTube auto-subs produce."""
    cues = []
    time_re = re.compile(r"(\d+):(\d+):(\d+)\.\d+\s+-->")
    current = None
    for line in vtt.splitlines():
        m = time_re.match(line)
        if m:
            h, mn, s = int(m[1]), int(m[2]), int(m[3])
            current = f"{h*60+mn:02d}:{s:02d}" if h else f"{mn:02d}:{s:02d}"
            continue
        text = re.sub(r"<[^>]+>", "", line).strip()
        if not text or text in ("WEBVTT", "Kind: captions") or text.startswith(("Language:", "NOTE")):
            continue
        if current is None:
            continue
        if cues and text == cues[-1][1]:
            continue
        cues.append((current, text))
    return cues


def blocks_to_markdown(cues: list[tuple[str, str]], every_sec: int = 60) -> str:
    """Merge cues into paragraphs with a [mm:ss] marker roughly every minute."""
    out, para, last_mark = [], [], -every_sec

    def secs(ts: str) -> int:
        parts = [int(p) for p in ts.split(":")]
        return parts[0] * 60 + parts[1] if len(parts) == 2 else parts[0] * 3600 + parts[1] * 60 + parts[2]

    for ts, text in cues:
        if secs(ts) - last_mark >= every_sec:
            if para:
                out.append(" ".join(para))
                para = []
            para.append(f"[{ts}]")
            last_mark = secs(ts)
        para.append(text)
    if para:
        out.append(" ".join(para))
    return "\n\n".join(out)


def fetch_transcript(video_id: str) -> str | None:
    with tempfile.TemporaryDirectory() as td:
        cmd = [
            "yt-dlp", "--skip-download",
            "--write-auto-subs", "--write-subs",
            "--sub-langs", "en.*,en",
            "--sub-format", "vtt",
            "-o", f"{td}/%(id)s",
            f"https://www.youtube.com/watch?v={video_id}",
        ]
        try:
            subprocess.run(cmd, capture_output=True, timeout=120, check=True)
        except subprocess.CalledProcessError as e:
            print(f"  ! yt-dlp failed for {video_id}: {e.stderr.decode()[-200:]}", file=sys.stderr)
            return None
        except subprocess.TimeoutExpired:
            print(f"  ! yt-dlp timed out for {video_id}", file=sys.stderr)
            return None
        vtts = sorted(Path(td).glob("*.vtt"))
        if not vtts:
            return None
        cues = vtt_to_blocks(vtts[0].read_text(encoding="utf-8", errors="replace"))
        return blocks_to_markdown(cues) if cues else None


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--limit", type=int, default=None)
    args = ap.parse_args()

    queue = json.loads(QUEUE.read_text())["videos"]
    if args.limit:
        queue = queue[: args.limit]
    OUT.mkdir(parents=True, exist_ok=True)

    seen = json.loads(SEEN.read_text()) if SEEN.exists() else {"last_run": None, "seen_ids": []}
    ok = 0
    for v in queue:
        path = OUT / f"{v['video_id']}.md"
        if path.exists():
            ok += 1
            continue
        print(f"  fetching: {v['channel']} — {v['title'][:60]}")
        text = fetch_transcript(v["video_id"])
        header = (
            f"# {v['title']}\n\n"
            f"- channel: {v['channel']}\n"
            f"- published: {v['published'] or 'unknown'}\n"
            f"- url: {v['url']}\n"
            f"- video_id: {v['video_id']}\n\n"
        )
        if text:
            path.write_text(header + "## Transcript\n\n" + text)
            ok += 1
        else:
            path.write_text(header + "## Transcript\n\n(no transcript available — "
                            f"use the description)\n\n{v.get('description','')}\n")
        if v["video_id"] not in seen["seen_ids"]:
            seen["seen_ids"].append(v["video_id"])

    seen["last_run"] = datetime.now(timezone.utc).isoformat()
    seen["seen_ids"] = seen["seen_ids"][-5000:]
    SEEN.parent.mkdir(parents=True, exist_ok=True)
    SEEN.write_text(json.dumps(seen, indent=2))
    print(f"\n{ok}/{len(queue)} transcript(s) in data/transcripts/")


if __name__ == "__main__":
    main()
