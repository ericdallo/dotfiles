{ config, ... }:

{
  imports = [
    ../../configuration.nix
  ];

  home-manager.users.greg.imports = [ ../../home-manager/personal.nix ];

  networking.hostName = "gregnix-ssd";
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.efiSupport = true;

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
}
