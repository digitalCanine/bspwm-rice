#!/bin/bash
# Colors
GREEN="%{F#b4be7b}"
BLUE="%{F#afb979}"
DIM="%{F#778284}"
RESET="%{F-}"

STATE_FILE="/tmp/polybar-toggle-state"

# --- CLICK DETECTION ---
if [ -f "$STATE_FILE" ]; then
  LAST_MOD=$(stat -c %Y "$STATE_FILE" 2>/dev/null || echo 0)
  CURRENT_TIME=$(date +%s)
  if [ $((CURRENT_TIME - LAST_MOD)) -lt 2 ]; then
    rm "$STATE_FILE"
    FORCE_TOGGLE=1
  fi
fi

# --- WINDOW (ALWAYS IMMEDIATE) ---
WINDOW=$(xdotool getactivewindow getwindowname 2>/dev/null || echo "Desktop")
WINDOW="${WINDOW:0:50}"

# --- MEDIA INFO ---
MEDIA_STATUS=$(playerctl status 2>/dev/null)
MEDIA=$(playerctl metadata --format "{{ artist }} - {{ title }}" 2>/dev/null)
MEDIA="${MEDIA:0:50}"

# --- ROTATION TIMER (MEDIA ONLY) ---
CURRENT_SECOND=$(date +%s)
SHOW_MEDIA=$(((CURRENT_SECOND / 2) % 2))

# Manual toggle flips media visibility only
if [ -n "$FORCE_TOGGLE" ]; then
  SHOW_MEDIA=$((1 - SHOW_MEDIA))
fi

# --- DISPLAY LOGIC ---
if [ -n "$MEDIA" ] && [ "$MEDIA_STATUS" = "Playing" ] && [ $SHOW_MEDIA -eq 1 ]; then
  echo "${GREEN}♫${RESET} ${MEDIA}"
else
  echo "${BLUE}${RESET} ${WINDOW}"
fi
