{ config, lib, ... }:
{
  boot = {
    tmpOnTmpfs = true;
    loader.grub.enable = true;
    loader.grub.version = 2;
    initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "nvme" "rtsx_usb_sdmmc" "uas" "sd_mod" ];
    initrd.kernelModules = [ ];
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
    supportedFilesystems = [ "ntfs" ];
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

  nix.maxJobs = lib.mkDefault 8;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
