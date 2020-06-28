#!/usr/bin/env bash

language=$1

notify-send -t 5000 "Translation" "$(trans :$language -b "$(rofi -dmenu -p translate &)" | tr -d '\n' | xclip -sel clip -f)"
