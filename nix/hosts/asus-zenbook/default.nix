{ config, lib, self, system, ... }:

{
  imports = [
    ../../configuration.nix
  ];

  home-manager = {
    useUserPackages = true;
    users.greg = ../../home-manager/personal.nix;
    extraSpecialArgs = {
      inherit self system;
    };
  };

  # TODO change to gregnix-asus
  networking.hostName = "gregnix-personal";
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/42199ee5-871e-44bc-8471-5219380e6704";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/5383-D71A";
    fsType = "vfat";
    options = [ "fmask=0022" "dmask=0022" ];
  };

  swapDevices = [ {device = "/dev/disk/by-uuid/5481837c-82f0-4231-880a-88df2c154d56";} ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
