{ pkgs, ... }:

{
  nixpkgs.config.allowBroken = true;

  environment.systemPackages = with pkgs;
    [
      betterlockscreen
      bspwm
      dmenu
      dunst
      feh
      font-manager
      gimp
      google-chrome
      gparted
      inkscape
      flameshot
      libinput-gestures
      libnotify
      materia-theme
      gnome3.nautilus
      ntfsprogs
      pavucontrol
      peek
      polybarFull
      playerctl
      pulsemixer
      rofi
      sxhkd
      udiskie
      udisks
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
    gnome.gnome-keyring.enable = true;

    xserver = {
      enable = true;
      layout = "us,br";
      xkbVariant = "intl,abnt2";

      videoDrivers = [ "intel" ];

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
                cursor-theme-name = "Adwaita"
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
        notifier = ''${pkgs.libnotify}/bin/notify-send -c "lockscreen"  "Locking in 5 seconds"'';
        extraOptions = [ "-corners +00-" ];
      };

      # desktopManager.xterm.enable = false;
      # displayManager.startx.enable = true;

      libinput.enable = true;
      libinput.touchpad.naturalScrolling = true;

      windowManager.bspwm = {
        enable = true;
      };
    };

    logind.extraConfig = ''
      HandlePowerKey=suspend-then-hibernate
    '';
  };

  fonts = {
    fonts = with pkgs; [
      emacs-all-the-icons-fonts
      hack-font
      roboto
      roboto-mono
      master.material-design-icons
      ibm-plex
    ];
  };

}
