#!/usr/bin/env bash

drive_running="$(pgrep "$DRIVE_COMMAND_NAME")"

if [ $# -eq 1 ]; then
    if [ -z "$drive_running" ]; then
        mount | grep "$HOME/google-drive" >/dev/null || google-drive-ocamlfuse "$HOME/google-drive" -xdgbd
        return
    fi
    sudo kill "$drive_running"
    return
fi

if [ -z "$drive_running" ]; then
    echo "󰊶"
    return
fi

echo "%{F#50FA7B}󰊶"
