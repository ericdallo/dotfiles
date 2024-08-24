{ config, lib, pkgs, ... }:

let
  dotfilesDir = "$HOME/.dotfiles";
in {
  nixpkgs.config.allowUnfree = true;

  imports = [
    ./programs/cli.nix
    ./programs/vim.nix
    ./programs/shell.nix
    ./programs/git.nix
    ./programs/network-manager.nix
    ./programs/tmux.nix
    ./programs/tmuxinator.nix
    ./programs/emacs.nix
  ];

  home = {
    stateVersion = "24.11";
    packages = with pkgs; [
      alda
      blender
      nodePackages.eask
      master.graalvm-ce
      heroku
      imagemagick
      kitty
      kdePackages.polkit-kde-agent-1
      maven
      mysql
      nodePackages.node2nix
      hugo
      discord
      pandoc
      # stable.postman
      stable.ferdium
      s3cmd
      sass
      sassc
      srt-to-vtt-cl
      teamviewer
      pulseaudioFull
      p7zip
      virtualbox
      websocat
      # master.dart
      flutter
      hover
      upx
      xdg-desktop-portal-hyprland
      hyprshot
    ];
    activation.linkFiles = config.lib.dag.entryAfter [ "writeBoundary" ] ''
      cp -n ${dotfilesDir}/.critical-keys.sample ~/.critical-keys

      ln -sf ${dotfilesDir}/.nubank_aliases ~/.nubank_aliases
      ln -sf ${dotfilesDir}/.nubank_extra ~/.extra

      ln -Tsf ${dotfilesDir}/.config/hypr ~/.config/hypr
      ln -Tsf ${dotfilesDir}/.config/waybar ~/.config/waybar
      ln -Tsf ${dotfilesDir}/.config/kitty ~/.config/kitty
      ln -Tsf ${dotfilesDir}/.config/kanshi ~/.config/kanshi
      ln -Tsf ${dotfilesDir}/.config/rofi ~/.config/rofi
      ln -Tsf ${dotfilesDir}/.config/dunst ~/.config/dunst
      ln -Tsf ${dotfilesDir}/.config/nvim ~/.config/nvim
      ln -Tsf ${dotfilesDir}/.config/clojure ~/.config/clojure
      ln -Tsf ${dotfilesDir}/.config/gdfuse ~/.config/gdfuse
      ln -Tsf ${dotfilesDir}/.config/networkmanager-dmenu ~/.config/networkmanager-dmenu
      mkdir -p ~/.config/clojure-lsp
      ln -sf ${dotfilesDir}/.config/clojure-lsp/config.edn ~/.config/clojure-lsp/config.edn

      ln -Tsf ${dotfilesDir}/.config/doom ~/.config/doom

      ln -sf ${dotfilesDir}/.config/Code/User/keybindings.json ~/.config/Code/User/keybindings.json
      ln -sf ${dotfilesDir}/.config/Code/User/settings.json ~/.config/Code/User/settings.json
    '';
  };
}
