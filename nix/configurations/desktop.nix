{ pkgs, ... }:

{
  fonts.fonts = with pkgs;
    [
      roboto
    ];

  environment.systemPackages = with pkgs;
    [
      conky
      franz
      gimp
      gnomeExtensions.drop-down-terminal
      gnome3.gnome-tweaks
      google-chrome
      gparted
      inkscape
      flat-remix-icon-theme
      materia-theme
      ntfsprogs
      postman
      skype
      slack
      teamviewer
      transmission-gtk
      vlc
      (wine.override { wineBuild = "wineWow"; })
      woeusb
      xorg.xmodmap
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
