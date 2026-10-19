{ pkgs, config, ... }:

{
  zramSwap.enable = true;
  zramSwap.memoryPercent = 50;

  services.tailscale.enable = true;
  services.tailscale.useRoutingFeatures = "client";
  networking.nftables.enable = true;

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

      # Wifi adapter priority: the onboard card (wlo*) has a flaky antenna,
      # so whenever an external USB wifi adapter (e.g. wlp0s20f0u1) is
      # plugged in and connected, it must carry the traffic. By default NM
      # gives every wifi connection metric 600 and resolves ties by
      # activation order (600/601), so after a reboot/resume the flaky
      # onboard card can randomly win the default route. Pinning the
      # onboard card to 700 keeps any other wifi (default 600) always
      # preferred, deterministically; the onboard card remains connected as
      # an instant fallback for when the adapter is unplugged.
      settings = {
        # Let a single wifi profile (same SSID) be auto-activated on both
        # adapters at once (multi-connect 3 = "multiple"); otherwise the
        # profile being "busy" on the onboard card would block the USB
        # adapter from auto-connecting to it.
        connection-wifi-multi-connect = {
          match-device = "type:wifi";
          "connection.multi-connect" = 3;
        };
        connection-wifi-onboard-deprioritize = {
          match-device = "interface-name:wlo*";
          "ipv4.route-metric" = 700;
          "ipv6.route-metric" = 700;
        };
      };
    };

    firewall.allowedTCPPorts = [8000 8080 7777 7778 7779 7780 7781 7782 7783 7784 7785 7786 7787];
    firewall.allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
    firewall.trustedInterfaces = [ "tailscale0" ];
    firewall.allowedUDPPorts = [ config.services.tailscale.port ];
    firewall.checkReversePath = "loose";
  };

  environment.systemPackages = with pkgs; [
    iw
  ];

  # ERTM off: lets Xbox wireless controllers pair over Bluetooth.
  boot.extraModprobeConfig = ''
    options bluetooth disable_ertm=1
  '';

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

    # Intel GPU configuration via nixos-hardware's `common-cpu-intel`
    # (imported in hosts/asus-zenbook-oled/default.nix). It already adds
    # intel-vaapi-driver, intel-media-driver, intel-compute-runtime and
    # the media/compute runtimes to `hardware.graphics.extraPackages`,
    # so we only declare what nixos-hardware doesn't cover (VDPAU bridges)
    # and toggle the option for hybrid codec on the VAAPI driver.
    intelgpu.enableHybridCodec = true;

    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        libvdpau-va-gl
        libva-vdpau-driver
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
      # JACK backend so pro-audio apps (e.g. Reaper) get low-latency JACK
      # via PipeWire, plus the `pw-jack` wrapper.
      jack.enable = true;
      wireplumber.enable = true;
    };

    blueman = {
      enable = true;
    };

    udisks2.enable = true;

    # Suspend when lid is closed — but only on battery. On AC the lid is
    # ignored so the notebook stays reachable for remote access
    # (Sunshine/Moonlight over Tailscale, see sunshine.nix) when left
    # plugged in with the lid shut.
    logind.settings.Login.HandleLidSwitch = "suspend";
    logind.settings.Login.HandleLidSwitchExternalPower = "ignore";
  };
}
