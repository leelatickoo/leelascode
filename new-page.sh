#!/bin/bash
# Creates a new topic page from page-template.html, always in sync with the
# current head (highlight.js links, custom.css, etc.) so pages never drift
# out of date the way data-viewing.html did.
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
FILE="${NAME}.html"

if [ -f "$FILE" ]; then
  echo "Error: $FILE already exists — not overwriting it."
  exit 1
fi

cp page-template.html "$FILE"
sed -i '' "s/PAGE TITLE/${TITLE}/g" "$FILE"

echo "Created $FILE from page-template.html."
echo ""
echo "Next steps:"
echo "1. Edit $FILE — replace TOPIC NAME / GROUP NAME / function placeholders with real content."
echo "2. Add a link to it from index.html's Contents list:"
echo "   <li><a href=\"$FILE\">$TITLE</a></li>"
