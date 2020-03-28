#!/bin/bash

set -ve

DOTFILES_DIR=$HOME/.dotfiles

ln -sf $DOTFILES_DIR/tmux/.tmux.conf ~/.tmux.conf
ln -Tsf $DOTFILES_DIR/tmux/.tmuxinator ~/.tmuxinator

ln -sf $DOTFILES_DIR/vim/.vimrc ~/.vimrc

ln -sf $DOTFILES_DIR/basic/.zsh_aliases ~/.zsh_aliases
ln -sf $DOTFILES_DIR/basic/.zshrc ~/.zshrc
ln -sf $DOTFILES_DIR/basic/.functions ~/.functions

ln -sf $DOTFILES_DIR/git/.gitconfig ~/.gitconfig
ln -sf $DOTFILES_DIR/vscode/keybindings.json ~/.config/Code/User/keybindings.json
ln -sf $DOTFILES_DIR/vscode/settings.json ~/.config/Code/User/settings.json

ln -Tsf $DOTFILES_DIR/emacs/.doom.d ~/.doom.d
ln -sf $DOTFILES_DIR/emacs/.joker ~/.joker
ln -Tsf $DOTFILES_DIR/emacs/.jokerd ~/.jokerd
ln -Tsf $DOTFILES_DIR/emacs/.clj-kondo ~/.clj-kondo
ln -Tsf $DOTFILES_DIR/emacs/.lsp ~/.lsp

ln -sf $DOTFILES_DIR/gregflix/.s3cfg ~/.s3cfg
ln -sf $DOTFILES_DIR/gregflix/.tmdb-functions ~/.tmdb-functions
ln -sf $DOTFILES_DIR/gregflix/.gregflix-functions ~/.gregflix-functions

ln -sf $DOTFILES_DIR/urxvt/.Xresources ~/.Xresources

echo "Links updated"
