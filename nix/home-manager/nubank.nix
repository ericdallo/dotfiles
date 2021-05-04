{ pkgs, config, ... }:
let
  dotfilesDir = "$HOME/.dotfiles";
in {
  imports = [
    ./common/programs.nix
    ./common/tmux.nix
  ];

  nixpkgs.config.allowUnfree = true;

  home = {
    packages = with pkgs; [
      discord
      fzf
      gcc
      git-lfs
      hashdeep
      kubectl
      mob
      yubikey-manager
      yubikey-personalization-gui
      xsv
      zoom-us
      insomnia
    ];

    activation.linkFiles = config.lib.dag.entryAfter ["writeBoundary"] ''
        cp -n ${dotfilesDir}/.critical-keys.sample ~/.critical-keys
        ln -Tsf ${dotfilesDir}/.env ~/.env
        ln -sf ${dotfilesDir}/.zsh_aliases ~/.zsh_aliases
        ln -sf ${dotfilesDir}/.nubank_aliases ~/.nubank_aliases
        ln -sf ${dotfilesDir}/.zshrc ~/.zshrc
        ln -sf ${dotfilesDir}/.nubank_extra ~/.extra
        ln -sf ${dotfilesDir}/.functions ~/.functions

        ln -Tsf ${dotfilesDir}/.config/bspwm ~/.config/bspwm
        ln -Tsf ${dotfilesDir}/.config/sxhkd ~/.config/sxhkd
        ln -Tsf ${dotfilesDir}/.config/rofi ~/.config/rofi
        ln -Tsf ${dotfilesDir}/.config/polybar ~/.config/polybar
        ln -Tsf ${dotfilesDir}/.config/dunst ~/.config/dunst
        ln -Tsf ${dotfilesDir}/.config/networkmanager-dmenu ~/.config/networkmanager-dmenu
        ln -Tsf ${dotfilesDir}/.config/libinput-gestures.conf ~/.config/libinput-gestures.conf
        ln -Tsf ${dotfilesDir}/.config/gdfuse ~/.config/gdfuse

        ln -Tsf ${dotfilesDir}/.doom.d ~/.doom.d
        ln -Tsf ${dotfilesDir}/.lsp ~/.lsp
        ln -Tsf ${dotfilesDir}/.clj-kondo ~/.clj-kondo
        ln -sf ${dotfilesDir}/.midje.clj ~/.midje.clj

        ln -sf ${dotfilesDir}/.gitconfig ~/.gitconfig
        ln -sf ${dotfilesDir}/.gitignore_global ~/.gitignore_global

        ln -Tsf ${dotfilesDir}/.tmuxinator ~/.tmuxinator

        ln -sf ${dotfilesDir}/.vimrc ~/.vimrc

        ln -sf ${dotfilesDir}/.Xresources ~/.Xresources
    '';
  };
}
