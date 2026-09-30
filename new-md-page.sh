#!/bin/bash
# Creates a new markdown-backed topic page: <name>.html (a thin shell you
# never touch again) + <name>.md (the actual content you edit). The .html
# fetches and renders the .md automatically on every page load via
# marked.js, so the two files never need to be manually kept in sync.
# Both are written directly into topics/ with the correct ../ relative
# paths for that folder depth baked in.
#
# Usage: ./new-md-page.sh <filename-without-extension> "<Page Title>"
# Example: ./new-md-page.sh stringr "stringr"

set -euo pipefail

if [ $# -ne 2 ]; then
  echo "Usage: ./new-md-page.sh <filename-without-extension> \"<Page Title>\""
  echo "Example: ./new-md-page.sh stringr \"stringr\""
  exit 1
fi

NAME="$1"
TITLE="$2"
HTML_FILE="topics/${NAME}.html"
MD_FILE="topics/${NAME}.md"

if [ -f "$HTML_FILE" ] || [ -f "$MD_FILE" ]; then
  echo "Error: $HTML_FILE or $MD_FILE already exists — not overwriting it."
  exit 1
fi

mkdir -p topics
cp md-page-template.html "$HTML_FILE"
sed -i '' \
  -e "s/PAGE TITLE/${TITLE}/g" \
  -e "s/PAGE_NAME.md/${NAME}.md/g" \
  -e 's|href="leelacodedict_files/|href="../leelacodedict_files/|g' \
  -e 's|href="custom.css"|href="../custom.css"|' \
  -e 's|href="index.html"|href="../index.html"|' \
  -e 's|src="quarto-page.js"|src="../quarto-page.js"|' \
  "$HTML_FILE"

cp md-content-template.md "$MD_FILE"

echo "Created $HTML_FILE (shell, don't edit) and $MD_FILE (content, edit this)."
echo ""
echo "Next steps:"
echo "1. Edit $MD_FILE — plain Markdown: ### for topics, #### for functions,"
echo "   \`\`\`language code fences, and <details><summary> for collapsible groups."
echo "2. Add a link to it from index.html's Contents list:"
echo "   <li><a href=\"topics/${NAME}.html\">$TITLE</a></li>"
echo "3. Save and reload the page in a browser — no build step, it just renders."
