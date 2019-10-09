{ pkgs, ... }:

{
  environment.systemPackages = with pkgs;
    [
      franz
      gimp
      # gnomeExtensions.battery-status #broken
      gnomeExtensions.drop-down-terminal
      gnome3.gnome-tweaks
      google-chrome
      gparted
      inkscape
      postman
      skype
      slack
      teamviewer
      transmission-gtk
      vlc
      woeusb
    ];

  services.xserver.enable = true;
  services.xserver.desktopManager = {
    gnome3.enable = true;
  };
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = false;

  services.xserver.libinput.enable = true;
}
