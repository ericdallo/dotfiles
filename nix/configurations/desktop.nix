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
      nautilus
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
      transmission_4-gtk
      vlc
      woeusb
      adwaita-icon-theme
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

    libinput.enable = true;
    libinput.touchpad.naturalScrolling = true;
    displayManager.defaultSession = "none+bspwm";

    xserver = {
      enable = true;
      xkb = {
        layout = "us,br";
        variant = "intl,abnt2";
      };

      videoDrivers = [ "intel" ];

      modules = [ pkgs.xorg.xf86inputlibinput ];

      displayManager.sessionCommands = ''
        ${pkgs.xorg.xsetroot}/bin/xsetroot -cursor_name left_ptr &
        ${pkgs.xorg.xrdb}/bin/xrdb -merge <<EOF
          Xcursor.theme: Adwaita
          Xcursor.size: 24
        EOF
      '';
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
                cursor-theme-name = "Adwaita"
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
        notify = 40;
        notifier = ''${pkgs.libnotify}/bin/notify-send -c "lockscreen"  "Locking in 40 seconds"'';
        extraOptions = [ "-corners +00-" ];
      };

      # desktopManager.xterm.enable = false;
      # displayManager.startx.enable = true;

      windowManager.bspwm = {
        enable = true;
      };
    };

    logind.extraConfig = ''
      HandlePowerKey=suspend-then-hibernate
    '';
  };

  fonts = {
    packages = with pkgs; [
      emacs-all-the-icons-fonts
      hack-font
      roboto
      roboto-mono
      master.material-design-icons
      ibm-plex
    ];
  };

}
