{ config, lib, ... }:
with lib;
mkMerge [{
  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.efiSupport = true;
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "nvme" "rtsx_usb_sdmmc" "uas" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  nix.maxJobs = lib.mkDefault 8;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
(mkIf (config.networking.hostName == "gregnix-note") {
  boot.loader.grub.device = "/dev/nvme0n1";

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/fa09abc3-cb9e-4a15-a5cf-e756fbb8e960";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/72B4-1BAE";
    fsType = "vfat";
  };

  swapDevices = [{
    device = "/dev/disk/by-uuid/d8325f60-ea5a-4da2-8124-1144775be653";
  }];
})
(mkIf (config.networking.hostName == "gregnix-ssd") {
  boot.loader.grub.device = "/dev/sda";

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/c0337d4e-4d87-46b6-81f9-3bcdc79ff5ae";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/5859-8F4D";
    fsType = "vfat";
  };

  swapDevices = [{
    device = "/dev/disk/by-uuid/088514ae-3eac-4613-a060-e457418a0202";
  }];
})]
