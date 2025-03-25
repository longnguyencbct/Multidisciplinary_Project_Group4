#!/bin/bash

# Base directory for Topics
base_dir="../../Demo_CE/Topics"

# Loop through each topic folder
for topic_dir in "$base_dir"/*; do
    if [ -d "$topic_dir" ]; then
        prev_row_file="$topic_dir/prev_row.txt"
        # Check if prev_row.txt exists and clear its contents
        if [ -f "$prev_row_file" ]; then
            > "$prev_row_file"
            echo "Cleared $prev_row_file"
        fi
    fi
done