{ config, ... }:

{
  networking.hostName = "gregnix-note";
  boot.loader.grub.device = "/dev/nvme0n1";
  boot.loader.grub.efiSupport = true;

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
}
