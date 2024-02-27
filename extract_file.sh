#!/bin/bash

# Check for the correct number of arguments
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <base_directory_path>"
    exit 1
fi

# Base directory is the first argument
BASE_DIR="$1"

# Destination directory for the results
RESULTS_DIR="${BASE_DIR}/integron_results"

# Create the results directory if it doesn't exist
mkdir -p "$RESULTS_DIR"

# Iterate over each subfolder
for SUBFOLDER in "${BASE_DIR}"/*/; do
    # Iterate over each sub-subfolder
    for SUB_SUBFOLDER in "${SUBFOLDER}"*/; do
        # Check if the sub-subfolder exists
        if [[ -d "$SUB_SUBFOLDER" ]]; then
            # Find the .summary file to determine the new folder name
            SUMMARY_FILE=$(find "$SUB_SUBFOLDER" -type f -name "*.summary")
            if [[ ! -z "$SUMMARY_FILE" ]]; then
                # Extract the name without the extension
                FOLDER_NAME=$(basename "${SUMMARY_FILE}" -1000.contigs.summary)
                # Create a corresponding directory in the results directory
                DEST_DIR="${RESULTS_DIR}/${FOLDER_NAME}"
                mkdir -p "$DEST_DIR"
                # Copy the .gbk, .summary, and .integron files
                find "$SUB_SUBFOLDER" -type f \( -name "*.gbk" -o -name "*.summary" -o -name "*.integrons" \) -exec cp {} "$DEST_DIR" \;
            fi
        fi
    done
done

echo "Extraction completed."

