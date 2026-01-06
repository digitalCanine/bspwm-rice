#!/usr/bin/env bash
set -euo pipefail

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE="$SCRIPT_DIR/providers"
ROFI="rofi -dmenu -i"
NOTIFY="notify-send"
VPN_CMD="sudo openvpn"

# Helpers
die() {
  $NOTIFY "MultiVPN" "$1"
  exit 1
}
pick_random() { printf "%s\n" "$@" | shuf -n1; }

# Provider menu
providers=()
while IFS= read -r d; do
  [[ -d "$BASE/$d" ]] && providers+=("$d")
done < <(ls "$BASE")

[[ ${#providers[@]} -eq 0 ]] && die "No providers found in $BASE"

provider_menu="[Disconnect]\n[Random Provider]\n$(printf "%s\n" "${providers[@]}" | sort)"
provider=$(echo -e "$provider_menu" | $ROFI -p "Select Provider")
[[ -z "$provider" ]] && exit 0

if [[ "$provider" == "[Disconnect]" ]]; then
  sudo pkill openvpn 2>/dev/null && $NOTIFY "MultiVPN" "Disconnected ✓" || $NOTIFY "MultiVPN" "No active VPN connection"
  exit 0
elif [[ "$provider" == "[Random Provider]" ]]; then
  provider=$(pick_random "${providers[@]}")
  random_provider=true
else
  random_provider=false
fi

AUTH="$BASE/$provider/auth"
SERVER_DIR="$BASE/$provider/servers"

# Dynamic city map
declare -A countries
declare -A city_country_map

# Scan all .ovpn files and extract city-country info
while IFS= read -r f; do
  filename=$(basename "$f" .ovpn)

  # Parse filename format: city-country-###-scramble or city-country-###
  if [[ "$filename" =~ ^([a-z0-9-]+)-([a-z]{2})-([0-9]{3})(-scramble)?$ ]]; then
    city="${BASH_REMATCH[1]}"
    country="${BASH_REMATCH[2]}"
    # Server number is in BASH_REMATCH[3]
    # Scramble flag is in BASH_REMATCH[4]

    # Capitalize city name (replace hyphens with spaces)
    city_display=$(echo "$city" | sed 's/-/ /g' | sed 's/\b\(.\)/\u\1/g')

    # Get full country name from country code
    case "$country" in
    # North America
    us) country_full="United States" ;;
    ca) country_full="Canada" ;;
    mx) country_full="Mexico" ;;

    # Europe - Western
    uk | gb) country_full="United Kingdom" ;;
    de) country_full="Germany" ;;
    fr) country_full="France" ;;
    nl) country_full="Netherlands" ;;
    ch) country_full="Switzerland" ;;
    es) country_full="Spain" ;;
    it) country_full="Italy" ;;
    be) country_full="Belgium" ;;
    at) country_full="Austria" ;;
    ie) country_full="Ireland" ;;
    pt) country_full="Portugal" ;;
    lu) country_full="Luxembourg" ;;

    # Europe - Northern
    se) country_full="Sweden" ;;
    no) country_full="Norway" ;;
    dk) country_full="Denmark" ;;
    fi) country_full="Finland" ;;
    is) country_full="Iceland" ;;

    # Europe - Eastern
    pl) country_full="Poland" ;;
    cz) country_full="Czech Republic" ;;
    hu) country_full="Hungary" ;;
    ro) country_full="Romania" ;;
    bg) country_full="Bulgaria" ;;
    sk) country_full="Slovakia" ;;
    si) country_full="Slovenia" ;;
    hr) country_full="Croatia" ;;
    rs) country_full="Serbia" ;;
    ua) country_full="Ukraine" ;;

    # Europe - Southern
    gr) country_full="Greece" ;;
    tr) country_full="Turkey" ;;
    cy) country_full="Cyprus" ;;
    mt) country_full="Malta" ;;

    # Asia - East
    jp) country_full="Japan" ;;
    kr) country_full="South Korea" ;;
    cn) country_full="China" ;;
    tw) country_full="Taiwan" ;;
    hk) country_full="Hong Kong" ;;
    mo) country_full="Macau" ;;

    # Asia - Southeast
    sg) country_full="Singapore" ;;
    my) country_full="Malaysia" ;;
    th) country_full="Thailand" ;;
    id) country_full="Indonesia" ;;
    ph) country_full="Philippines" ;;
    vn) country_full="Vietnam" ;;

    # Asia - South
    in) country_full="India" ;;
    pk) country_full="Pakistan" ;;
    bd) country_full="Bangladesh" ;;
    lk) country_full="Sri Lanka" ;;

    # Middle East
    ae) country_full="United Arab Emirates" ;;
    sa) country_full="Saudi Arabia" ;;
    il) country_full="Israel" ;;
    qa) country_full="Qatar" ;;
    kw) country_full="Kuwait" ;;
    bh) country_full="Bahrain" ;;
    om) country_full="Oman" ;;
    jo) country_full="Jordan" ;;

    # Oceania
    au) country_full="Australia" ;;
    nz) country_full="New Zealand" ;;

    # South America
    br) country_full="Brazil" ;;
    ar) country_full="Argentina" ;;
    cl) country_full="Chile" ;;
    co) country_full="Colombia" ;;
    pe) country_full="Peru" ;;
    uy) country_full="Uruguay" ;;
    py) country_full="Paraguay" ;;
    ve) country_full="Venezuela" ;;
    ec) country_full="Ecuador" ;;

    # Central America & Caribbean
    cr) country_full="Costa Rica" ;;
    pa) country_full="Panama" ;;
    gt) country_full="Guatemala" ;;
    jm) country_full="Jamaica" ;;
    tt) country_full="Trinidad and Tobago" ;;

    # Africa
    za) country_full="South Africa" ;;
    eg) country_full="Egypt" ;;
    ng) country_full="Nigeria" ;;
    ke) country_full="Kenya" ;;
    ma) country_full="Morocco" ;;
    gh) country_full="Ghana" ;;

    # Baltic States
    ee) country_full="Estonia" ;;
    lv) country_full="Latvia" ;;
    lt) country_full="Lithuania" ;;

    # Other European
    md) country_full="Moldova" ;;
    al) country_full="Albania" ;;
    mk) country_full="North Macedonia" ;;
    ba) country_full="Bosnia and Herzegovina" ;;
    me) country_full="Montenegro" ;;

    # Fallback
    *) country_full=$(echo "$country" | tr '[:lower:]' '[:upper:]') ;;
    esac

    # Add to country map
    if [[ -z "${countries[$country_full]:-}" ]]; then
      countries[$country_full]="$city"
    else
      # Only add if city not already in list
      if [[ ! " ${countries[$country_full]} " =~ " $city " ]]; then
        countries[$country_full]+=" $city"
      fi
    fi

    # Map city -> country for later lookup
    city_country_map[$city]="$country_full"
  fi
done < <(find "$SERVER_DIR" -name "*.ovpn")

[[ ${#countries[@]} -eq 0 ]] && die "No valid .ovpn files found in $SERVER_DIR"

# Country menu
country_menu="[Random Country]\n"
country_menu+="$(printf "%s\n" "${!countries[@]}" | sort)"
country=$(echo -e "$country_menu" | $ROFI -p "Select Country")
[[ -z "$country" ]] && exit 0
if [[ "$country" == "[Random Country]" ]]; then
  country=$(pick_random "${!countries[@]}")
  random_country=true
else
  random_country=false
fi

# City menu
cities=(${countries[$country]})

if [[ "$random_country" == true ]]; then
  city=$(pick_random "${cities[@]}")
  city_display=$(echo "$city" | sed 's/-/ /g' | sed 's/\b\(.\)/\u\1/g')
else
  city_menu="[Random City]\n"
  for c in "${cities[@]}"; do
    city_display=$(echo "$c" | sed 's/-/ /g' | sed 's/\b\(.\)/\u\1/g')
    city_menu+="$city_display\n"
  done

  city_display=$(echo -e "$city_menu" | $ROFI -p "$country")
  [[ -z "$city_display" ]] && exit 0

  if [[ "$city_display" == "[Random City]" ]]; then
    city=$(pick_random "${cities[@]}")
    city_display=$(echo "$city" | sed 's/-/ /g' | sed 's/\b\(.\)/\u\1/g')
  else
    # Convert display name back to filename format
    city=$(echo "$city_display" | tr '[:upper:]' '[:lower:]' | sed 's/ /-/g')
  fi
fi

# Check if scrambled servers exist for this city
mapfile -t scrambled_servers < <(ls "$SERVER_DIR" | grep "^$city-[a-z]\{2\}-[0-9]\{3\}-scramble\.ovpn$" || true)
mapfile -t regular_servers < <(ls "$SERVER_DIR" | grep "^$city-[a-z]\{2\}-[0-9]\{3\}\.ovpn$" || true)

has_scrambled=$([[ ${#scrambled_servers[@]} -gt 0 ]] && echo true || echo false)
has_regular=$([[ ${#regular_servers[@]} -gt 0 ]] && echo true || echo false)

if [[ "$has_scrambled" == true && "$has_regular" == true ]]; then
  # Both types available, ask user
  scramble_menu="Regular\nScrambled\n[Random]"
  scramble_choice=$(echo -e "$scramble_menu" | $ROFI -p "Connection Type")
  [[ -z "$scramble_choice" ]] && exit 0

  case "$scramble_choice" in
  "Regular")
    use_scramble=false
    ;;
  "Scrambled")
    use_scramble=true
    ;;
  "[Random]")
    use_scramble=$([[ $((RANDOM % 2)) -eq 0 ]] && echo true || echo false)
    ;;
  esac
elif [[ "$has_scrambled" == true ]]; then
  # Only scrambled available
  use_scramble=true
elif [[ "$has_regular" == true ]]; then
  # Only regular available
  use_scramble=false
else
  die "No servers found for $city_display"
fi

# Server menu
if [[ "$use_scramble" == true ]]; then
  server_files=("${scrambled_servers[@]}")
  connection_type="🔒 Scrambled"
else
  server_files=("${regular_servers[@]}")
  connection_type="Regular"
fi

[[ "${#server_files[@]}" -eq 0 ]] && die "No $connection_type servers for $city_display"

if [[ "$random_provider" == true || "$random_country" == true ]]; then
  server_file=$(pick_random "${server_files[@]}")
else
  server_menu="[Random Server]\n"
  for s in "${server_files[@]}"; do
    # Extract server number (it's always before -scramble or .ovpn)
    if [[ "$s" =~ -([0-9]{3})(-scramble)?\.ovpn$ ]]; then
      server_menu+="Server ${BASH_REMATCH[1]}\n"
    else
      server_menu+="$s\n"
    fi
  done
  server_menu+="[Disconnect]"

  choice=$(echo -e "$server_menu" | $ROFI -p "$city_display ($connection_type)")
  [[ -z "$choice" ]] && exit 0

  if [[ "$choice" == "[Disconnect]" ]]; then
    sudo killall openvpn && exit 0
  elif [[ "$choice" == "[Random Server]" ]]; then
    server_file=$(pick_random "${server_files[@]}")
  else
    num=$(echo "$choice" | grep -o '[0-9]\{3\}')
    if [[ "$use_scramble" == true ]]; then
      server_file=$(printf "%s\n" "${server_files[@]}" | grep -- "-$num-scramble\.ovpn$")
    else
      server_file=$(printf "%s\n" "${server_files[@]}" | grep -- "-$num\.ovpn$")
    fi
  fi
fi

# Ask for sudo
SUDO_PASS=$(rofi -dmenu -password -p "Enter sudo password")
[[ -z "$SUDO_PASS" ]] && exit 0

# Kill old VPN if existing
echo "$SUDO_PASS" | sudo -S pkill openvpn 2>/dev/null || true

# Notify
$NOTIFY "MultiVPN" "Connecting…\n$provider → $country → $city_display\nType: $connection_type"

# Launch openvpn
echo "$SUDO_PASS" | sudo -S openvpn --config "$SERVER_DIR/$server_file" --auth-user-pass "$AUTH" &

# Wait for VPN to establish and routing to settle
sleep 8

# Get public IP
# Retry a few times to ensure we get the VPN IP
for i in {1..3}; do
  ip=$(curl -s --max-time 5 ifconfig.me 2>/dev/null || echo "")
  [[ -n "$ip" ]] && break
  sleep 2
done

[[ -z "$ip" ]] && ip="Unknown"

$NOTIFY "MultiVPN" "Connected ✓\n$provider → $country → $city_display\nType: $connection_type\nIP: $ip"
