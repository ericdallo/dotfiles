#!/usr/bin/env bash

drive_running="$(pgrep "$DRIVE_COMMAND_NAME")"

if [ $# -eq 1 ]; then
    if [ -z "$drive_running" ]; then
        mount | grep "$HOME/google-drive" >/dev/null || google-drive-ocamlfuse "$HOME/google-drive" -xdgbd
        exit 0
    fi
    sudo kill "$drive_running"
    exit 0
fi

if [ -z "$drive_running" ]; then
    echo '{"class": "off"}'
    exit 0
fi

echo '{"class": "on"}'
