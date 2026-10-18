#!/usr/bin/env bash
# Waybar custom/monitor module - manage external display on Hyprland.
#   no args          : emit JSON state for waybar (hidden when no external).
#   `toggle`         : flip mirror <-> extend on the first external monitor.
#   `reapply-mirror` : re-issue the mirror config (used to clear stale
#                      framebuffer borders that appear on initial hot-plug)
#                      AND set the primary panel to MIRROR_MODE so the
#                      mirror is 1:1 (no letterboxing on the external).
#   `restore-native` : reset the primary panel to its panel-native (preferred)
#                      mode. Used on monitor unplug or extend-mode entry.
#   `internal-toggle`: flip "external only" mode: the primary panel is
#                      disabled while an external display is connected (e.g.
#                      a broken/unused laptop screen, to save power). The
#                      choice persists per machine in $STATE_FILE; unplugging
#                      the external always brings the primary back.
#   `reapply`        : re-apply the configured layout (external-only when
#                      $STATE_FILE exists, otherwise `reapply-mirror`).
#   `daemon`         : long-running listener on Hyprland's socket2 that
#                      runs `reapply` on every monitor hot-plug and
#                      `restore-native` on every external monitor removal.
#                      Started from hyprland.conf via `exec-once`.

set -u

PRIMARY="eDP-1"
# Everything after the mode field of the eDP-1 monitor line: position, scale,
# bitdepth. Must match hyprland.conf for `restore-native` to fully match the
# config-defined state.
PRIMARY_TAIL="0x0,1.2,bitdepth,8"
# Mode forced on the primary while mirroring so the external display sees a
# 1:1 frame (matches the Dell P2719H's preferred resolution).
MIRROR_MODE="1920x1080@60"
ICON="󰍺"
# Machine-local (not in the dotfiles repo): present = "external only" mode.
STATE_FILE="${XDG_STATE_HOME:-$HOME/.local/state}/hypr/internal-off"
# The catch-all rule for any other monitor (must match hyprland.conf). In
# external-only mode it is swapped for a non-mirroring one: some monitors
# re-assert hot-plug a few seconds after a modeset, and a reconnect must not
# bring the external back as a mirror of the disabled panel.
CATCHALL_MIRROR=",preferred,auto,1,mirror,${PRIMARY}"
CATCHALL_STANDALONE=",preferred,auto,1"

# Parse `hyprctl monitors all` text output.
# `all` is required because mirrored monitors are hidden from plain
# `hyprctl monitors`. Each block starts with: "Monitor <name> (ID N):"
# Inside it we look for a line like: "    mirrorOf: <value>" — value is "none"
# when not mirroring, otherwise the source monitor's ID or name.
mapfile -t MON_LINES < <(hyprctl monitors all 2>/dev/null)

current=""
declare -A MIRROR_OF=()
declare -A DISABLED=()
ORDER=()
for line in "${MON_LINES[@]}"; do
    if [[ $line =~ ^Monitor[[:space:]]+([^[:space:]]+)[[:space:]]+\(ID ]]; then
        current="${BASH_REMATCH[1]}"
        ORDER+=("$current")
        MIRROR_OF["$current"]="none"
        DISABLED["$current"]="false"
    elif [[ -n $current ]]; then
        if [[ $line =~ ^[[:space:]]*mirrorOf:[[:space:]]*(.+)$ ]]; then
            MIRROR_OF["$current"]="${BASH_REMATCH[1]}"
        elif [[ $line =~ ^[[:space:]]*mirror[[:space:]]+of:[[:space:]]*(.+)$ ]]; then
            MIRROR_OF["$current"]="${BASH_REMATCH[1]}"
        elif [[ $line =~ ^[[:space:]]*disabled:[[:space:]]*(true|false) ]]; then
            DISABLED["$current"]="${BASH_REMATCH[1]}"
        fi
    fi
done

# Pick the first monitor whose name differs from the primary panel.
EXTERNAL=""
for m in "${ORDER[@]}"; do
    if [[ $m != "$PRIMARY" ]]; then
        EXTERNAL="$m"
        break
    fi
done

is_mirroring() {
    local v="${MIRROR_OF[$1]:-none}"
    [[ -n $v && $v != "none" ]]
}

# Force the primary panel into the mirror-friendly mode so mirroring an
# external display whose preferred resolution is MIRROR_MODE is 1:1.
set_primary_mirror_mode() {
    hyprctl keyword monitor "${PRIMARY},${MIRROR_MODE},${PRIMARY_TAIL}" >/dev/null
}

# Restore the primary panel to its panel-native (preferred) mode.
set_primary_native_mode() {
    hyprctl keyword monitor "${PRIMARY},preferred,${PRIMARY_TAIL}" >/dev/null
}

internal_off_wanted() {
    [[ -e $STATE_FILE ]]
}

primary_disabled() {
    [[ ${DISABLED[$PRIMARY]:-false} == true ]]
}

# Stop mirroring and make the external a display of its own. Hyprland 0.55
# doesn't advertise a wl_output for a monitor that merely stops mirroring,
# so clients (waybar, swaybg) never draw on it; cycling it through
# `disable` forces a fresh output.
make_external_standalone() {
    hyprctl keyword monitor "${EXTERNAL},preferred,auto,1" >/dev/null
    hyprctl keyword monitor "${EXTERNAL},disable" >/dev/null
    sleep 0.5
    hyprctl keyword monitor "${EXTERNAL},preferred,auto,1" >/dev/null
}

# External only: make the external standalone first (it must never mirror a
# disabled output), then disable the primary panel. Idempotent — it only
# touches what isn't in place yet — so the hot-plug events these steps emit
# (handled by the daemon via `reapply`) settle instead of looping.
apply_internal_off() {
    if is_mirroring "$EXTERNAL"; then
        hyprctl keyword monitor "$CATCHALL_STANDALONE" >/dev/null
        make_external_standalone
    fi
    if ! primary_disabled; then
        hyprctl keyword monitor "${PRIMARY},disable" >/dev/null
    fi
}

notify() {
    if command -v notify-send >/dev/null 2>&1; then
        notify-send -t 2500 "Monitor" "$1"
    fi
}

if [[ "${1:-}" == "daemon" ]]; then
    # Listen for Hyprland monitor hot-plug events and re-apply mirror
    # afterwards. This works around a Hyprland glitch where the initial
    # mirror set up by the catch-all `monitor=` rule leaves stale framebuffer
    # content in the border regions of the larger display; re-issuing the
    # same `hyprctl keyword monitor` (what `toggle` already does) clears it.
    SIGNATURE="${HYPRLAND_INSTANCE_SIGNATURE:-}"
    SOCKET="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/hypr/${SIGNATURE}/.socket2.sock"
    if [[ -z $SIGNATURE || ! -S $SOCKET ]]; then
        echo "monitor.sh daemon: hyprland socket2 not available ($SOCKET)" >&2
        exit 1
    fi

    # Cover the case where Hyprland was started with a monitor already
    # attached: the catch-all rule fires before we exist, so no
    # `monitoradded` event reaches us for that initial output.
    ( sleep 1 && "$0" reapply ) &

    # Event loop. nc dies if the socket goes away (e.g. Hyprland restart);
    # retry while the socket still exists. We deliberately only react to
    # add / remove events and NOT `monitorlayoutchanged` — our own actions
    # fire that and would create a loop.
    while [[ -S $SOCKET ]]; do
        while IFS= read -r line; do
            case $line in
                monitoraddedv2\>\>*|monitoradded\>\>*)
                    ( sleep 0.5 && "$0" reapply ) &
                    ;;
                monitorremovedv2\>\>*|monitorremoved\>\>*)
                    # v1 is ">>NAME", v2 is ">>ID,NAME,DESCRIPTION".
                    name=${line#*>>}
                    if [[ $line == monitorremovedv2* ]]; then
                        name=${name#*,}
                        name=${name%%,*}
                    fi
                    # The primary panel is never unplugged: its removal means
                    # it was disabled on purpose (external-only mode). Only
                    # an external going away must bring the primary back.
                    [[ $name == "$PRIMARY" ]] && continue
                    ( sleep 0.5 && "$0" restore-native ) &
                    ;;
            esac
        done < <(nc -U "$SOCKET" 2>/dev/null)
        sleep 1
    done
    exit 0
fi

if [[ "${1:-}" == "reapply" ]]; then
    if [[ -n $EXTERNAL ]] && internal_off_wanted; then
        apply_internal_off
        exit 0
    fi
    exec "$0" reapply-mirror
fi

if [[ "${1:-}" == "internal-toggle" ]]; then
    if internal_off_wanted; then
        rm -f "$STATE_FILE"
        if [[ -n $EXTERNAL ]]; then
            # Back to the default layout: primary on, external mirroring it.
            set_primary_mirror_mode
            hyprctl keyword monitor "${EXTERNAL},preferred,auto,1,mirror,${PRIMARY}" >/dev/null
        else
            set_primary_native_mode
        fi
        notify "${PRIMARY} on"
    elif [[ -z $EXTERNAL ]]; then
        # Never leave the session without any display.
        notify "No external display connected"
    else
        mkdir -p "${STATE_FILE%/*}"
        : > "$STATE_FILE"
        # apply_internal_off swaps the catch-all rule only when coming from
        # mirror; coming from extend, swap it here.
        is_mirroring "$EXTERNAL" || hyprctl keyword monitor "$CATCHALL_STANDALONE" >/dev/null
        apply_internal_off
        notify "${EXTERNAL} only (${PRIMARY} off)"
    fi
    exit 0
fi

if [[ "${1:-}" == "reapply-mirror" ]]; then
    # No-op when no external is connected, or when it is currently extended
    # (we don't want to undo the user's manual `toggle` to extend).
    if [[ -n $EXTERNAL ]] && is_mirroring "$EXTERNAL"; then
        # Match modes first so the mirror is 1:1, then re-issue the mirror.
        set_primary_mirror_mode
        hyprctl keyword monitor "${EXTERNAL},preferred,auto,1,mirror,${PRIMARY}" >/dev/null
    fi
    exit 0
fi

if [[ "${1:-}" == "restore-native" ]]; then
    # Run by the daemon when a non-primary output goes away. If the external
    # is still listed, that was our own disable/enable cycle (or a hot-plug
    # flap): in external-only mode the primary must then stay off. Once the
    # external is really gone, this brings the primary back.
    if [[ -n $EXTERNAL ]] && internal_off_wanted; then
        exit 0
    fi
    set_primary_native_mode
    exit 0
fi

if [[ "${1:-}" == "toggle" ]]; then
    if [[ -z $EXTERNAL ]]; then
        notify "No external display connected"
        exit 0
    fi
    # Mirror and extend both use the primary panel: leave external-only
    # mode (from there, the branch below goes back to mirror).
    if internal_off_wanted; then
        rm -f "$STATE_FILE"
        set_primary_mirror_mode
        hyprctl keyword monitor "$CATCHALL_MIRROR" >/dev/null
    fi
    if is_mirroring "$EXTERNAL"; then
        # Mirror -> Extend: break the mirror first, then restore the primary
        # to its native mode (no need to keep it down at MIRROR_MODE).
        make_external_standalone
        set_primary_native_mode
    else
        # Extend -> Mirror: drop the primary to MIRROR_MODE first so the
        # subsequent mirror is 1:1, then re-attach the mirror clause.
        set_primary_mirror_mode
        hyprctl keyword monitor "${EXTERNAL},preferred,auto,1,mirror,${PRIMARY}" >/dev/null
    fi
    exit 0
fi

# Default branch: emit JSON state for waybar.
if [[ -z $EXTERNAL ]]; then
    echo '{"text": "", "class": "hidden"}'
    exit 0
fi

if internal_off_wanted; then
    printf '{"text": "%s", "class": "internal-off", "tooltip": "%s only (%s off) — right-click: turn %s on"}\n' \
        "$ICON" "$EXTERNAL" "$PRIMARY" "$PRIMARY"
elif is_mirroring "$EXTERNAL"; then
    printf '{"text": "%s", "class": "mirror", "tooltip": "%s: mirroring %s — right-click: %s only"}\n' \
        "$ICON" "$EXTERNAL" "$PRIMARY" "$EXTERNAL"
else
    printf '{"text": "%s", "class": "extend", "tooltip": "%s: extending %s — right-click: %s only"}\n' \
        "$ICON" "$EXTERNAL" "$PRIMARY" "$EXTERNAL"
fi
