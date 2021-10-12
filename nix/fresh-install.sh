#!/usr/bin/env bash

if [ -z "$1" ]; then
    echo "First arg must be the path of the host.nix file";
    exit 1
fi

if [ -z "$2" ]; then
    echo "Second arg must be 'personal' or 'nubank'";
    exit 1
fi

set -ve

# sudo ln -sf "$1" /etc/nixos/host.nix
# sudo ln -sf ~/.dotfiles/nix/flake.nix /etc/nixos/flake.nix
# sudo ln -sf ~/.dotfiles/nix/flake.lock /etc/nixos/flake.lock
# sudo ln -sf ~/.dotfiles/nix/configurations /etc/nixos/configurations
# sudo ln -sf ~/.dotfiles/nix/configuration.nix /etc/nixos/configuration.nix

echo "Links created successfully"
