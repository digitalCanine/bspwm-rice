#!/usr/bin/env bash

# Default values
MODE=""
NORMAL_COLOR=""
CRITICAL_COLOR=""
CRITICAL_THRESHOLD=80
CLICK_ACTION=false

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
  --cpu)
    MODE="cpu"
    shift
    ;;
  --ram)
    MODE="ram"
    shift
    ;;
  --gpu)
    MODE="gpu"
    shift
    ;;
  --normal-color)
    NORMAL_COLOR="$2"
    shift 2
    ;;
  --critical-color)
    CRITICAL_COLOR="$2"
    shift 2
    ;;
  --click)
    CLICK_ACTION=true
    shift
    ;;
  *)
    echo "Unknown option: $1"
    exit 1
    ;;
  esac
done

# Function to get CPU usage
get_cpu_usage() {
  # Using top to get CPU usage
  local cpu_usage=$(top -bn2 -d 0.5 | grep "Cpu(s)" | tail -n1 | awk '{print $2}' | cut -d'%' -f1)

  # If top doesn't work, try mpstat
  if [ -z "$cpu_usage" ]; then
    if command -v mpstat >/dev/null 2>&1; then
      cpu_usage=$(mpstat 1 1 | awk '/Average:/ {print 100 - $NF}')
    fi
  fi

  # Round to integer
  printf "%.0f" "$cpu_usage"
}

# Function to get RAM usage
get_ram_usage() {
  local mem_info=$(free | grep Mem)
  local total=$(echo "$mem_info" | awk '{print $2}')
  local used=$(echo "$mem_info" | awk '{print $3}')
  local percentage=$(awk "BEGIN {printf \"%.0f\", ($used/$total)*100}")
  echo "$percentage"
}

# Function to get GPU usage (NVIDIA)
get_gpu_usage() {
  if command -v nvidia-smi >/dev/null 2>&1; then
    local gpu_usage=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits | head -n1)
    echo "$gpu_usage"
  elif command -v radeontop >/dev/null 2>&1; then
    # For AMD GPUs - this requires radeontop
    local gpu_usage=$(radeontop -d - -l 1 | grep -o "gpu [0-9]*" | awk '{print $2}')
    echo "$gpu_usage"
  elif command -v intel_gpu_top >/dev/null 2>&1; then
    # For Intel GPUs - approximate method
    echo "0"
  else
    echo "N/A"
  fi
}

# Function to format output with color
format_output() {
  local value="$1"
  local normal_color="$2"
  local critical_color="$3"

  # Check if value is a number
  if [[ "$value" =~ ^[0-9]+$ ]]; then
    if [ "$value" -ge "$CRITICAL_THRESHOLD" ] && [ -n "$critical_color" ]; then
      echo "%{F${critical_color}}${value}%%{F-}"
    elif [ -n "$normal_color" ]; then
      echo "%{F${normal_color}}${value}%%{F-}"
    else
      echo "${value}%"
    fi
  else
    # Not a number (like N/A)
    echo "$value"
  fi
}

# Handle click actions
handle_click() {
  case $MODE in
  cpu)
    # Open system monitor or htop
    if command -v htop >/dev/null 2>&1; then
      alacritty -e htop &
    elif command -v gnome-system-monitor >/dev/null 2>&1; then
      gnome-system-monitor &
    elif command -v xfce4-taskmanager >/dev/null 2>&1; then
      xfce4-taskmanager &
    else
      notify-send "System Info" "No system monitor found"
    fi
    ;;
  gpu)
    # Open nvidia-smi or GPU monitor
    if command -v nvidia-smi >/dev/null 2>&1; then
      alacritty -e watch -n 1 nvidia-smi &
    else
      notify-send "System Info" "No GPU monitor available"
    fi
    ;;
  esac
}

# Main logic
main() {
  if [ "$CLICK_ACTION" = true ]; then
    handle_click
    exit 0
  fi

  case $MODE in
  cpu)
    usage=$(get_cpu_usage)
    format_output "$usage" "$NORMAL_COLOR" "$CRITICAL_COLOR"
    ;;
  ram)
    usage=$(get_ram_usage)
    format_output "$usage" "$NORMAL_COLOR" "$CRITICAL_COLOR"
    ;;
  gpu)
    usage=$(get_gpu_usage)
    format_output "$usage" "$NORMAL_COLOR" "$CRITICAL_COLOR"
    ;;
  *)
    echo "Error: Specify --cpu, --ram, or --gpu"
    exit 1
    ;;
  esac
}

main
