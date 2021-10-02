{ pkgs, ... }:

{
  networking = {

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
    noisetorch
  ];

  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };

  # Configure special hardware in laptops.
  hardware = {
    enableRedistributableFirmware = true;

    bluetooth = {
      enable = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
          MultiProfile = "multiple";
        };
      };
    };

    # pulseaudio = {
    #   enable = true;
    #   package = pkgs.pulseaudioFull;
    #   support32Bit = true;

    #   # Enable extra bluetooth codecs.
    #   extraModules = [ pkgs.pulseaudio-modules-bt ];
    #   extraConfig = "
    #     load-module module-switch-on-connect
    #   ";
    # };

    # Extra OpenGL options.
    opengl = {
      enable = true;
      extraPackages = with pkgs; [
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

  services = {
    # Trim SSD weekly.
    fstrim = {
      enable = true;
      interval = "weekly";
    };

    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      # Bluetooth settings
      media-session.config.bluez-monitor.rules = [
        {
          # Matches all cards
          matches = [ { "device.name" = "~bluez_card.*"; } ];
          actions = {
            "update-props" = {
              "bluez5.reconnect-profiles" = [ "hfp_hf" "hsp_hs" "a2dp_sink" ];
              # mSBC is not expected to work on all headset + adapter combinations.
              "bluez5.msbc-support" = true;
              # "bluez5.sbc-xq-support" = true;
            };
          };
        }
        {
          matches = [
            # Matches all sources
            { "node.name" = "~bluez_input.*"; }
            # Matches all outputs
            { "node.name" = "~bluez_output.*"; }
          ];
          actions = {
            "node.pause-on-idle" = false;
          };
        }
      ];
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
