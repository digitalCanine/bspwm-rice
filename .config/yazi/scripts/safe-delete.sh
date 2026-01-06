#!/usr/bin/env bash

BACKUP_DIR="/drives/rei/backup"

# Hard-delete whitelist (exact real paths)
ALLOW_DELETE=(
  "$HOME/.cache"
  "/drives/rei/backup"
)

mkdir -p "$BACKUP_DIR"

for item in "$@"; do
  real_item="$(realpath "$item" 2>/dev/null)"

  # Check if the item is in the hard-delete whitelist
  for allowed in "${ALLOW_DELETE[@]}"; do
    real_allowed="$(realpath "$allowed" 2>/dev/null)"
    if [[ "$real_item" == "$real_allowed"* ]]; then
      rm -rf -- "$item"
      continue 2
    fi
  done

  # Otherwise move to backup with timestamp
  base="$(basename "$item")"
  ts="$(date +%Y%m%d_%H%M%S)"

  mv -- "$item" "$BACKUP_DIR/$base-$ts"
done
