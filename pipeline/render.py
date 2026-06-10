#!/usr/bin/env python3
"""Render data/briefing.json into a self-contained HTML report.

Claude Code writes briefing.json (the analysis); this script injects it into
templates/report.html and writes reports/<date>.html, then rebuilds
reports/index.html (the archive page).

Usage:
  python3 pipeline/render.py [path/to/briefing.json]
"""
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
TEMPLATE = ROOT / "templates" / "report.html"
REPORTS = ROOT / "reports"

REQUIRED = ["date", "tldr", "clusters"]


def validate(b: dict):
    missing = [k for k in REQUIRED if k not in b]
    if missing:
        sys.exit(f"briefing.json missing keys: {missing}")
    if not re.match(r"^\d{4}-\d{2}-\d{2}$", b["date"]):
        sys.exit(f"briefing.json date must be YYYY-MM-DD, got {b['date']!r}")
    for i, c in enumerate(b["clusters"]):
        for k in ("headline", "why_it_matters", "summary", "sources"):
            if k not in c:
                sys.exit(f"cluster[{i}] missing '{k}'")
        if not c["sources"]:
            sys.exit(f"cluster[{i}] has no sources")
        for s in c["sources"]:
            if "video_id" not in s or "channel" not in s:
                sys.exit(f"cluster[{i}] source missing video_id/channel: {s}")


def build_index():
    pages = sorted(
        (p for p in REPORTS.glob("????-??-??.html")), reverse=True)
    rows = "\n".join(
        f'<li><a href="{p.name}"><span class="d">{p.stem}</span>'
        f'<span class="arrow">→</span></a></li>' for p in pages)
    REPORTS.joinpath("index.html").write_text(f"""<!DOCTYPE html>
<html lang="en"><head><meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>agr·informed — archive</title>
<link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,300..900&family=Archivo:wght@400;600;700&display=swap" rel="stylesheet">
<style>
  body {{ background:#faf6ee; color:#1d1a15; font-family:"Archivo",sans-serif;
         max-width:640px; margin:0 auto; padding:60px 24px; }}
  .wordmark {{ font-weight:700; letter-spacing:.34em; font-size:13px; }}
  .wordmark em {{ color:#d2491f; font-style:normal; }}
  h1 {{ font-family:"Fraunces",serif; font-weight:380; font-size:54px;
        margin:18px 0 34px; border-bottom:2.5px solid #1d1a15; padding-bottom:22px; }}
  ul {{ list-style:none; padding:0; }}
  li a {{ display:flex; justify-content:space-between; padding:16px 4px;
          border-bottom:1px solid #e2d9c8; color:#1d1a15; text-decoration:none;
          font-size:17px; font-weight:600; transition:all .15s ease; }}
  li a:hover {{ color:#d2491f; padding-left:10px; }}
  .arrow {{ color:#d2491f; }}
</style></head><body>
<div class="wordmark">AGR<em>·</em>INFORMED</div>
<h1>Briefing archive</h1>
<ul>{rows}</ul>
</body></html>""")


def main():
    src = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / "data" / "briefing.json"
    briefing = json.loads(src.read_text())
    validate(briefing)

    html = TEMPLATE.read_text()
    payload = json.dumps(briefing, ensure_ascii=False).replace("</", "<\\/")
    html = html.replace("__DATA__", payload)
    html = html.replace("__TITLE__", f"agr·informed — {briefing['date']}")

    REPORTS.mkdir(exist_ok=True)
    out = REPORTS / f"{briefing['date']}.html"
    out.write_text(html)
    build_index()
    print(f"report: {out}")
    print(f"index:  {REPORTS / 'index.html'}")


if __name__ == "__main__":
    main()
