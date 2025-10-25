#!/bin/bash
#
# Converts a Markdown lecture file (formatted with ## Headers for slides)
# into a Microsoft PowerPoint (.pptx) file.

# --- Requirements ---
# 1. pandoc: (https://pandoc.org/installing.html)
# --------------------

# Exit immediately if a command exits with a non-zero status.
set -e

# $1: The path to the markdown lecture file
MARKDOWN_FILE=$1

# Get the base name (e.g., "mod1_Lec03_Databases_Models")
BASENAME=$(basename "$MARKDOWN_FILE" .md)

# Define the output directory and file
OUTPUT_DIR="dist/slide_decks"
OUTPUT_FILE="$OUTPUT_DIR/$BASENAME.pptx"

# Ensure the output directory exists
mkdir -p "$OUTPUT_DIR"

# Run pandoc to convert MD to PPTX
#
# --output: The destination file. Pandoc infers the .pptx
#           format from the extension.
# --slide-level=2: CRITICAL. This tells pandoc to create a new
#                  slide at every Level 2 Header (##).
#
echo "Building PowerPoint... (this may take a moment)"
pandoc "$MARKDOWN_FILE" \
    --slide-level=2 \
    --output "$OUTPUT_FILE"

echo "✅ Slide Deck built: $OUTPUT_FILE"