#!/bin/bash

# Your Inkscape file
FILE="initial_present_draft.svg"

# Get a list of layers
LAYERS=$(inkscape --query-all "$FILE" | grep layer | cut -d, -f1)

# Export each layer
for LAYER in $LAYERS; do
    OUTPUT="${LAYER}.pdf"
    inkscape --export-type=pdf --export-id="$LAYER" --export-id-only --export-filename="$OUTPUT" "$FILE"
done

pdftk *.pdf cat output combined_presentation.pdf
