{ pkgs, config, lib, ... }:
{
  boot = {
    #tmp.useTmpfs = true;
    loader.efi.canTouchEfiVariables = true;
    initrd.availableKernelModules = [ "xhci_pci" "ahci" "thunderbolt" "vmd" "usb_storage" "nvme" "rtsx_usb_sdmmc" "uas" "sd_mod" ];
    initrd.kernelModules = [ ];
    # kernelPackages = pkgs.linuxPackages_6_6;
    kernelModules = [ "kvm-intel" ];
    kernelParams = [ "i915.force_probe=7d55" ];
    extraModulePackages = [ ];
    supportedFilesystems = [ "ntfs" ];
    extraModprobeConfig = ''options bluetooth disable_ertm=1
                            options snd-hda-intel model=asus-zenbook
                          '';

    loader.grub = {
      enable = true;
      devices = ["nodev"];
      efiSupport = true;
      configurationLimit = 10;
      extraFiles = {
        "ssdt-csc3551.aml" = "${./ssdt-csc3551.aml}"; # https://github.com/smallcms/asus_zenbook_ux3405ma
      };
      extraConfig = ''
        acpi /ssdt-csc3551.aml
        '';
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
