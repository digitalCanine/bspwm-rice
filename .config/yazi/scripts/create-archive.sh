#!/bin/bash

# Create archive script for Yazi
# Compresses the current directory or selected items

# Get current directory name as default archive name
current_dir=$(basename "$(pwd)")
default_name="${current_dir}.tar.gz"

# Check if we're trying to archive something
if [ -z "$(ls -A)" ]; then
  echo "Error: Current directory is empty"
  read -p "Press Enter to continue..."
  exit 1
fi

# Prompt for output directory
printf "Output directory (default: current directory): "
read -r output_dir

# Use current directory if empty
if [ -z "$output_dir" ]; then
  output_dir="."
else
  # Expand tilde and resolve path
  output_dir="${output_dir/#\~/$HOME}"
  # Create output directory if it doesn't exist
  if [ ! -d "$output_dir" ]; then
    printf "Directory '%s' doesn't exist. Create it? (Y/n): " "$output_dir"
    read -r create_confirm
    if [[ ! "$create_confirm" =~ ^[Nn]$ ]]; then
      mkdir -p "$output_dir"
    else
      echo "Archive creation cancelled"
      read -p "Press Enter to continue..."
      exit 0
    fi
  fi
fi

# Prompt for archive name
printf "Archive name (default: %s): " "$default_name"
printf "\nSupported formats: .zip, .tar.gz, .tar.bz2, .tar.xz, .7z\n"
read -r archive_name

# Use default if empty
if [ -z "$archive_name" ]; then
  archive_name="$default_name"
fi

# Construct full archive path
archive_path="$output_dir/$archive_name"

# Check if archive already exists
if [ -f "$archive_path" ]; then
  printf "Warning: Archive '%s' already exists! Overwrite? (y/N): " "$archive_path"
  read -r confirm
  if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "Archive creation cancelled"
    read -p "Press Enter to continue..."
    exit 0
  fi
  rm -f "$archive_path"
fi

# Prompt for what to include
printf "Archive entire current directory? (Y/n): "
read -r choice

if [[ "$choice" =~ ^[Nn]$ ]]; then
  printf "Enter space-separated files/folders to archive: "
  read -r items
  if [ -z "$items" ]; then
    echo "Error: No items specified"
    read -p "Press Enter to continue..."
    exit 1
  fi
else
  # Archive everything in current directory
  items="."
fi

# Create archive based on extension
case "$archive_name" in
*.tar.gz | *.tgz)
  if [ "$items" = "." ]; then
    # Archive contents of current directory
    parent_dir=$(dirname "$(pwd)")
    current_name=$(basename "$(pwd)")
    tar -czf "$archive_path" -C "$parent_dir" "$current_name"
  else
    tar -czf "$archive_path" $items
  fi
  ;;
*.tar.bz2 | *.tbz2)
  if [ "$items" = "." ]; then
    parent_dir=$(dirname "$(pwd)")
    current_name=$(basename "$(pwd)")
    tar -cjf "$archive_path" -C "$parent_dir" "$current_name"
  else
    tar -cjf "$archive_path" $items
  fi
  ;;
*.tar.xz | *.txz)
  if [ "$items" = "." ]; then
    parent_dir=$(dirname "$(pwd)")
    current_name=$(basename "$(pwd)")
    tar -cJf "$archive_path" -C "$parent_dir" "$current_name"
  else
    tar -cJf "$archive_path" $items
  fi
  ;;
*.zip)
  if [ "$items" = "." ]; then
    parent_dir=$(dirname "$(pwd)")
    current_name=$(basename "$(pwd)")
    (cd "$parent_dir" && zip -qr "$archive_path" "$current_name")
  else
    zip -qr "$archive_path" $items
  fi
  ;;
*.7z)
  if [ "$items" = "." ]; then
    parent_dir=$(dirname "$(pwd)")
    current_name=$(basename "$(pwd)")
    (cd "$parent_dir" && 7z a -r "$archive_path" "$current_name" >/dev/null)
  else
    7z a -r "$archive_path" $items >/dev/null
  fi
  ;;
*)
  echo "Error: Unsupported archive format"
  echo "Please use: .zip, .tar.gz, .tar.bz2, .tar.xz, or .7z"
  read -p "Press Enter to continue..."
  exit 1
  ;;
esac

if [ $? -eq 0 ]; then
  echo "Successfully created archive: $archive_path"
  read -p "Press Enter to continue..."
else
  echo "Error: Archive creation failed"
  read -p "Press Enter to continue..."
  exit 1
fi
