#!/usr/bin/env sh
profile=$(echo "Mirror HDMI-1\nMirror HDMI-2\nDisconnect all" | rofi -dmenu -p "Select option" -no-custom)
case $profile in

    "Mirror HDMI-1")
    xrandr --output eDP-1 --primary --mode 1920x1080 --output HDMI-1 --mode 1920x1080 --same-as eDP-1
    ;;

    "Mirror HDMI-2")
    xrandr --output eDP-1 --primary --mode 1920x1080 --output HDMI-2 --mode 1920x1080 --same-as eDP-1
    ;;

    "Disconnect all")
    xrandr --output eDP-1 --primary --mode 1920x1080 --output HDMI-1 --off --output HDMI-2 --off
    ;;

    *)
    exit 0
    ;;

esac
sleep 2
bspc wm -r
