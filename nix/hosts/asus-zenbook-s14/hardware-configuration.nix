# Written by nix/bootstrap.sh from the NixOS installer's /etc/nixos: its
# hardware-configuration.nix, plus what follows its last line of options.
# Run nix/bootstrap.sh again after reinstalling.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "vmd" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/mapper/luks-9351bfe1-80dc-4bd1-a56c-1eaedd2ed1fc";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."luks-9351bfe1-80dc-4bd1-a56c-1eaedd2ed1fc".device = "/dev/disk/by-uuid/9351bfe1-80dc-4bd1-a56c-1eaedd2ed1fc";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/EE90-2BF8";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  swapDevices =
    [ { device = "/dev/mapper/luks-b48c3d5b-4a10-4d9c-9076-547bdd68437a"; }
    ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.npu.enable = true;
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  # Encrypted swap: only the installer's configuration.nix declares it.
  boot.initrd.luks.devices."luks-b48c3d5b-4a10-4d9c-9076-547bdd68437a".device = "/dev/disk/by-uuid/b48c3d5b-4a10-4d9c-9076-547bdd68437a";
  # TRIM (services.fstrim) through LUKS, and faster on NVMe.
  boot.initrd.luks.devices."luks-9351bfe1-80dc-4bd1-a56c-1eaedd2ed1fc".allowDiscards = true;
  boot.initrd.luks.devices."luks-9351bfe1-80dc-4bd1-a56c-1eaedd2ed1fc".bypassWorkqueues = true;
  boot.initrd.luks.devices."luks-b48c3d5b-4a10-4d9c-9076-547bdd68437a".allowDiscards = true;
  boot.initrd.luks.devices."luks-b48c3d5b-4a10-4d9c-9076-547bdd68437a".bypassWorkqueues = true;
}
