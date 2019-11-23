{ pkgs, ... }:

{
  networking = {

    networkmanager = {
      enable = true;
      dhcp = "internal";
      dns = "dnsmasq";
    };
  };

  environment.systemPackages = with pkgs; [
    blueman
    iw
  ];

  # Configure special hardware in laptops.
  hardware = {
    enableRedistributableFirmware = true;

    # Enable bluetooth.
    bluetooth.enable = true;

    pulseaudio = {
      package = pkgs.pulseaudioFull;
      # Enable extra bluetooth codecs.
      extraModules = [ pkgs.pulseaudio-modules-bt ];
    };

    # Extra OpenGL options.
    opengl = {
      extraPackages = with pkgs; [
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

  services = {
    # Trim SSD weekly.
    fstrim = {
      enable = true;
      interval = "weekly";
    };

    # Lock screen when lid is closed.
    logind.lidSwitch = "lock";

    # Enable TLP to reduce power consumption.
    tlp = {
      enable = true;
      extraConfig = ''
        # Radio devices to disable on connect.
        DEVICES_TO_DISABLE_ON_LAN_CONNECT="wifi wwan"
        DEVICES_TO_DISABLE_ON_WIFI_CONNECT="wwan"
        DEVICES_TO_DISABLE_ON_WWAN_CONNECT="wifi"
        # Radio devices to enable on disconnect.
        DEVICES_TO_ENABLE_ON_LAN_DISCONNECT="wifi wwan"
        DEVICES_TO_ENABLE_ON_WIFI_DISCONNECT=""
        DEVICES_TO_ENABLE_ON_WWAN_DISCONNECT=""
      '';
    };
  };
}
