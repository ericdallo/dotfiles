#!/usr/bin/env bash

set -e

filename=~/Videos/recording-$(date -u +"%Y-%m-%d.%H.%M.%S")

wf-recorder -f "$filename".mp4 -y -g "$(slurp)"
gifski -o "$filename".gif "$filename".mp4
notify-send "Saved as $filename.gif"
