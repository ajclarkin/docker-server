#!/bin/bash

# Concatenate all the .resticognore files from all the data directories.
# Prepend the entries with data/SERVICE to ensure that the match only works for this directory.


CONTAINER_ROOT=~/containers
DATA_ROOT=~/data
OUTPUT_IGNORE="$CONTAINER_ROOT/backrest/ignorefile.txt"

mkdir -p "$(dirname "$OUTPUT_IGNORE")"
> "$OUTPUT_IGNORE"

for SERVICE in $(ls "$CONTAINER_ROOT"); do
    DATA_DIR="$DATA_ROOT/$SERVICE"
    CONTAINER_DIR="$CONTAINER_ROOT/$SERVICE"

    # Aggregate .resticignore from data
    if [ -f "$DATA_DIR/.resticignore" ]; then
        while IFS= read -r line || [ -n "$line" ]; do
            [[ -z "$line" || "$line" =~ ^# ]] && continue
            echo "data/$SERVICE/$line" >> "$OUTPUT_IGNORE"
        done < "$DATA_DIR/.resticignore"
    fi

    # Aggregate .resticignore from containers
    if [ -f "$CONTAINER_DIR/.resticignore" ]; then
        while IFS= read -r line || [ -n "$line" ]; do
            [[ -z "$line" || "$line" =~ ^# ]] && continue
            echo "$SERVICE/$line" >> "$OUTPUT_IGNORE"
        done < "$CONTAINER_DIR/.resticignore"
    fi
done

echo "Unified ignore file written to $OUTPUT_IGNORE"

