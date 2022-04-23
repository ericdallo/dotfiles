#!/usr/bin/env bash

sudo apt install vim git build-essential dkms linux-headers-$(uname -r)
git clone https://github.com/ericdallo/dotfiles.git ~/.dotfiles

sudo mkdir /nix
sudo chown "$USERNAME" /nix
sh <(curl -L https://nixos.org/nix/install) --no-daemon
./home/"$USERNAME"/.nix-profiles/etc/profile.d/nix.sh

echo "export NIX_PATH=$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels${NIX_PATH:+:$NIX_PATH}" >> ~/.bashrc
nix-env -iA nixpkgs.home-manager

mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf
