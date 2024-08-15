#!/usr/bin/env bash

vpn_running="$(pgrep "$VPN_COMMAND_NAME")"

if [ $# -eq 1 ]; then
    if [ -z "$vpn_running" ]; then
        $VPN_START
        return
    fi
    kill "$vpn_running"
    return
fi

if [ -z "$vpn_running" ]; then
    echo '{"class": "off"}'
    return
fi

echo '{"class": "on"}'
