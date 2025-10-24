#!/bin/bash
#
# Converts a curated Markdown file into a clean, "Canvas-Ready" HTML
# file. This HTML source can be pasted directly into the Canvas
# RCE's (Rich Content Editor) HTML view (</>).

# $1: The path to the cmods/ markdown file
MARKDOWN_FILE=$1

# Get the base name (e.g., "ice1")
BASENAME=$(basename "$MARKDOWN_FILE" .md)

# Define the output directory and file
OUTPUT_DIR="dist/canvas_pages"
OUTPUT_FILE="$OUTPUT_DIR/$BASENAME.html"

# Ensure the output directory exists
mkdir -p "$OUTPUT_DIR"

# Run pandoc to convert MD to HTML
#
# --standalone (-s): Creates a full HTML doc (<html><body>...)
# --to html5: Specifies HTML5 output
# --output: The destination file
#
pandoc "$MARKDOWN_FILE" \
    --standalone \
    --to html5 \
    --output "$OUTPUT_FILE"

echo "✅ Canvas Page built: $OUTPUT_FILE"
