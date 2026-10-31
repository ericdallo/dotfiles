#!/usr/bin/env bash
# Records a screen region (picked with slurp) to ~/Videos, then turns it into
# a GIF. Shift+Print starts it and Super+Shift+Print stops it (hyprland.conf):
# SIGINT makes wl-screenrec finalize the MP4.
#
# Guards against forgotten recordings: two started 12s apart (Oct 2026) ran
# for 3 days, taking a CPU core and the GPU, writing 30 GB, and piling up
# millions of buffer objects inside Hyprland, which froze it for minutes when
# they finally stopped.
#   * One recording at a time: Shift+Print while a region is being picked or
#     recorded only shows a notification.
#   * A recording still running after MAX_SECONDS is cancelled and its file
#     deleted (no GIF).

set -euo pipefail

MAX_SECONDS=300

notify() { notify-send -t 5000 "Screen recording" "$1" || true; }

# Held while picking the region and recording. wl-screenrec inherits it, so
# it stays held as long as a recording runs, even if this script is killed.
exec 9>"${XDG_RUNTIME_DIR:-/tmp}/screen_record.lock"
if ! flock -n 9; then
  notify "Already recording: Super+Shift+Print stops it."
  exit 0
fi

filename=~/Videos/recording-$(date -u +"%Y-%m-%d.%H.%M.%S")
# Esc in slurp cancels the selection: nothing to record.
geometry=$(slurp) || exit 0

status=0
timeout --signal=INT --kill-after=10 "$MAX_SECONDS" \
  wl-screenrec -g "$geometry" -f "$filename.mp4" || status=$?
# The GIF conversion below must not block a new recording.
exec 9>&-

# 124: the time limit was hit; 137: wl-screenrec ignored SIGINT, was killed.
if [ "$status" -eq 124 ] || [ "$status" -eq 137 ]; then
  rm -f "$filename.mp4"
  notify "Still running after $((MAX_SECONDS / 60)) min: cancelled and deleted."
  exit 0
fi
[ "$status" -eq 0 ] || exit "$status"

gifski -o "$filename.gif" "$filename.mp4"
notify-send "Saved as $filename.gif"
