{ config, pkgs, ... }:

let dotfilesDir = "$HOME/.dotfiles";
in {
  home.file.".env".source = ../../../.env;
  home.file.".functions".source = ../../../.functions;
  # home.file.".zshrc".source = ../../../.zshrc;
  home.file.".zsh_aliases".source = ../../../.zsh_aliases;
}
