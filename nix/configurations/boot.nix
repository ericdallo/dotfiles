{ pkgs, config, lib, ... }:
{
  boot = {
    #tmp.useTmpfs = true;
    #loader.grub.enable = true;
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    initrd.availableKernelModules = [ "xhci_pci" "ahci" "thunderbolt" "vmd" "usb_storage" "nvme" "rtsx_usb_sdmmc" "uas" "sd_mod" ];
    initrd.kernelModules = [ ];
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [ "kvm-intel" ];
    kernelParams = [ "i915.force_probe=7d55" ];
    extraModulePackages = [ ];
    supportedFilesystems = [ "ntfs" ];
    extraModprobeConfig = '' options bluetooth disable_ertm=1
                             options snd-intel-dspcfg dsp_driver=1
                          '';
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
