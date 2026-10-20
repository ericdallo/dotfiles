{ pkgs, config, lib, ... }:
{
  boot = {
    tmp.useTmpfs = true;
    # GRUB by default; a host installed by the NixOS installer on UEFI keeps
    # its systemd-boot instead (hosts/asus-zenbook-s14).
    loader.efi.canTouchEfiVariables = lib.mkDefault false;
    initrd.availableKernelModules = [ "uhid" "xhci_pci" "ahci" "thunderbolt" "vmd" "usb_storage" "nvme" "rtsx_usb_sdmmc" "uas" "sd_mod" ];
    initrd.kernelModules = [ ];
    # kernelPackages = pkgs.linuxPackages_6_6;
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
    supportedFilesystems = [ "ntfs" ];

    loader.grub = {
      enable = lib.mkDefault true;
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
