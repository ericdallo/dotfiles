#!/usr/bin/env bash

current=$(hyprctl activeworkspace -j | jq '.id')

hyprctl dispatch workspace 5
hyprctl dispatch sendshortcut 'CTRL_SHIFT, M, class:^(vesktop|Vesktop)$'
hyprctl dispatch workspace $current
