#!/usr/bin/env bash
# digitalCanine [DC] VPN Launcher (polybar-safe)

UI="$HOME/Documents/openvpn/vpn-ui.sh"

# detach completely from polybar
nohup "$UI" >/dev/null 2>&1 &

exit 0
