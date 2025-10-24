#!/bin/bash
#
# Converts a Markdown file into a high-quality PDF document using
# Pandoc and a LaTeX engine.

# --- Requirements ---
# 1. pandoc: (https://pandoc.org/installing.html)
# 2. A TeX distribution: We recommend TeX Live.
#    - macOS: MacTeX (https://www.tug.org/mactex/)
#    - Windows: MiKTeX (https://miktex.org/)
#    - Linux: texlive-full (via apt, dnf, etc.)
# 3. Fonts: The fonts specified below (e.g., "Fira Code", "Georgia")
#    must be installed on your system.
# --------------------

# $1: The path to the markdown file
MARKDOWN_FILE=$1

# Get the base name (e.g., "ice7_ta_guide")
BASENAME=$(basename "$MARKDOWN_FILE" .md)
echo ${BASENAME}

# Define the output directory and file
OUTPUT_DIR="dist/pdf_documents"
OUTPUT_FILE="$OUTPUT_DIR/$BASENAME.pdf"

# Ensure the output directory exists
mkdir -p "$OUTPUT_DIR"

# Run pandoc to convert MD to PDF
#
# --standalone (-s): Creates a full, self-contained document.
# --pdf-engine=xelatex: A modern TeX engine that supports
#                       system fonts.
#
# --- STYLING FLAGS ---
# -V geometry:..: Sets the page margins (top, bottom, left, right).
# -V mainfont:..: Sets the main text font.
# -V monofont:..: Sets the font for code blocks.
#
echo "Building PDF... (this may take a moment)"
pandoc "$MARKDOWN_FILE" \
    --standalone \
    --pdf-engine=xelatex \
    -V geometry:"top=1in, bottom=1in, left=1in, right=1in" \
    -V mainfont:"Georgia" \
    -V monofont:"Helvetica" \
    --output "$OUTPUT_FILE"

echo "✅ PDF built: $OUTPUT_FILE"