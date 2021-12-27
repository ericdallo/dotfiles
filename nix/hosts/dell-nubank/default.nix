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
      device = "/dev/disk/by-uuid/66408c59-a2fd-4333-b4c6-f6076f2458e9";
      fsType = "ext4";
    };

  swapDevices = [{
    device = "/dev/disk/by-uuid/7f5352c0-19c6-4327-8308-3d4a40ac368c";
  }];

  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
}
