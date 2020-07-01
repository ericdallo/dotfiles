#!/usr/bin/env bash

nixos-rebuild build-vm \
    -I nixpkgs=./. \
    -I nixos-config=$DOTFILES/nix/scripts/gnome-dev/vm.nix

QEMU_NET_OPTS="hostfwd=tcp::2222-:22" ./result/bin/run-*-vm -m 2500
