#!/usr/bin/env bash

HOVER_COMMAND="$HOME/gocode/bin/hover $@"

nix-shell $DOTFILES_DIR/nix/scripts/hover.nix --run "$HOVER_COMMAND"
