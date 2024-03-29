{ config, lib, ... }:
{
  boot = {
    tmp.useTmpfs = true;
    loader.grub.enable = true;
    initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "nvme" "rtsx_usb_sdmmc" "uas" "sd_mod" ];
    initrd.kernelModules = [ ];
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
    supportedFilesystems = [ "ntfs" ];
    extraModprobeConfig = '' options bluetooth disable_ertm=1 '';
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  virtualisation = {
    docker.enable = true;

    virtualbox.host.enable = true;
  };

  nix.settings.max-jobs = lib.mkDefault 8;
}
