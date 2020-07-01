#!/usr/bin/env bash

desktop=$(bspc query -D -d focused --names)

if [[ $desktop == "tty" ]]; then
    bspc desktop -f last
else
    bspc desktop -f tty
fi
