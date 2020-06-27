{ pkgs, ... }:

let
    material-design-icons = (import (fetchTarball https://github.com/ericdallo/nixpkgs/archive/bump-material-design-icons.tar.gz) {}).material-design-icons;
in {
  nixpkgs.config.allowBroken = true;

  environment.systemPackages = with pkgs;
    [
      betterlockscreen
      bspwm
      dmenu
      dunst
      franz
      font-manager
      gimp
      google-chrome
      gparted
      inkscape
      flameshot
      flat-remix-icon-theme
      libnotify
      materia-theme
      gnome3.nautilus
      networkmanager_dmenu
      ntfsprogs
      peek
      polybarFull
      postman
      playerctl
      pulsemixer
      rofi
      # skype
      # slack
      sxhkd
      teamviewer
      transmission-gtk
      vlc
      (wine.override { wineBuild = "wineWow"; })
      woeusb
    ];

  services = {
    upower.enable = true;

    xserver = {
      enable = true;
      layout = "us,br";
      xkbVariant = "intl,abnt2";

      modules = [ pkgs.xorg.xf86inputlibinput ];

      displayManager.defaultSession = "none+bspwm";
      displayManager.gdm = {
        enable = true;
      };

      # desktopManager.xterm.enable = false;
      # displayManager.startx.enable = true;

      libinput.enable = true;
      libinput.naturalScrolling = true;

      windowManager.bspwm = {
        enable = true;
      };
    };
  };

  programs.ssh.startAgent = true;

  fonts = {
    fonts = with pkgs; [
      emacs-all-the-icons-fonts
      hack-font
      roboto
      material-design-icons
      ibm-plex
    ];
  };

}
