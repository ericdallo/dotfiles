{ pkgs, ... }:

let
  gnomeExtensions-text-translator = (import (fetchTarball https://github.com/ericdallo/nixpkgs/archive/gnome-extensions-text-translator.tar.gz) { config.allowUnfree = true; }).gnomeExtensions.text-translator;
in {
  nixpkgs.config.allowBroken = true;

  environment.systemPackages = with pkgs;
    [
      franz
      gimp
      gnomeExtensions.draw-on-your-screen
      gnomeExtensions.system-monitor
      gnomeExtensions-text-translator
      gnome3.dconf-editor
      google-chrome
      gparted
      inkscape
      flat-remix-icon-theme
      materia-theme
      ntfsprogs
      peek
      polybar
      postman
      # skype
      # slack
      teamviewer
      transmission-gtk
      vlc
      (wine.override { wineBuild = "wineWow"; })
      woeusb
    ];

  services.xserver.enable = true;
  services.xserver.desktopManager = {
    gnome3.enable = true;
    gnome3.extraGSettingsOverrides = ''
      [org.gnome.shell.app-switcher]
      current-workspace-only=true
    '';
  };

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = false;
  services.xserver.displayManager.sessionCommands = ''
    ${pkgs.xorg.xset}/bin/xset r rate 220 50 # not working for some reason
  '';

  services.xserver.libinput.enable = true;
}
