#!/bin/bash
set -e

KEYWORDS_FILE="keywords.txt"
BASE_URL="https://www.softwareadvise.co"
TODAY=$(date +%Y-%m-%d)

if [ -z "$ANTHROPIC_API_KEY" ]; then
  echo "Error: ANTHROPIC_API_KEY is not set."
  exit 1
fi

# Pick first keyword that does not yet have an article file
KEYWORD=""
FILENAME=""
while IFS= read -r line; do
  # Skip empty lines
  [ -z "$line" ] && continue
  slug=$(echo "$line" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9 ]//g' | tr ' ' '-' | sed 's/--*/-/g' | sed 's/^-//;s/-$//')
  candidate="${slug}.html"
  if [ ! -f "$candidate" ]; then
    KEYWORD="$line"
    FILENAME="$candidate"
    break
  fi
done < "$KEYWORDS_FILE"

if [ -z "$KEYWORD" ]; then
  echo "All keywords already have articles. Nothing to generate."
  exit 0
fi

echo "Keyword : $KEYWORD"
echo "Filename: $FILENAME"

# Determine affiliate links based on topic
XERO_LINK="https://referrals.xero.com/q8zuc97k3nz3"
SHOPIFY_LINK="https://shopify.pxf.io/dyOb5j"

PROMPT="You are a content writer for SoftwareAdvise.co, an independent software review site for Southeast Asian SMEs. Write a complete, single-file HTML article targeting the keyword: \"${KEYWORD}\"

Use EXACTLY this HTML/CSS structure — do not change any class names, CSS, or layout:

<!DOCTYPE html>
<html lang=\"en\">
<head>
<meta charset=\"UTF-8\">
<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">
<title>[SEO TITLE — include keyword, max 60 chars] | SoftwareAdvise</title>
<meta name=\"description\" content=\"[SEO meta description — include keyword, 140-155 chars]\">
<link href=\"https://fonts.googleapis.com/css2?family=Syne:wght@700;800&family=DM+Sans:wght@300;400;500&display=swap\" rel=\"stylesheet\">
<style>
:root{--black:#0a0a0a;--white:#fafaf8;--cream:#f5f2ec;--accent:#1a6b3c;--accent-light:#e8f5ee;--accent-bright:#22c55e;--gray:#6b7280;--border:#e2e0db}
*{margin:0;padding:0;box-sizing:border-box}
body{font-family:'DM Sans',sans-serif;background:var(--white);color:var(--black);font-size:17px;line-height:1.75}
nav{position:sticky;top:0;z-index:100;background:var(--white);border-bottom:1px solid var(--border);padding:0 40px;display:flex;align-items:center;height:64px}
.nav-logo{font-family:'Syne',sans-serif;font-weight:800;font-size:18px;color:var(--black);text-decoration:none}
.nav-logo span{color:var(--accent)}
.hero{background:var(--black);color:var(--white);padding:80px 40px 60px}
.hi{max-width:760px;margin:0 auto}
.tag{display:inline-block;background:var(--accent-light);color:var(--accent);font-size:12px;font-weight:600;letter-spacing:1px;text-transform:uppercase;padding:5px 12px;border-radius:100px;margin-bottom:20px}
h1{font-family:'Syne',sans-serif;font-size:clamp(26px,4vw,46px);font-weight:800;line-height:1.1;letter-spacing:-1.5px;margin-bottom:16px}
.meta{color:rgba(255,255,255,0.45);font-size:14px}
.bd{max-width:760px;margin:0 auto;padding:60px 40px}
.verdict{background:var(--accent-light);border:1px solid var(--accent);border-radius:12px;padding:28px;margin:0 0 40px}
.verdict h3{font-family:'Syne',sans-serif;font-size:13px;font-weight:700;color:var(--accent);margin-bottom:8px;text-transform:uppercase;letter-spacing:1px}
.score{font-size:52px;font-weight:800;font-family:'Syne',sans-serif;color:var(--accent);line-height:1;margin-bottom:10px}
.verdict p{color:#1a4a2e;font-size:15px}
h2{font-family:'Syne',sans-serif;font-size:26px;font-weight:800;letter-spacing:-0.5px;margin:48px 0 14px}
h3{font-family:'Syne',sans-serif;font-size:18px;font-weight:700;margin:28px 0 10px}
p{margin-bottom:18px;color:#2d2d2d}
ul{margin:0 0 18px 22px}
li{margin-bottom:8px;color:#2d2d2d}
.pc{display:grid;grid-template-columns:1fr 1fr;gap:16px;margin:28px 0}
.pros{background:#f0fdf4;border:1px solid #bbf7d0;border-radius:10px;padding:20px}
.cons{background:#fff7ed;border:1px solid #fed7aa;border-radius:10px;padding:20px}
.pros h4{color:#166534;font-family:'Syne',sans-serif;font-weight:700;margin-bottom:10px}
.cons h4{color:#9a3412;font-family:'Syne',sans-serif;font-weight:700;margin-bottom:10px}
.pros li{color:#166534;font-size:14px;margin-bottom:5px}
.cons li{color:#9a3412;font-size:14px;margin-bottom:5px}
table{width:100%;border-collapse:collapse;margin:20px 0;border-radius:10px;overflow:hidden}
th{background:var(--black);color:var(--white);padding:14px 18px;text-align:left;font-family:'Syne',sans-serif;font-size:14px}
td{padding:13px 18px;border-bottom:1px solid var(--border);font-size:15px}
tr:last-child td{border-bottom:none}
tr:nth-child(even) td{background:var(--cream)}
.cta{background:var(--black);color:var(--white);border-radius:16px;padding:40px;text-align:center;margin:48px 0}
.cta h3{font-family:'Syne',sans-serif;font-size:22px;font-weight:800;margin-bottom:10px}
.cta p{color:rgba(255,255,255,0.55);margin-bottom:22px;font-size:15px}
.cta-btn{display:inline-block;background:var(--accent-bright);color:var(--black);padding:14px 32px;border-radius:8px;font-weight:700;font-size:15px;text-decoration:none}
.disc{font-size:11px;color:rgba(255,255,255,0.25);margin-top:14px}
footer{background:var(--cream);border-top:1px solid var(--border);padding:32px 40px;display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:16px}
.fl{font-family:'Syne',sans-serif;font-weight:800;font-size:15px}
.fl span{color:var(--accent)}
footer p{color:var(--gray);font-size:13px}
@media(max-width:600px){nav{padding:0 20px}.hero{padding:50px 20px 40px}.bd{padding:36px 20px}.pc{grid-template-columns:1fr}footer{padding:24px 20px}}
</style>
</head>
<body>
<nav><a href=\"/\" class=\"nav-logo\">Software<span>Advise</span></a></nav>

<div class=\"hero\"><div class=\"hi\">
  <div class=\"tag\">[CATEGORY e.g. Accounting &middot; Review]</div>
  <h1>[H1 TITLE]</h1>
  <div class=\"meta\">Updated ${TODAY} &middot; [X] min read &middot; Singapore</div>
</div></div>

<div class=\"bd\">

  [VERDICT BOX — include .verdict with .score and summary paragraph, for review articles]

  [ARTICLE BODY — 800 to 1200 words across multiple h2 sections]
  [Include at least one comparison table]
  [Include pros/cons .pc block where relevant]

  <div class=\"cta\">
    <h3>[CTA HEADLINE]</h3>
    <p>[CTA SUBTEXT]</p>
    <a class=\"cta-btn\" href=\"[AFFILIATE LINK]\" target=\"_blank\" rel=\"noopener\">[CTA BUTTON TEXT] &rarr;</a>
    <div class=\"disc\">Disclosure: We earn a referral fee if you subscribe. This does not affect our score or recommendations.</div>
  </div>

</div>

<footer>
  <div class=\"fl\">Software<span>Advise</span></div>
  <p>&copy; 2026 SoftwareAdvise.co &mdash; Singapore</p>
  <p><a href=\"/\" style=\"color:var(--gray);text-decoration:none\">&larr; Back to Home</a></p>
</footer>
</body>
</html>

Affiliate links to use:
- Xero: ${XERO_LINK} (use for accounting, finance, bookkeeping topics)
- Shopify: ${SHOPIFY_LINK} (use for ecommerce, online store topics)
- For comparison articles, you may include both links in separate CTA blocks or within the body.

Requirements:
- Write 800-1200 words of body content
- Always frame advice for Singapore/Southeast Asia context: mention SGD pricing, GST 9%, CPF, local bank feeds (DBS, OCBC, UOB), MYR pricing where relevant
- Output ONLY the raw HTML — no markdown fences, no explanation, nothing before <!DOCTYPE or after </html>"

# JSON-encode the prompt safely
PAYLOAD=$(python3 -c "
import json, sys
prompt = sys.stdin.read()
payload = {
    'model': 'claude-haiku-4-5-20251001',
    'max_tokens': 4096,
    'messages': [{'role': 'user', 'content': prompt}]
}
print(json.dumps(payload))
" <<< "$PROMPT")

echo "Calling Claude API..."
RESPONSE=$(curl -sf https://api.anthropic.com/v1/messages \
  -H "x-api-key: ${ANTHROPIC_API_KEY}" \
  -H "anthropic-version: 2023-06-01" \
  -H "content-type: application/json" \
  -d "$PAYLOAD")

# Extract and clean HTML from response
HTML=$(python3 - <<PYEOF
import json, sys

response = json.loads("""$RESPONSE""".replace('"""', '"'), strict=False)
if 'content' not in response or not response['content']:
    sys.stderr.write('API error: ' + json.dumps(response) + '\n')
    sys.exit(1)

text = response['content'][0]['text'].strip()

# Strip accidental markdown fences
if text.startswith('\`\`\`html'):
    text = text[7:]
elif text.startswith('\`\`\`'):
    text = text[3:]
if text.endswith('\`\`\`'):
    text = text[:-3]

print(text.strip())
PYEOF
)

echo "$HTML" > "$FILENAME"
echo "Saved: $FILENAME"

# Rebuild sitemap.xml with all HTML pages
python3 - <<PYEOF
import os
from datetime import date

base_url = "${BASE_URL}"
today = "${TODAY}"
sitemap_path = "sitemap.xml"

html_files = sorted(f for f in os.listdir('.') if f.endswith('.html'))

entries = []
for f in html_files:
    if f == 'index.html':
        entries.append((f'{base_url}/', today, 'weekly', '1.0'))
    else:
        entries.append((f'{base_url}/{f}', today, 'monthly', '0.8'))

lines = ['<?xml version="1.0" encoding="UTF-8"?>',
         '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">']
for loc, lastmod, freq, pri in entries:
    lines += [
        '  <url>',
        f'    <loc>{loc}</loc>',
        f'    <lastmod>{lastmod}</lastmod>',
        f'    <changefreq>{freq}</changefreq>',
        f'    <priority>{pri}</priority>',
        '  </url>',
    ]
lines += ['</urlset>', '']

with open(sitemap_path, 'w') as fh:
    fh.write('\n'.join(lines))

print(f'Sitemap updated: {len(entries)} URLs')
PYEOF

echo "Done."
