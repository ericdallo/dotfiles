#!/usr/bin/env bash
set -euo pipefail

text=$($HOME/dev/clipure/clipure history | rofi -dmenu -p "Select entry" -no-custom)
echo $text | xclip -selection clipboard
