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
      feh
      font-manager
      gimp
      google-chrome
      gparted
      inkscape
      flameshot
      flat-remix-icon-theme
      libinput-gestures
      libnotify
      materia-theme
      networkmanager_dmenu
      ntfsprogs
      pantheon.elementary-files
      pavucontrol
      peek
      polybarFull
      postman
      playerctl
      pulsemixer
      rofi
      skype
      sxhkd
      udiskie
      udisks
      teamviewer
      transmission-gtk
      vlc
      (wine.override { wineBuild = "wineWow"; })
      woeusb
    ];

  environment.variables = {
    DOTFILES = "$HOME/.dotfiles";
  };

  environment.etc."libinput-gestures.conf".text = ''
    gesture swipe right 3 bspc desktop -f next.local
    gesture swipe left 3 bspc desktop -f prev.local
  '';

  services = {
    upower.enable = true;
    acpid.enable = true;

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

      xautolock = {
        enable = true;
        enableNotifier = true;
        locker = "${pkgs.betterlockscreen}/bin/betterlockscreen -s";
        notifier = ''${pkgs.libnotify}/bin/notify-send -c "lockscreen"  "Locking in 10 seconds"'';
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

  services.logind.extraConfig = ''
    HandleLidSwitch="hibernate"
  '';

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
