{ config, lib, ... }:
{
  boot = {
    #tmp.useTmpfs = true;
    #loader.grub.enable = true;
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    initrd.availableKernelModules = [ "xhci_pci" "ahci" "thunderbolt" "vmd" "usb_storage" "nvme" "rtsx_usb_sdmmc" "uas" "sd_mod" ];
    initrd.kernelModules = [ ];
    kernelModules = [ "kvm-intel" ];
    kernelParams = [ "i915.force_probe=7d55" ];
    extraModulePackages = [ ];
    supportedFilesystems = [ "ntfs" ];
    extraModprobeConfig = '' options bluetooth disable_ertm=1 '';
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

  swapDevices = [ {device = "/dev/disk/by-uuid/5481837c-82f0-4231-880a-88df2c154d56";} ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  virtualisation = {
    docker.enable = true;

    virtualbox.host.enable = true;
  };

  nix.settings.max-jobs = lib.mkDefault 8;
}
