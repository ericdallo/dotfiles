#!/usr/bin/env bash

HOVER_COMMAND="$HOME/gocode/bin/hover $@"

nix-shell $DOTFILES/nix/scripts/hover.nix --run "$HOVER_COMMAND"
