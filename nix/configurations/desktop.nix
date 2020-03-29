{ pkgs, ... }:

let
  gnomeExtensions-hibernate-status = (import (fetchTarball https://github.com/ericdallo/nixpkgs/archive/gnome-extensions-hibernate-status.tar.gz) {}).gnomeExtensions.hibernate-status;
  gnomeExtensions-text-translator = (import (fetchTarball https://github.com/ericdallo/nixpkgs/archive/gnome-extensions-text-translator.tar.gz) { config.allowUnfree = true; }).gnomeExtensions.text-translator;
in {
  fonts.fonts = with pkgs;
    [
      roboto
      noto-fonts-emoji
    ];

  environment.systemPackages = with pkgs;
    [
      franz
      gimp
      # gnomeExtensions.draw-on-your-screen
      gnomeExtensions-hibernate-status
      gnomeExtensions.drop-down-terminal
      gnomeExtensions-text-translator
      gnome3.dconf-editor
      gnome3.gnome-tweaks
      google-chrome
      gparted
      i3lock-fancy
      inkscape
      flat-remix-icon-theme
      materia-theme
      ntfsprogs
      peek
      postman
      skype
      slack
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

  services.xserver.libinput.enable = true;
}
