#!/usr/bin/env bash

PATH_AC0="/sys/class/power_supply/AC0"
PATH_BATTERY="/sys/class/power_supply/BAT0"

ac=0
battery_level=0
battery_max=0

battery_low_color="#E06C75"

if [ -f "$PATH_AC0/online" ]; then
    ac=$(cat "$PATH_AC0/online")
fi

if [ -f "$PATH_BATTERY/energy_now" ]; then
    battery_level=$(cat "$PATH_BATTERY/energy_now")
fi

if [ -f "$PATH_BATTERY/energy_full" ]; then
    battery_max=$(cat "$PATH_BATTERY/energy_full")
fi

battery_percent=$(("$battery_level * 100 / $battery_max"))

if [ "$ac" -eq 1 ]; then
    icon=""
else
    if [ "$battery_percent" -gt 96 ]; then
        icon=""
    elif [ "$battery_percent" -gt 90 ]; then
        icon=""
    elif [ "$battery_percent" -gt 80 ]; then
        icon=""
    elif [ "$battery_percent" -gt 70 ]; then
        icon=""
    elif [ "$battery_percent" -gt 60 ]; then
        icon=""
    elif [ "$battery_percent" -gt 50 ]; then
        icon=""
    elif [ "$battery_percent" -gt 40 ]; then
        icon=""
    elif [ "$battery_percent" -gt 30 ]; then
        icon=""
    elif [ "$battery_percent" -gt 20 ]; then
        icon="󰁻"
    elif [ "$battery_percent" -gt 10 ]; then
        icon=""
    else
        icon=""
    fi
fi

msg="$icon $battery_percent"

if [[ "$battery_percent" -le 8 ]]; then
    msg="%{o$battery_low_color}%{F$battery_low_color}$msg%{F- o-}"
fi

echo "$msg"
