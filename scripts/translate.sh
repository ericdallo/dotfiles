#!/usr/bin/env bash

language=$1

input_text=$(rofi -dmenu -p translate &)

notify-send -a Translation "Translation" "$input_text\n<b>$(trans :$language -b "$input_text" | tr -d '\n' | xclip -sel clip -f)</b>"
