#!/bin/bash
# Creates a new topic page from page-template.html, always in sync with the
# current head (highlight.js links, custom.css, etc.) so pages never drift
# out of date the way data-viewing.html did. Written directly into topics/
# with the correct ../ relative paths for that folder depth.
#
# Usage: ./new-page.sh <filename-without-extension> "<Page Title>"
# Example: ./new-page.sh graphing "Graphing"

set -euo pipefail

if [ $# -ne 2 ]; then
  echo "Usage: ./new-page.sh <filename-without-extension> \"<Page Title>\""
  echo "Example: ./new-page.sh graphing \"Graphing\""
  exit 1
fi

NAME="$1"
TITLE="$2"
FILE="topics/${NAME}.html"

if [ -f "$FILE" ]; then
  echo "Error: $FILE already exists — not overwriting it."
  exit 1
fi

mkdir -p topics
cp page-template.html "$FILE"
sed -i '' \
  -e "s/PAGE TITLE/${TITLE}/g" \
  -e 's|href="leelacodedict_files/|href="../leelacodedict_files/|g' \
  -e 's|src="leelacodedict_files/|src="../leelacodedict_files/|g' \
  -e 's|href="custom.css"|href="../custom.css"|' \
  -e 's|href="index.html"|href="../index.html"|' \
  -e 's|src="quarto-page.js"|src="../quarto-page.js"|' \
  "$FILE"

echo "Created $FILE from page-template.html."
echo ""
echo "Next steps:"
echo "1. Edit $FILE — replace TOPIC NAME / GROUP NAME / function placeholders with real content."
echo "2. Add a link to it from index.html's Contents list:"
echo "   <li><a href=\"topics/${NAME}.html\">$TITLE</a></li>"
