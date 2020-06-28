{ pkgs, ... }:

let
    material-design-icons = (import (fetchTarball https://github.com/NixOS/nixpkgs/archive/master.tar.gz) {}).material-design-icons;
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
      pavucontrol
      peek
      polybarFull
      postman
      playerctl
      pulsemixer
      rofi
      skype
      sxhkd
      teamviewer
      transmission-gtk
      vlc
      (wine.override { wineBuild = "wineWow"; })
      woeusb
    ];

  environment.variables = {
    DOTFILES = "$HOME/.dotfiles";
  };

  services = {
    upower.enable = true;

    xserver = {
      enable = true;
      layout = "us,br";
      xkbVariant = "intl,abnt2";

      modules = [ pkgs.xorg.xf86inputlibinput ];

      displayManager.defaultSession = "none+bspwm";
      displayManager.lightdm = {
        enable = true;
        greeters.mini = {
            enable = true;
            user = "greg";
            extraConfig = ''
                [greeter]
                show-password-label = false
                show-input-cursor = true
                invalid-password-text = "You shall not pass!"
                password-alignment = left
                [greeter-theme]
                background-image = ""
                background-color = "#282a36"
                window-color = "#bd93f9"
                border-color = "#bd93f9"
                layout-space = 16
                font-size = 1.1em
                password-background-color = "#44475a"
                password-border-width = 4px
                password-border-color = "#44475a"
            '';
        };
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

  services.logind.extraConfig = "HandleLidSwitch=hybrid-sleep";

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
