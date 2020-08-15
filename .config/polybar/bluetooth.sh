#!/usr/bin/env bash

bt_enabled="$(bluetoothctl show |grep "Powered: yes" |wc -c)"

if [ "$bt_enabled" -eq 0 ]; then
    echo "󰂲"
    return
fi

connected="$(echo info | bluetoothctl | grep 'Device' | wc -c)"
if [ "$connected" -eq 0 ]; then
    echo "󰂯"
    return
fi

mac_address="$(echo info | bluetoothctl | grep 'Device' | head -n 1|  awk '{print $2}')"

echo "%{F#8BE9FD}󰂰"
