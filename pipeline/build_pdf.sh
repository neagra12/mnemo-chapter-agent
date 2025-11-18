#!/bin/bash
#
# Converts a Markdown file into a high-quality PDF document using
# Pandoc and a LaTeX engine.

# --- Requirements ---
# 1. pandoc: (https://pandoc.org/installing.html)
# 2. A TeX distribution: We recommend TeX Live / MacTeX
# 3. Fonts: The fonts specified (e.g., "Menlo", "Georgia")
#    must be installed on your system.
# --------------------

# Exit immediately if a command exits with a non-zero status.
set -e

# $1: The path to the markdown file
MARKDOWN_FILE=$1

# Get the base name (e.g., "ice7_ta_guide")
BASENAME=$(basename "$MARKDOWN_FILE" .md)

# Define the output directory and file
OUTPUT_DIR="dist/pdf_documents"
OUTPUT_FILE="$OUTPUT_DIR/$BASENAME.pdf"

# Ensure the output directory exists
mkdir -p "$OUTPUT_DIR"

# Run pandoc to convert MD to PDF
#
# --standalone (-s): Creates a full, self-contained document.
# --pdf-engine=xelatex: A modern TeX engine.
#
# --- STYLING FLAGS ---
# -V geometry:..: Sets the page margins.
# -V mainfont:..: Sets the main text font.
# -V monofont:..: Sets the font for code blocks.
#
# --- HEADER/FOOTER FLAGS ---
# -V pagestyle=fancy: Tells LaTeX to use the fancyhdr package.
# -H <(...): Manually includes the required LaTeX packages,
#             which fixes the 'Undefined control sequence' error.
#


echo "Building PDF... (this may take a moment)"
pandoc -f markdown-yaml_metadata_block "$MARKDOWN_FILE" \
    -f markdown+grid_tables \
    --standalone \
    --pdf-engine=xelatex \
    -V geometry:"top=1in, bottom=1in, left=1in, right=1in" \
    -V mainfont:"Helvetica Neue" \
    -V monofont:"Menlo" \
    -V header-left:"$BASENAME" \
    -V header-right:"\\today" \
    --output "$OUTPUT_FILE"

echo "✅ PDF built: $OUTPUT_FILE"