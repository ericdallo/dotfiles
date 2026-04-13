#!/usr/bin/env bash

PIDFILE="${XDG_RUNTIME_DIR:-/tmp}/lid-keep-awake.pid"

lid_awake=""
if [ -f "$PIDFILE" ]; then
    pid=$(cat "$PIDFILE" 2>/dev/null)
    if [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null; then
        lid_awake="1"
    else
        rm -f "$PIDFILE"
    fi
fi

if [ $# -eq 1 ]; then
    if [ -n "$lid_awake" ]; then
        kill "$pid" 2>/dev/null
        rm -f "$PIDFILE"
    else
        systemd-inhibit --what=handle-lid-switch \
            --who="lid-keep-awake" \
            --why="Keep system running on lid close" \
            --mode=block \
            sleep infinity &
        echo $! > "$PIDFILE"
    fi
    exit 0
fi

if [ -n "$lid_awake" ]; then
    echo '{"class": "on"}'
    exit 0
fi
echo '{"class": "off"}'
