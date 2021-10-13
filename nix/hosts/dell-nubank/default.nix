{ config, lib, self, system, pkgs, ... }:

{
  imports = [
    ../../configuration.nix
  ];

  home-manager = {
    useUserPackages = true;
    users.greg = ../../home-manager/nubank.nix;
    extraSpecialArgs = {
      inherit self system;
    };
  };

  networking.hostName = "gregnix-nubank";
  boot.loader.grub.device = "/dev/nvme0n1";
  boot.kernelPackages = pkgs.linuxPackages_5_4;

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/a6c734cf-c985-4322-9e1c-e88beb863027";
      fsType = "ext4";
    };

  swapDevices = [{
    device = "/dev/disk/by-uuid/b1d04602-9d7b-4b73-91f0-3fbb58b7e47e";
  }];
}
