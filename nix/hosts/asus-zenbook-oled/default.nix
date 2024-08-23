{ config, lib, self, system, ... }:

{
  imports = [
    ../../configuration.nix
  ];

  home-manager.users.greg = {
    imports = [
      ../../home-manager/common.nix
      ../../configurations/overlays.nix
      ../../home-manager/programs/clojure.nix
      ../../home-manager/programs/rust.nix
      ../../home-manager/programs/vscode.nix
      ../../home-manager/programs/idea.nix
      ../../home-manager/programs/android.nix
      ../../home-manager/programs/gregflix.nix
      ../../home-manager/programs/python.nix
      ../../home-manager/programs/games.nix
      ../../home-manager/programs/audio.nix
      ../../home-manager/programs/unity.nix
      ../../home-manager/programs/nubank.nix
      # ./programs/java.nix
    ];
  };
  networking.hostName = "gregnix-personal";

  boot = {
    kernelParams = [ "i915.force_probe=7d55" ];
    extraModprobeConfig = ''
      options bluetooth disable_ertm=1
      options snd-hda-intel model=asus-zenbook
      '';
    loader.grub.extraFiles = {
      "ssdt-csc3551.aml" = "${./ssdt-csc3551.aml}"; # https://github.com/smallcms/asus_zenbook_ux3405ma
    };
    loader.grub.extraConfig = ''
      acpi /ssdt-csc3551.aml
    '';

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

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
