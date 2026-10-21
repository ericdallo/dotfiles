{ lib, pkgs, ... }:

{
  nixpkgs.config.allowBroken = true;

  environment.systemPackages = with pkgs;
    [
      betterlockscreen
      # master.code-cursor
      dmenu
      dunst
      # font-manager
      gimp
      google-chrome
      gparted
      hypridle
      hyprlock
      inkscape
      (flameshot.override { enableWlrSupport = true; })
      libinput-gestures
      libnotify
      libcanberra-gtk3
      materia-theme
      nautilus
      ntfsprogs
      pavucontrol
      peek
      waybar
      playerctl
      pulsemixer
      rofi
      kanshi
      stable.slurp
      sound-theme-freedesktop
      swaybg
      udiskie
      udisks
      transmission_4-gtk
      vlc
      woeusb
      stable.wf-recorder
      sweethome3d.application
      wl-screenrec
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
    portalPackage = pkgs.xdg-desktop-portal-hyprland;
    xwayland.enable = true;
  };

  # hyprlock (the lock screen, .config/hypr/hyprlock.conf) checks the
  # password through PAM, so it needs its own PAM service. Not
  # `programs.hyprlock.enable`: that also turns on hypridle's user unit,
  # which waits for graphical-session.target, and here that target is
  # pulled in at login by sunshine (sunshine.nix) before Hyprland exports
  # WAYLAND_DISPLAY. The unit's ConditionEnvironment=WAYLAND_DISPLAY then
  # skips it, so hypridle would never run. hyprland.conf starts it
  # (exec-once) instead.
  #
  # No pam_fprintd (which fprintd.enable, hardware.nix, would add first): on
  # a host with a reader it blocks the password until the finger scan times
  # out. hyprlock reads fingerprints itself (auth:fingerprint in
  # hyprlock.conf), alongside the password, as its upstream advises.
  security.pam.services.hyprlock.fprintAuth = false;

  # Per-host Hyprland overrides (e.g. the built-in panel's mode and scale),
  # sourced last by .config/hypr/hyprland.conf, so its rules win. Hosts set
  # this text; Hyprland errors out on a missing source file, hence the default.
  environment.etc."hypr/host.conf".text = lib.mkDefault ''
    # No per-host Hyprland overrides on this host.
  '';

  services = {
    upower.enable = true;
    acpid.enable = true;
    gnome.gnome-keyring.enable = true;

    libinput.enable = true;
    libinput.touchpad.naturalScrolling = true;
    displayManager.defaultSession = "hyprland";

    # GDM 50 (current nixpkgs) is broken on this machine: its greeter never
    # spawns gnome-shell — the journal shows
    #   gdm-wayland-session: Unable to run session
    #   GdmDisplay: Session never registered, failing  (x6, then "Giving up")
    # so the login screen is just a black screen. The i915 GPU stack is fine;
    # it's a GDM/GNOME-50 regression.
    #
    # Use SDDM instead: a graphical login with a session chooser. It launches
    # each session via its .desktop entry, so Hyprland starts through
    # `start-hyprland` (clearing the "launched without start-hyprland"
    # warning) and GNOME is selectable too. Switch back to GDM once upstream
    # fixes its greeter.
    # displayManager.gdm.enable = true;
    displayManager.sddm.enable = true;

    # Offer GNOME as a selectable session next to Hyprland. This only
    # registers the GNOME sessions in the chooser; it does NOT pull in GDM.
    desktopManager.gnome.enable = true;
    # GNOME defaults to power-profiles-daemon, which conflicts with the
    # auto-cpufreq configured on this host. Keep auto-cpufreq; disable ppd.
    power-profiles-daemon.enable = false;

    xserver = {
      enable = true;
      xkb = {
        layout = "us,br";
        variant = "intl,abnt2";
      };

      videoDrivers = [ "modesetting" ];
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

    # logind.extraConfig = ''
    #   HandlePowerKey=suspend-then-hibernate
    # '';
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
