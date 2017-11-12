#!/bin/bash

set -ve

ln -sf ~/git/dotfiles/tmux/.tmux.conf ~/.tmux.conf
ln -sf ~/git/dotfiles/tmux/.tmuxinator ~/.tmuxinator
ln -sf ~/git/dotfiles/vim/.vimrc ~/.vimrc
ln -sf ~/git/dotfiles/alias/.zsh_aliases ~/.zsh_aliases
ln -sf ~/git/dotfiles/alias/.zshrc ~/.zshrc
ln -sf ~/git/dotfiles/git/.gitconfig ~/.gitconfig

echo "Links updated"
