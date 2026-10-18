#!/usr/bin/env bash
# Waybar custom/wifi module — wifi status that understands two adapters.
#
# The onboard card (wlo1) has a flaky antenna, so an external USB adapter
# is plugged in when it misbehaves. NetworkManager always routes through
# the USB adapter while it is connected (route metrics pinned in
# nix/configurations/hardware.nix); this module mirrors that preference so
# the bar shows the adapter actually carrying traffic. The built-in
# `network` module can't: it either follows the default route (docker0
# whenever the Zscaler VPN is up) or stays pinned to the first interface
# matching a pattern, never noticing the USB adapter when it is plugged in.
#
# States (CSS classes in style.css):
#   * external     (green) — traffic goes through the USB adapter
#   * internal     (white) — connected through the onboard card only
#   * disconnected (red)   — no wifi connection at all
#   * disabled     (red)   — wifi radio is off
#
# Adapters are told apart by their sysfs device path (USB dongles live
# under .../usbN/...), so any dongle works no matter how udev names it.
# Detection stays cheap (safe to poll every few seconds): a handful of
# nmcli calls, all answered from NetworkManager's cache over D-Bus.

ICONS=(󰤟 󰤢 󰤥 󰤨)

_is_usb() {
  readlink -f "/sys/class/net/$1/device" 2>/dev/null | grep -q '/usb'
}

# "signal:ssid" of the AP the device is associated with (empty if none).
_active_ap() {
  local rest
  rest=$(nmcli -t -f IN-USE,SIGNAL,SSID device wifi list ifname "$1" --rescan no 2>/dev/null \
    | grep -m1 '^\*:') || return 0
  rest=${rest#\*:}
  printf '%s' "${rest//\\:/:}" # unescape nmcli's '\:' inside SSIDs
}

_ip_of() { nmcli -g IP4.ADDRESS device show "$1" 2>/dev/null | head -n1; }

_json_escape() { local s=$1; s=${s//\\/\\\\}; s=${s//\"/\\\"}; printf '%s' "$s"; }

# ----- collect wifi devices, split by bus, remember connection state -----
ext_dev='' ext_state='' int_dev='' int_state=''
while IFS=: read -r dev type state; do
  [ "$type" = wifi ] || continue
  if _is_usb "$dev"; then
    [ -n "$ext_dev" ] || { ext_dev=$dev ext_state=$state; }
  else
    [ -n "$int_dev" ] || { int_dev=$dev int_state=$state; }
  fi
done < <(nmcli -t -f DEVICE,TYPE,STATE device status 2>/dev/null)

if [ "$(nmcli -t radio wifi 2>/dev/null)" = disabled ]; then
  echo '{"text": "󰤮 --", "class": "disabled", "tooltip": "wifi radio is off"}'
  exit 0
fi

# One tooltip line per adapter, always, so the flaky antenna is easy to
# watch. Output is JSON-ready: SSIDs are escaped, '\n' is a JSON newline.
_describe() { # args: dev state label
  local ap sig ssid ip
  [ -n "$1" ] || return 0
  if [[ $2 == connected* ]]; then
    ap=$(_active_ap "$1")
    sig=${ap%%:*} ssid=$(_json_escape "${ap#*:}") ip=$(_ip_of "$1")
    printf '\\n%s (%s): %s %s%% — %s' "$1" "$3" "${ssid:-?}" "${sig:-0}" "${ip:-no ip}"
  else
    printf '\\n%s (%s): %s' "$1" "$3" "$2"
  fi
}
detail="$(_describe "$ext_dev" "$ext_state" "usb adapter")$(_describe "$int_dev" "$int_state" "onboard")"

# ----- pick the adapter to show: connected usb wins, like the routing -----
if [[ $ext_state == connected* ]]; then
  dev=$ext_dev class=external label="usb adapter"
elif [[ $int_state == connected* ]]; then
  dev=$int_dev class=internal label="onboard"
else
  echo "{\"text\": \"󰤣 --\", \"class\": \"disconnected\", \"tooltip\": \"wifi disconnected$detail\"}"
  exit 0
fi

ap=$(_active_ap "$dev")
sig=${ap%%:*} ssid=${ap#*:}
# Associated but not yet in the scan cache: fall back to the profile name.
[ -n "$ssid" ] || ssid=$(nmcli -g GENERAL.CONNECTION device show "$dev" 2>/dev/null)
sig=${sig:-0}
icon=${ICONS[$((sig >= 100 ? 3 : sig * 4 / 100))]}

tooltip="$(_json_escape "$ssid") — ${sig}% via $dev ($label)$detail"
echo "{\"text\": \"$icon $sig\", \"class\": \"$class\", \"tooltip\": \"$tooltip\"}"
