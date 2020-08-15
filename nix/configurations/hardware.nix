{ pkgs, ... }:

{
  networking = {

    networkmanager = {
      enable = true;
      dhcp = "internal";
      dns = "dnsmasq";
    };

    firewall.allowedTCPPorts = [8080];
  };

  environment.systemPackages = with pkgs; [
    iw
    noisetorch
  ];

  # Configure special hardware in laptops.
  hardware = {
    enableRedistributableFirmware = true;

    bluetooth = {
      enable = true;
      config = {
        General = {
          Enable = "Source,Sink,Media,Socket";
          MultiProfile = "multiple";
        };
      };
    };

    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
      support32Bit = true;

      # Enable extra bluetooth codecs.
      extraModules = [ pkgs.pulseaudio-modules-bt ];
      extraConfig = "
        load-module module-switch-on-connect
      ";
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

    blueman = {
      enable = true;
    };

    # Lock screen when lid is closed.
    logind.lidSwitch = "lock";

    # Enable TLP to reduce power consumption.
    tlp = {
      enable = true;
      settings = {
        DEVICES_TO_DISABLE_ON_LAN_CONNECT = "wifi wwan";
        DEVICES_TO_DISABLE_ON_WIFI_CONNECT = "wwan";
        DEVICES_TO_DISABLE_ON_WWAN_CONNECT = "wifi";
        DEVICES_TO_ENABLE_ON_LAN_DISCONNECT = "wifi wwan";
        DEVICES_TO_ENABLE_ON_WIFI_DISCONNECT = "";
        DEVICES_TO_ENABLE_ON_WWAN_DISCONNECT = "";
      };
    };
  };
}
