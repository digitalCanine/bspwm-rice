#!/usr/bin/env bash

# Wallpaper directory
WALLPAPER_DIR="$HOME/.config/bspwm/wallpaper"

# Supported image formats
IMAGE_FORMATS=("jpg" "jpeg" "png" "webp" "bmp" "gif")

# Function to detect wallpaper setter tool
detect_wallpaper_tool() {
  if command -v feh >/dev/null 2>&1; then
    echo "feh"
  elif command -v nitrogen >/dev/null 2>&1; then
    echo "nitrogen"
  elif command -v xwallpaper >/dev/null 2>&1; then
    echo "xwallpaper"
  elif command -v hsetroot >/dev/null 2>&1; then
    echo "hsetroot"
  elif command -v swaybg >/dev/null 2>&1; then
    echo "swaybg"
  else
    echo "none"
  fi
}

# Function to set wallpaper using detected tool
set_wallpaper() {
  local wallpaper="$1"
  local tool="$2"

  case "$tool" in
  feh)
    feh --bg-fill "$wallpaper" >/dev/null 2>&1
    ;;
  nitrogen)
    nitrogen --set-zoom-fill --save "$wallpaper" >/dev/null 2>&1
    ;;
  xwallpaper)
    xwallpaper --zoom "$wallpaper" >/dev/null 2>&1
    ;;
  hsetroot)
    hsetroot -fill "$wallpaper" >/dev/null 2>&1
    ;;
  swaybg)
    killall swaybg 2>/dev/null
    swaybg -i "$wallpaper" -m fill >/dev/null 2>&1 &
    ;;
  *)
    echo "Error: No wallpaper setter found. Install feh, nitrogen, xwallpaper, or hsetroot."
    exit 1
    ;;
  esac
}

# Function to find wallpapers in directory
find_wallpapers() {
  local dir="$1"
  local pattern=""

  # Build find pattern for all supported formats
  for fmt in "${IMAGE_FORMATS[@]}"; do
    if [ -z "$pattern" ]; then
      pattern="-iname *.${fmt}"
    else
      pattern="$pattern -o -iname *.${fmt}"
    fi
  done

  # Find all wallpapers
  eval "find '$dir' -maxdepth 1 -type f \( $pattern \) 2>/dev/null"
}

# Main logic
main() {
  # Check if wallpaper directory exists
  if [ ! -d "$WALLPAPER_DIR" ]; then
    echo "Error: Wallpaper directory '$WALLPAPER_DIR' does not exist."
    exit 1
  fi

  # Detect wallpaper tool
  TOOL=$(detect_wallpaper_tool)
  if [ "$TOOL" = "none" ]; then
    echo "Error: No wallpaper setter found. Please install feh, nitrogen, xwallpaper, or hsetroot."
    exit 1
  fi

  # Find all wallpapers
  mapfile -t WALLPAPERS < <(find_wallpapers "$WALLPAPER_DIR")

  if [ ${#WALLPAPERS[@]} -eq 0 ]; then
    echo "Error: No wallpapers found in '$WALLPAPER_DIR'"
    exit 1
  fi

  # Select random wallpaper
  RANDOM_INDEX=$((RANDOM % ${#WALLPAPERS[@]}))
  SELECTED_WALLPAPER="${WALLPAPERS[$RANDOM_INDEX]}"

  # Set the wallpaper
  echo "Setting wallpaper: $(basename "$SELECTED_WALLPAPER")"
  set_wallpaper "$SELECTED_WALLPAPER" "$TOOL"

  # Save current wallpaper path for reference
  echo "$SELECTED_WALLPAPER" >"$HOME/.config/bspwm/current_wallpaper"

  echo "Wallpaper set successfully using $TOOL"
}

# Run main function
main "$@"
