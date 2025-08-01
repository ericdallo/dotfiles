{ pkgs, config, lib, ... }:
{
  boot = {
    tmp.useTmpfs = true;
    loader.efi.canTouchEfiVariables = false;
    initrd.availableKernelModules = [ "uhid" "xhci_pci" "ahci" "thunderbolt" "vmd" "usb_storage" "nvme" "rtsx_usb_sdmmc" "uas" "sd_mod" ];
    initrd.kernelModules = [ ];
    # kernelPackages = pkgs.linuxPackages_6_6;
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
    supportedFilesystems = [ "ntfs" ];

    loader.grub = {
      enable = true;
      devices = ["nodev"];
      efiSupport = true;
      configurationLimit = 10;
    };
  };

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
