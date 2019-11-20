#!/bin/bash

set -ve

DOTFILES_DIR=~/dev/dotfiles

ln -sf $DOTFILES_DIR/tmux/.tmux.conf ~/.tmux.conf
ln -sf $DOTFILES_DIR/tmux/.tmuxinator ~/.tmuxinator
ln -sf $DOTFILES_DIR/vim/.vimrc ~/.vimrc
ln -sf $DOTFILES_DIR/basic/.zsh_aliases ~/.zsh_aliases
ln -sf $DOTFILES_DIR/basic/.zshrc ~/.zshrc
ln -sf $DOTFILES_DIR/git/.gitconfig ~/.gitconfig
ln -sf $DOTFILES_DIR/basic/.functions ~/.functions
ln -sf $DOTFILES_DIR/vscode/keybindings.json ~/.config/Code/User/keybindings.json
ln -sf $DOTFILES_DIR/vscode/settings.json ~/.config/Code/User/settings.json
ln -sf $DOTFILES_DIR/emacs/.doom.d ~/.doom.d

ln -sf $DOTFILES_DIR/gregflix/.gregflix-functions ~/.gregflix-functions
ln -sf $DOTFILES_DIR/gregflix/.tmdb-functions ~/.tmdb-functions

ln -sf $DOTFILES_DIR/nix/configuration.nix /etc/nixos/configuration.nix
ln -sf $DOTFILES_DIR/nix/config-imports /etc/nixos/config-imports

echo "Links updated"
