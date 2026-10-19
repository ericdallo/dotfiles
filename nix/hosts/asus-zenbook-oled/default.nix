{ config, lib, self, system, ... }:

let
  # See flake.nix `nixpkgs-kernel`: pin the kernel to the last-good
  # nixpkgs (linux 6.18.16) to dodge the 6.18.33 i915 Meteor Lake
  # black-screen regression, while the rest of the system tracks the
  # updated `nixpkgs`. Only boot.kernelPackages consumes this.
  kernelPkgs = import self.inputs.nixpkgs-kernel {
    inherit system;
    config = {
      allowUnfree = true;
      allowBroken = true;
    };
  };
  # The pin predates the only two attributes newer NixOS modules read off
  # the kernel that it lacks; these are their x86 values. passthru: they
  # survive NixOS's own kernel.override and leave the build untouched.
  pinnedLinuxPackages = kernelPkgs.linuxPackages.extend (final: prev: {
    kernel = prev.kernel.overrideAttrs (old: {
      passthru = (old.passthru or { }) // {
        target = "bzImage";
        buildDTBs = false;
      };
    });
  });
in
{
  imports = [
    ../../configuration.nix
    # A second boot entry running only grog, now that the screen broke.
    ./grog-station.nix
    # Hardware quirks from nixos-hardware. No Zenbook UX3405MA-specific
    # module exists upstream yet, so we compose the generic baselines.
    # The bespoke i915.force_probe=7d55 below stays — it targets this
    # machine's specific iGPU PCI ID.
    self.inputs.hardware.nixosModules.common-cpu-intel
    self.inputs.hardware.nixosModules.common-pc-laptop
    self.inputs.hardware.nixosModules.common-pc-laptop-ssd
  ];

  # Overlays come with the system's pkgs (home-manager.useGlobalPkgs).
  home-manager.users.greg = {
    imports = [
      ../../home-manager/common.nix
      ../../home-manager/programs/zsh.nix
      ../../home-manager/programs/clojure.nix
      # ../../home-manager/programs/rust.nix
      ../../home-manager/programs/vscode.nix
      ../../home-manager/programs/idea.nix
      # ../../home-manager/programs/android.nix
      # ../../home-manager/programs/gregflix.nix
      ../../home-manager/programs/python.nix
      ../../home-manager/programs/games.nix
      ../../home-manager/programs/audio.nix
      ../../home-manager/programs/java.nix
      ../../home-manager/programs/nubank.nix
    ];
  };
  networking.hostName = "gregnix-personal";

  boot = {
    # Pinned kernel (linux 6.18.16) — see the let-bindings above.
    kernelPackages = pinnedLinuxPackages;
    kernelModules = [ "acpi_call" ];
    extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];
    kernelParams = [ "i915.force_probe=7d55" ];
    # NOTE: the `snd-hda-intel model=asus-zenbook` override and the
    # `ssdt-csc3551.aml` ACPI injection used to be required, but linux 6.18
    # supports this laptop's audio natively, so both were removed:
    #   * The ALC294 fixup is auto-selected by PCI SSID 1043:1a63 (UX3405MA);
    #     "asus-zenbook" isn't even a valid Realtek model alias, so model=
    #     was a silent no-op.
    #   * The cs35l41-hda driver has built-in _DSD properties for the dual
    #     CS35L41 amps (SSID 10431A63) and logs "Using extra _DSD properties,
    #     bypassing _DSD in ACPI" — i.e. it ignores the injected SSDT.
    # The ssdt-csc3551.aml file is kept in-tree for easy revert; delete it
    # once a reboot confirms speakers still work without it.
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
  swapDevices = [ {device = "/dev/disk/by-uuid/54eb3f94-cafd-4afa-beb3-0e126a346252";} ];

  # The rest of the power management (auto-cpufreq, thermald) is shared:
  # configurations/power.nix.
  powerManagement.cpuFreqGovernor = "ondemand"; # scales frequency dynamically based on load

  # Set ASUS thermal policy on boot
  # 0 = balanced (EC ramps fans aggressively when hot, quiet at idle)
  # 1 = performance (fans always aggressive)
  # 2 = quiet (caps max fan speed — dangerous under sustained load!)
  systemd.services.asus-quiet-fan = {
    description = "Set ASUS thermal policy to balanced mode";
    wantedBy = [ "multi-user.target" ];
    after = [ "systemd-modules-load.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "/bin/sh -c 'echo 0 > /sys/devices/platform/asus-nb-wmi/throttle_thermal_policy'";
      RemainAfterExit = true;
    };
  };
}
