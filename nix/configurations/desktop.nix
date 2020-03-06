{ pkgs, ... }:

let
  gnomeExtensions-hibernate-status = (import (fetchTarball https://github.com/ericdallo/nixpkgs/archive/gnome-extensions-hibernate-status.tar.gz) {}).gnomeExtensions.hibernate-status;
  gnomeExtensions-draw-on-your-screen = (import (fetchTarball https://github.com/ericdallo/nixpkgs/archive/gnome-extensions-drawn-on-your-screen.tar.gz) {}).gnomeExtensions.draw-on-your-screen;

  odrive = (import (fetchTarball https://github.com/ericdallo/nixpkgs/archive/odrive-init.tar.gz) {}).odrive;
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
      gnomeExtensions-hibernate-status
      gnomeExtensions-draw-on-your-screen
      gnomeExtensions.sound-output-device-chooser
      gnome3.dconf-editor
      gnome3.gnome-tweaks
      google-chrome
      gparted
      i3lock-fancy
      inkscape
      flat-remix-icon-theme
      materia-theme
      ntfsprogs
      odrive
      peek
      postman
      rambox
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
