#!/usr/bin/env bash

CURRENT_DESKTOP=$(wmctrl -d |grep '*' |xargs |awk '{print $1}')
if [ $CURRENT_DESKTOP -eq 1 ]; then
    wmctrl -s 0
else
    wmctrl -s 1
fi
