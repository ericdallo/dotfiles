{ pkgs, ... }:

{
  zramSwap.enable = true;
  zramSwap.memoryPercent = 100;

  networking = {

    extraHosts = ''
      172.17.0.1 mysql
      172.17.0.1 datomic
    '';

    nameservers = [ "8.8.8.8" "8.8.4.4" ];

    networkmanager = {
      enable = true;
      dhcp = "internal";
      dns = "dnsmasq";
    };

    firewall.allowedTCPPorts = [8080];
    firewall.allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
  };

  environment.systemPackages = with pkgs; [
    iw
  ];

  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };

  hardware = {
    enableRedistributableFirmware = true;

    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
          MultiProfile = "multiple";
        };
      };
    };

    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        intel-compute-runtime
        intel-media-driver
        libvdpau-va-gl
        vaapiIntel
        vaapiVdpau
      ];
    };
  };

  programs = {
    # Enable NetworkManager applet.
    nm-applet.enable = true;
  };
  security.polkit.enable = true;
  security.rtkit.enable = true;
  #security.pam.services.login.fprintAuth = true;
  #security.pam.services.xscreensaver.fprintAuth = true;

  services = {
    # Trim SSD weekly.
    fstrim = {
      enable = true;
      interval = "weekly";
    };

    fprintd.enable = true;

    pulseaudio = {
      enable = false;
      # package = pkgs.pulseaudioFull;
      # support32Bit = true;

      # # Enable extra bluetooth codecs.
      # # extraModules = [ pkgs.pulseaudio-modules-bt ];
      # extraConfig = "
      #   load-module module-switch-on-connect
      # ";
    };

    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      # Bluetooth settings
      wireplumber.enable = true;
    };

    blueman = {
      enable = true;
    };

    udisks2.enable = true;

    # Lock screen when lid is closed.
    logind.settings.Login.HandleLidSwitch = "lock";
  };
}
