#!/usr/bin/env bash

vpn_running="$(pgrep "$VPN_COMMAND_NAME")"

if [ $# -eq 1 ]; then
    if [ -z "$vpn_running" ]; then
        $VPN_START
        return
    fi
    sudo kill "$vpn_running"
    return
fi

if [ -z "$vpn_running" ]; then
    echo "󰯄"
    return
fi

echo "%{F#FF79C6}󰯄"
