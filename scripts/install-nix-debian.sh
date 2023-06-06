#!/usr/bin/env bash

set -ve

echo "deb http://deb.debian.org/debian bullseye-backports main contrib non-free" >> /etc/apt/sources.list

sudo apt update
sudo apt install -y vim git build-essential dkms linux-headers-$(uname -r) bspwm bullseye-backports linux-image-amd64 libglfw3-dev libgles2-mesa-dev libgl1-mesa-dev xorg-dev
git clone https://github.com/ericdallo/dotfiles.git ~/.dotfiles

sudo mkdir /nix
sudo chown "$USERNAME" /nix
sh <(curl -L https://nixos.org/nix/install) --no-daemon
source "/home/$USERNAME/.nix-profiles/etc/profile.d/nix.sh"

echo "export NIX_PATH=$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels${NIX_PATH:+:$NIX_PATH}" >> ~/.bashrc
echo "export NIXPKGS_ALLOW_UNFREE=1" >> ~/.bashrc

nix-env -iA nixpkgs.home-manager

mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf

cd ~/.dotfiles/nix
home-manager switch --flake .

echo "export XDG_DATA_DIRS=$HOME/.nix-profile/share:$HOME/.share:\"${XDG_DATA_DIRS:-/usr/local/share/:/usr/share/}\"" >> ~/.profile
echo "export XDG_DATA_DIRS=$HOME/.nix-profile/share:$HOME/.share:\"${XDG_DATA_DIRS:-/usr/local/share/:/usr/share/}\"" >> ~/.zprofile

echo "if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then . $HOME/.nix-profile/etc/profile.d/nix.sh; fi" >> ~/.zprofile

echo "/home/greg/.nix-profile/bin/zsh" | sudo tee -a /etc/shells > /dev/null
sudo chsh -s /home/greg/.nix-profile/bin/zsh

# Natural scrolling
echo "xinput set-prop 13 324 1" >> ~/.profile
echo "xinput set-prop 13 324 1" >> ~/.zprofile
