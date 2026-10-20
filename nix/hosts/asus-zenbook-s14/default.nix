# ASUS Zenbook S14 UX5406AA (2026): Core Ultra 9 386H (Panther Lake, Intel
# Graphics with 4 Xe3 cores), 32G, 1T NVMe, 14" 2880x1800 120Hz OLED touch,
# Wi-Fi 7. NixOS only: installed with the official ISO, then turned into this
# host by nix/bootstrap.sh (nix/README.md).
{ config, lib, pkgs, self, ... }:

let
  # The disk as the NixOS installer set it up (LUKS, swap, ESP), written
  # here by nix/bootstrap.sh on the machine.
  hardwareConfig = ./hardware-configuration.nix;
  installed = builtins.pathExists hardwareConfig;
in
{
  imports = [
    ../../configuration.nix
    # Microcode, and the `hardware.intelgpu.*` options configurations/
    # hardware.nix sets. Unlike the other hosts, NOT common-pc-laptop: it
    # turns TLP on, which fights auto-cpufreq (configurations/power.nix).
    self.inputs.hardware.nixosModules.common-cpu-intel
  ] ++ lib.optional installed hardwareConfig;

  assertions = [
    {
      assertion = installed;
      message = "gregnix-s14 has no hardware-configuration.nix yet: run nix/bootstrap.sh gregnix-s14 on the machine (nix/README.md).";
    }
    {
      assertion = !installed || config.boot.initrd.luks.devices != { };
      message = "gregnix-s14 logs in automatically, which is only OK on an encrypted disk: install with the installer's \"Encrypt system\".";
    }
  ];

  networking.hostName = "gregnix-s14";

  # Same programs as the oled host (hosts/asus-zenbook-oled). Overlays come
  # with the system's pkgs (home-manager.useGlobalPkgs).
  home-manager.users.greg = {
    imports = [
      ../../home-manager/common.nix
      ../../home-manager/programs/zsh.nix
      ../../home-manager/programs/clojure.nix
      ../../home-manager/programs/vscode.nix
      ../../home-manager/programs/idea.nix
      ../../home-manager/programs/python.nix
      ../../home-manager/programs/games.nix
      ../../home-manager/programs/audio.nix
      ../../home-manager/programs/java.nix
      ../../home-manager/programs/nubank.nix
    ];
  };

  boot = {
    # Panther Lake is new: its audio (a CS42L43 codec and four CS35L56 amps
    # on SoundWire) needs Linux >= 7.2, which has this model's quirk, and
    # each release brings xe display fixes. Follow the newest kernel.
    kernelPackages = pkgs.linuxPackages_latest;
    # The OLED takes brightness over DPCD AUX, but xe follows the VBT (PWM):
    # without this, the brightness keys change nothing.
    kernelParams = [ "xe.enable_dpcd_backlight=1" ];
    # Kept as the NixOS installer sets it up on UEFI (the other hosts use
    # GRUB, configurations/boot.nix). Its ESP is 1G: room for 10.
    loader = {
      grub.enable = false;
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
      };
      efi.canTouchEfiVariables = true;
    };
  };

  # Xe3 iGPU: the xe driver (in the initrd too: early KMS for the LUKS
  # prompt) and the iHD VA-API driver.
  hardware.intelgpu = {
    driver = "xe";
    vaapiDriver = "intel-media-driver";
  };

  # The LUKS passphrase already authenticates at boot: log straight in.
  services.displayManager.autoLogin = {
    enable = true;
    user = "greg";
  };

  # The built-in panel at 120Hz, 1800x1125 logical (scale 1.6). For bigger
  # text: 1.8 (1600x1000).
  environment.etc."hypr/host.conf".text = ''
    monitor = eDP-1, 2880x1800@120, 0x0, 1.6, bitdepth, 8
  '';
}
