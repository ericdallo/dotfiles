{ pkgs, ... }:

{
  fonts.fonts = with pkgs;
    [
      roboto
      noto-fonts-emoji
    ];

  environment.systemPackages = with pkgs;
    [
      franz
      gimp
      gnomeExtensions.drop-down-terminal
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
