#!/usr/bin/env bash

tailscale_up="$(tailscale status --json 2>/dev/null | grep '"BackendState"' | grep -q '"Running"' && echo 1)"

if [ $# -eq 1 ]; then
    if [ -n "$tailscale_up" ]; then
        sudo tailscale down
    else
        sudo tailscale up
    fi
    exit 0
fi

if [ -n "$tailscale_up" ]; then
    echo '{"class": "on"}'
else
    echo '{"class": "off"}'
fi
