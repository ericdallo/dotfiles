{ pkgs, ... }:

{
  nixpkgs.config.allowBroken = true;

  environment.systemPackages = with pkgs;
    [
      betterlockscreen
      dmenu
      dunst
      font-manager
      gimp
      stable.google-chrome
      gparted
      inkscape
      (flameshot.override { enableWlrSupport = true; })
      libinput-gestures
      libnotify
      materia-theme
      nautilus
      ntfsprogs
      pavucontrol
      peek
      waybar
      playerctl
      pulsemixer
      rofi-wayland
      kanshi
      slurp
      swaybg
      udiskie
      udisks
      transmission_4-gtk
      vlc
      woeusb
      wf-recorder
      adwaita-icon-theme
    ];

  environment.variables = {
    DOTFILES = "$HOME/.dotfiles";
  };

  environment.etc."libinput-gestures.conf".text = ''
    gesture swipe right 3 bspc desktop -f next.local
    gesture swipe left 3 bspc desktop -f prev.local
  '';

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  services = {
    upower.enable = true;
    acpid.enable = true;
    gnome.gnome-keyring.enable = true;

    libinput.enable = true;
    libinput.touchpad.naturalScrolling = true;
    displayManager.defaultSession = "hyprland";

    xserver = {
      enable = true;
      xkb = {
        layout = "us,br";
        variant = "intl,abnt2";
      };

      videoDrivers = [ "intel" ];

      modules = [ pkgs.xorg.xf86inputlibinput ];

      displayManager.gdm.enable = true;
      displayManager.gdm.wayland = true;
      # desktopManager.gnome.enable = true;
      desktopManager.xterm.enable = false;
      #displayManager.startx.enable = true;

      #displayManager.lightdm = {
      #  enable = true;
      #  greeters.mini = {
      #    enable = true;
      #    user = "greg";
      #    extraConfig = ''
      #          [greeter]
      #          show-password-label = false
      #          show-input-cursor = true
      #          invalid-password-text = "You shall not pass!"
      #          password-alignment = left
      #          cursor-theme-name = "Adwaita"
      #          [greeter-theme]
      #          background-image = ""
      #          background-color = "#282a36"
      #          window-color = "#bd93f9"
      #          border-color = "#bd93f9"
      #          layout-space = 16
      #          font-size = 1.1em
      #          password-background-color = "#44475a"
      #          password-border-width = 4px
      #          password-border-color = "#44475a"
      #      '';
      #  };
      #};

      #xautolock = {
      #  enable = true;
      #  enableNotifier = true;
      #  locker = "${pkgs.betterlockscreen}/bin/betterlockscreen -s";
      #  notify = 40;
      #  notifier = ''${pkgs.libnotify}/bin/notify-send -c "lockscreen"  "Locking in 40 seconds"'';
      #  extraOptions = [ "-corners +00-" ];
      #};
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
