#!/usr/bin/env bash
# flameshot under Hyprland's fractional scaling: its Qt overlay must undo the
# focused monitor's scale (1.2 -> 0.833, 1.6 -> 0.625), or it renders off-size.
set -euo pipefail

scale=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .scale' || true)
[[ $scale =~ ^[0-9]+(\.[0-9]+)?$ ]] || scale=1

QT_SCREEN_SCALE_FACTORS=$(awk -v s="$scale" 'BEGIN { printf "%.3f", 1 / s }')
export QT_SCREEN_SCALE_FACTORS
exec flameshot gui -d 1
