#!/bin/bash

# Extract archive script for Yazi
# Supports: .zip, .tar.gz, .tgz, .tar.bz2, .tbz2, .tar.xz, .txz, .tar, .rar, .7z

archive="$1"

# Check if file exists and is a regular file
if [ ! -f "$archive" ]; then
  echo "Error: Not a valid file"
  exit 1
fi

# Get the base name without extension for default extraction directory
basename="${archive%.*}"
# Handle double extensions like .tar.gz
if [[ "$archive" =~ \.(tar\.gz|tar\.bz2|tar\.xz)$ ]]; then
  basename="${archive%.*.*}"
fi

# Prompt for extraction directory
printf "Extract to directory (default: %s): " "$basename"
read -r extract_dir

# Use default if empty
if [ -z "$extract_dir" ]; then
  extract_dir="$basename"
fi

# Create extraction directory if it doesn't exist
mkdir -p "$extract_dir"

# Extract based on file extension
case "$archive" in
*.zip)
  unzip -q "$archive" -d "$extract_dir"
  ;;
*.tar.gz | *.tgz)
  tar -xzf "$archive" -C "$extract_dir"
  ;;
*.tar.bz2 | *.tbz2)
  tar -xjf "$archive" -C "$extract_dir"
  ;;
*.tar.xz | *.txz)
  tar -xJf "$archive" -C "$extract_dir"
  ;;
*.tar)
  tar -xf "$archive" -C "$extract_dir"
  ;;
*.rar)
  unrar x "$archive" "$extract_dir/"
  ;;
*.7z)
  7z x "$archive" -o"$extract_dir"
  ;;
*)
  echo "Error: Unsupported archive format"
  rmdir "$extract_dir" 2>/dev/null
  exit 1
  ;;
esac

if [ $? -eq 0 ]; then
  echo "Successfully extracted to: $extract_dir"
else
  echo "Error: Extraction failed"
  exit 1
fi
