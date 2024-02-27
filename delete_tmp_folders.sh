#!/bin/bash

# The directory to start from
BASE_DIR="$1"

# Whether to perform a dry run
DRY_RUN="false"

# Check for dry run flag
if [[ "$2" == "--dry-run" ]]; then
    DRY_RUN="true"
fi

# Function to delete or echo directories
process_directory() {
    if [[ "$DRY_RUN" == "true" ]]; then
        echo "Would delete: $1"
    else
        rm -rf "$1"
        echo "Deleted: $1"
    fi
}

# Safety check for base directory
if [[ -z "$BASE_DIR" || ! -d "$BASE_DIR" ]]; then
    echo "Please specify a valid base directory."
    exit 1
fi

# Iterate over the subfolders
for SUBFOLDER in "$BASE_DIR"/*/; do
    # Check if the sub-subfolder exists and matches the subfolder name
    SUB_SUBFOLDER="${SUBFOLDER}$(basename "$SUBFOLDER")/"
    if [[ -d "$SUB_SUBFOLDER" ]]; then
        # Find all tmp* directories
        while IFS= read -r -d '' dir; do
            process_directory "$dir"
        done < <(find "$SUB_SUBFOLDER" -type d -name "tmp*" -print0)
    fi
done

# Inform user of dry run mode
if [[ "$DRY_RUN" == "true" ]]; then
    echo "Dry run completed. No actual deletion occurred."
else
    echo "Deletion completed."
fi
