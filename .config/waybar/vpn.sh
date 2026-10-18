#!/usr/bin/env bash
# Waybar custom/vpn module — Zscaler ZTNA indicator + click-to-toggle.
#
# States (CSS classes in style.css):
#   * on         (pink)   — tunnel up inside the container AND host integrated
#   * needs-auth (orange) — an Okta SSO tab was opened and not completed yet
#   * connecting (yellow) — container up but tunnel forming / reconnecting /
#                           host integration pending
#   * off        (white)  — container not running
#
# Detection stays cheap (safe to poll every few seconds):
#   * one `docker exec` (~80ms) reads the tunnel iface + last ZPA auth state;
#     if it fails, the container isn't running → off.
#   * needs-auth is host-side: the SSO opener appends "[opener] opening: …" to
#     /tmp/zsc-opener.log when it pops the Okta tab (the log is truncated on
#     every `zscaler up`), and the zsa:// callback handler appends to
#     /tmp/zsa-handler.log when the login completes — an "opening" newer than
#     the last callback, while the tunnel is down, means the login is pending.
#   * host integration = the synthetic route 100.64.0.0/16 via docker0. Note
#     the route alone doesn't mean the VPN works: it lingers when the tunnel
#     drops (e.g. wifi loss), which is exactly when we show "connecting".
# Click toggles: down if the container is running, otherwise up (which opens
# the Okta login in your browser).
NAME=zscaler
SYN_NET=100.64.0.0/16
BR=docker0
OPENER_LOG=/tmp/zsc-opener.log
HANDLER_LOG=/tmp/zsa-handler.log

_container_up() { docker ps --format '{{.Names}}' 2>/dev/null | grep -qx "$NAME"; }
_integrated()   { ip route show "$SYN_NET" 2>/dev/null | grep -q "$BR"; }

# on-click: a single arg ("toggle") flips the connection.
if [ $# -eq 1 ]; then
  if _container_up; then
    zscaler down >/tmp/zsc-waybar.log 2>&1 &
  else
    zscaler up >/tmp/zsc-waybar.log 2>&1 &
  fi
  disown
  exit 0
fi

# One exec: line 1 = tunnel up|down, line 2 = last ZPA auth state (may be empty).
# shellcheck disable=SC2016  # $f expands inside the container, on purpose
probe=$(timeout 2 docker exec "$NAME" bash -c '
  ip -br link 2>/dev/null | grep -q zcctun && echo up || echo down
  f=$(ls -t /var/log/zscaler/.Zscaler/Logs/zstunnel_*.log 2>/dev/null | head -1)
  [ -n "$f" ] && grep -hoE "getZpnAuthState:[A-Z_]+" "$f" 2>/dev/null | tail -1
' 2>/dev/null)

if [ -z "$probe" ]; then # exec failed → container not running
  echo '{"class": "off", "tooltip": "Zscaler: disconnected — click to connect"}'
  exit 0
fi

tun=$(head -n1 <<<"$probe")
zpa=$(sed -n '2s/.*getZpnAuthState://p' <<<"$probe")
[ -n "$zpa" ] && zpa="\\nZPA: $zpa"

# An Okta tab was opened after the last completed zsa:// callback → pending.
_auth_pending() {
  tail -n1 "$OPENER_LOG" 2>/dev/null | grep -q '^\[opener\] opening:' || return 1
  [ ! -f "$HANDLER_LOG" ] || [ "$OPENER_LOG" -nt "$HANDLER_LOG" ]
}

if [ "$tun" = up ] && _integrated; then
  echo "{\"class\": \"on\", \"tooltip\": \"Zscaler: connected (tunnel up, host integrated) — click to disconnect$zpa\"}"
elif [ "$tun" = up ]; then
  echo "{\"class\": \"connecting\", \"tooltip\": \"Zscaler: tunnel up, integrating the host… (zscaler reintegrate if stuck)$zpa\"}"
elif _auth_pending; then
  echo "{\"class\": \"needs-auth\", \"tooltip\": \"Zscaler: waiting for the Okta login — finish it in the browser tab$zpa\"}"
elif _integrated; then
  echo "{\"class\": \"connecting\", \"tooltip\": \"Zscaler: reconnecting — tunnel dropped (network hiccup?)$zpa\"}"
else
  echo "{\"class\": \"connecting\", \"tooltip\": \"Zscaler: connecting — tunnel not up yet$zpa\"}"
fi
