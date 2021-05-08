{ pkgs, config, ... }:
let
  dotfilesDir = "$HOME/.dotfiles";
in {
  imports = [
    ./programs/common.nix
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
        ln -sf ${dotfilesDir}/.nubank_aliases ~/.nubank_aliases
        ln -sf ${dotfilesDir}/.nubank_extra ~/.extra

        ln -Tsf ${dotfilesDir}/.config/bspwm ~/.config/bspwm
        ln -Tsf ${dotfilesDir}/.config/sxhkd ~/.config/sxhkd
        ln -Tsf ${dotfilesDir}/.config/rofi ~/.config/rofi
        ln -Tsf ${dotfilesDir}/.config/polybar ~/.config/polybar
        ln -Tsf ${dotfilesDir}/.config/dunst ~/.config/dunst
        ln -Tsf ${dotfilesDir}/.config/libinput-gestures.conf ~/.config/libinput-gestures.conf
        ln -Tsf ${dotfilesDir}/.config/gdfuse ~/.config/gdfuse

        ln -Tsf ${dotfilesDir}/.doom.d ~/.doom.d
        ln -Tsf ${dotfilesDir}/.lsp ~/.lsp
        ln -Tsf ${dotfilesDir}/.clj-kondo ~/.clj-kondo
        ln -sf ${dotfilesDir}/.midje.clj ~/.midje.clj

        ln -sf ${dotfilesDir}/.vimrc ~/.vimrc
    '';
  };
}
