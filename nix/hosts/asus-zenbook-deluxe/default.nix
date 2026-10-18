{ config, lib, self, ... }:

{
  imports = [
    ../../configuration.nix
    # Same nixos-hardware baselines as the oled host. Besides the laptop/SSD
    # defaults, common-cpu-intel defines the `hardware.intelgpu.*` options
    # that configurations/hardware.nix sets, so it is required to evaluate.
    self.inputs.hardware.nixosModules.common-cpu-intel
    self.inputs.hardware.nixosModules.common-pc-laptop
    self.inputs.hardware.nixosModules.common-pc-laptop-ssd
  ];

  # home-manager activation refuses to overwrite pre-existing, unmanaged
  # dotfiles and otherwise aborts the WHOLE activation (home-manager-greg
  # .service fails), leaving the session unconfigured. Back such files up
  # (.hm-bak) instead of aborting.
  home-manager.backupFileExtension = "hm-bak";

  # Same programs as the oled host (hosts/asus-zenbook-oled), minus games.nix:
  # this is a stopgap machine with a nearly full disk.
  home-manager.users.greg = {
    imports = [
      ../../home-manager/common.nix
      ../../configurations/overlays.nix
      ../../home-manager/programs/zsh.nix
      ../../home-manager/programs/clojure.nix
      ../../home-manager/programs/vscode.nix
      ../../home-manager/programs/idea.nix
      ../../home-manager/programs/python.nix
      ../../home-manager/programs/audio.nix
      ../../home-manager/programs/java.nix
      ../../home-manager/programs/nubank.nix
    ];
  };
  networking.hostName = "gregnix-deluxe";

  # ASUS ZenBook 3 Deluxe UX490UAR: i7-8550U (Kaby Lake-R, UHD 620) and
  # Intel 8260 wifi. The stock nixpkgs kernel works fine here; the 6.18.16
  # pin in flake.nix is a Meteor Lake (oled host) workaround only.
  #
  # Boot: this machine boots in *legacy BIOS* mode (no /sys/firmware/efi).
  # GRUB's i386-pc core sits in the 2M bios_grub partition (nvme0n1p1) from
  # the original install, and the shared loader config (boot.nix:
  # devices = [ "nodev" ]) only regenerates /boot/grub/grub.cfg, which that
  # core reads. Leave the bootloader settings alone unless you also re-run
  # grub-install for i386-pc.
  boot.extraModprobeConfig = ''
    options bluetooth disable_ertm=1
  '';

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/fa09abc3-cb9e-4a15-a5cf-e756fbb8e960";
    fsType = "ext4";
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/72B4-1BAE";
    fsType = "vfat";
    options = [ "fmask=0022" "dmask=0022" ];
  };
  swapDevices = [ { device = "/dev/disk/by-uuid/d8325f60-ea5a-4da2-8124-1144775be653"; } ];

  # Power management mirrors the oled host. This model has no ASUS
  # throttle_thermal_policy knob, hence no fan-policy service here.
  powerManagement.enable = true;
  services.thermald.enable = true; # Intel thermal management

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
