#!/bin/bash
#
# build_kit.sh
#
# A generic "scaffolding runner" for building starter kits.
# It creates a staging area, executes a "recipe" script to
# populate it, and zips the result into the dist/kits/ directory.
#
# Usage: ./scripts/build_kit.sh <path_to_recipe_script>
#
# Example:
#   ./scripts/build_kit.sh cmods/student/02_ices/mod1_icex08_refactor_kit.sh
#
# This will create "dist/kits/mod1_icex08_refactor_kit.zip".
#

# Exit immediately if any command fails
set -e

# --- 1. Validation ---
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <path_to_recipe_script>"
    echo "Error: You must provide a path to a recipe script."
    exit 1
fi

RECIPE_SCRIPT_PATH="$1"

if [ ! -f "$RECIPE_SCRIPT_PATH" ]; then
    echo "Error: Recipe script not found at $RECIPE_SCRIPT_PATH"
    exit 1
fi

# --- 2. Configuration ---

# Define the output directory
OUTPUT_DIR="dist/kits"

# Derive the output zip file name from the recipe script name
RECIPE_BASENAME=$(basename "$RECIPE_SCRIPT_PATH" .sh)
ZIP_FILENAME="${RECIPE_BASENAME}.zip"
OUTPUT_PATH="${OUTPUT_DIR}/${ZIP_FILENAME}"

# --- 3. Path Correction (The Fix) ---
echo "📦 Ensuring output directory exists at $OUTPUT_DIR..."
mkdir -p "$OUTPUT_DIR"

# Get the *absolute* path to the *directory*, which we know exists.
OUTPUT_DIR_ABS_PATH=$(realpath "$OUTPUT_DIR")

# Now, build the absolute path to the *final zip file*.
ZIP_ABS_PATH="${OUTPUT_DIR_ABS_PATH}/${ZIP_FILENAME}"

# Get the *absolute* path to the recipe script
RECIPE_ABS_PATH=$(realpath "$RECIPE_SCRIPT_PATH")

# Create a secure, temporary staging directory
STAGING_DIR=$(mktemp -d -t scaffolding_kit_XXXXXX)

# --- 4. Cleanup Trap ---
# This ensures our staging dir is deleted even if the script fails
trap 'echo "🧹 Cleaning up $STAGING_DIR..."; rm -rf "$STAGING_DIR"' EXIT

echo "Building $OUTPUT_PATH..."
echo "-----------------------------------"
echo "🏗️  Created staging directory at $STAGING_DIR"

# --- 5. Execution ---
echo "🏃 Running recipe from $RECIPE_BASENAME.sh..."

# CRITICAL: We 'cd' into the staging dir FIRST,
# so the recipe script runs *inside* it and creates
# all its files and directories relative to its new CWD.
(
    cd "$STAGING_DIR"
    # Run the recipe script. It must be executable!
    bash "$RECIPE_ABS_PATH"
)

echo "✅ Recipe executed successfully."

# --- 6. Zipping ---
echo "📦 Zipping the kit..."
# We 'cd' into the staging dir again to zip its *contents*,
# and use the *absolute path* for the output file.
(
    cd "$STAGING_DIR"
    zip -r "$ZIP_ABS_PATH" .
)

echo "-----------------------------------"
echo "🎉 Success! $OUTPUT_PATH is ready."

# The 'trap' will automatically fire on exit and clean up.
