{ pkgs, config, self, ... }:
let
  dotfilesDir = "$HOME/.dotfiles";
  username = "greg";
in
{
  imports = [
    ../configurations/overlays.nix
    ./programs/common.nix
    ./programs/vscode.nix
    ./programs/clojure.nix
    ./programs/python.nix
    ./programs/android.nix
    ./programs/java.nix
    ./programs/zsh.nix
  ];

  nixpkgs.overlays = [
    (import self.inputs.nubank)
  ];

  fonts.fontconfig.enable = true;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.android_sdk.accept_license = true;


  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "22.11";
    sessionVariables = {
      DOTFILES = "$HOME/.dotfiles";
    };
    packages = with pkgs; [
      # from desktop.nix
      # bspwm
      # xsecurelock
      dmenu
      dunst
      feh
      font-manager
      gimp
      master.google-chrome
      gparted
      inkscape
      # master.flameshot # use it from apt, issues with ctrl+c when used with debian
      libinput-gestures
      libnotify
      materia-theme
      # gnome3.nautilus
      ntfsprogs
      pavucontrol
      stable.peek
      polybarFull
      playerctl
      pulsemixer
      rofi
      sxhkd
      udiskie
      udisks
      transmission-gtk
      vlc
      woeusb
      scala
      scalafmt
      # gnome3.adwaita-icon-theme
      emacs-all-the-icons-fonts
      hack-font
      roboto
      roboto-mono
      master.material-design-icons
      ibm-plex

      aws-iam-authenticator
      bspwm
      awslogs
      stable.discord
      fzf
      # gcc
      git-lfs
      # hashdeep
      stable.kubectl
      master.ferdium
      mob
      maven
      sassc
      stable.yubikey-manager
      stable.yubikey-personalization-gui
      scrot
      imagemagick
      visualvm
      tektoncd-cli
      plantuml
      stable.protobuf
      stable.buf
      xsv
      # zoom-us
      insomnia
      # nubank.dart
      (nubank.flutter.override { flutterPackages = stable.flutterPackages; })
      # nubank.hover
    ] ++ nubank.jupyter-tools;

    activation.linkFiles = config.lib.dag.entryAfter [ "writeBoundary" ] ''
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
      ln -Tsf ${dotfilesDir}/.config/networkmanager-dmenu ~/.config/networkmanager-dmenu
      ln -sf ${dotfilesDir}/.config/zoomus.conf ~/.config/zoomus.conf
      mkdir -p ~/.config/clojure-lsp
      ln -sf ${dotfilesDir}/.config/clojure-lsp/config.edn ~/.config/clojure-lsp/config.edn

      ln -Tsf ${dotfilesDir}/.doom.d ~/.doom.d
      ln -sf ${dotfilesDir}/.midje.clj ~/.midje.clj
    '';
  };
}
