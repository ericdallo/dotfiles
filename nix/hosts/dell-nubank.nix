{ config, lib, pkgs, ... }:

{
  networking.hostName = "gregnix-nubank";
  boot.loader.grub.device = "/dev/nvme0n1";

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/0838c16b-eedc-4dbf-8c57-be2f848e8b7d";
      fsType = "ext4";
    };

  swapDevices = [{
    device = "/dev/disk/by-uuid/5c2797cc-2924-4ff5-9716-90f7f71ebd85";
  }];
}
