#!/usr/bin/env bash

sudo apt install vim git build-essential dkms linux-headers-$(uname -r) bspwm
git clone https://github.com/ericdallo/dotfiles.git ~/.dotfiles

sudo mkdir /nix
sudo chown "$USERNAME" /nix
sh <(curl -L https://nixos.org/nix/install) --no-daemon
./home/"$USERNAME"/.nix-profiles/etc/profile.d/nix.sh

echo "export NIX_PATH=$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels${NIX_PATH:+:$NIX_PATH}" >> ~/.bashrc
nix-env -iA nixpkgs.home-manager

mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf

cd ~/.dotfiles
home-manager switch --flake .

echo "export XDG_DATA_DIRS=$HOME/.nix-profile/share:$HOME/.share:\"${XDG_DATA_DIRS:-/usr/local/share/:/usr/share/}\"" >> ~/.profile
echo "export XDG_DATA_DIRS=$HOME/.nix-profile/share:$HOME/.share:\"${XDG_DATA_DIRS:-/usr/local/share/:/usr/share/}\"" >> ~/.zprofile

echo "if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then . $HOME/.nix-profile/etc/profile.d/nix.sh; fi" >> ~/.zprofile

sudo echo "/home/greg/.nix-profile/bin/zsh" >> /etc/shells
sudo chsh -s /home/greg/.nix-profile/bin/zsh
