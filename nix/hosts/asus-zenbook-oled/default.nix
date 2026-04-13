{ config, lib, self, system, ... }:

{
  imports = [
    ../../configuration.nix
  ];

  home-manager.users.greg = {
    imports = [
      ../../home-manager/common.nix
      ../../configurations/overlays.nix
      ../../home-manager/programs/zsh.nix
      ../../home-manager/programs/clojure.nix
      # ../../home-manager/programs/rust.nix
      ../../home-manager/programs/vscode.nix
      ../../home-manager/programs/idea.nix
      # ../../home-manager/programs/android.nix
      # ../../home-manager/programs/gregflix.nix
      ../../home-manager/programs/python.nix
      ../../home-manager/programs/games.nix
      ../../home-manager/programs/audio.nix
      ../../home-manager/programs/java.nix
      ../../home-manager/programs/nubank.nix
    ];
  };
  networking.hostName = "gregnix-personal";

  boot = {
    kernelModules = [ "acpi_call" ];
    extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];
    kernelParams = [ "i915.force_probe=7d55" ];
    extraModprobeConfig = ''
      options bluetooth disable_ertm=1
      options snd-hda-intel model=asus-zenbook
      '';
    loader.grub.extraFiles = {
      "ssdt-csc3551.aml" = "${./ssdt-csc3551.aml}"; # https://github.com/smallcms/asus_zenbook_ux3405ma
    };
    loader.grub.extraConfig = ''
      acpi /ssdt-csc3551.aml
    '';

  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/42199ee5-871e-44bc-8471-5219380e6704";
    fsType = "ext4";
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/5383-D71A";
    fsType = "vfat";
    options = [ "fmask=0022" "dmask=0022" ];
  };
  swapDevices = [ {device = "/dev/disk/by-uuid/54eb3f94-cafd-4afa-beb3-0e126a346252";} ];

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "ondemand"; # scales frequency dynamically based on load
  };

  services.thermald.enable = true; # Intel thermal management

  # Set ASUS thermal policy on boot
  # 0 = balanced (EC ramps fans aggressively when hot, quiet at idle)
  # 1 = performance (fans always aggressive)
  # 2 = quiet (caps max fan speed — dangerous under sustained load!)
  systemd.services.asus-quiet-fan = {
    description = "Set ASUS thermal policy to balanced mode";
    wantedBy = [ "multi-user.target" ];
    after = [ "systemd-modules-load.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "/bin/sh -c 'echo 0 > /sys/devices/platform/asus-nb-wmi/throttle_thermal_policy'";
      RemainAfterExit = true;
    };
  };

  services.auto-cpufreq = {
    enable = true; # dynamically switches governor based on load
    settings = {
      charger = {
        governor = "performance";
        turbo = "auto";
      };
      battery = {
        governor = "powersave";
        turbo = "never";
      };
    };
  };
}
