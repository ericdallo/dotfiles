# Installer ISO for this flake's hosts: `make -C nix iso`, then
# `make -C nix usb DEVICE=/dev/sdX`. It boots the newest kernel (new laptops
# need it for Wi-Fi, display, ...), with nmtui and `gregnix-install <host>`,
# which installs a host in one go (install.sh, nix/README.md).
{ lib, modulesPath, pkgs, self, system, ... }:

let
  gregnix-install = pkgs.writeShellApplication {
    name = "gregnix-install";
    runtimeInputs = with pkgs; [
      curl
      git
      nixos-install-tools
      util-linux
      self.inputs.disko.packages.${system}.disko
    ];
    text = builtins.readFile ./install.sh;
  };
in
{
  imports = [
    # linuxPackages_latest; ZFS off, as it often lags behind new kernels.
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal-new-kernel-no-zfs.nix"
  ];

  image.baseName = lib.mkForce "gregnix-installer";
  # Much faster to build than the default (level 19), slightly bigger.
  isoImage.squashfsCompression = "zstd -Xcompression-level 6";

  # Flake inputs that can't be fetched anonymously (private, over SSH) ride
  # along in the ISO's store, where Nix finds them by hash: evaluating a host
  # then needs no GitHub key. They must match flake.lock, so rebuild the ISO
  # after bumping one.
  isoImage.storeContents = [ self.inputs.zscaler-docker ];

  hardware.enableRedistributableFirmware = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Readable on HiDPI panels (2880x1800 at 14": the default font is tiny).
  # The keymap stays US: what the hosts' LUKS prompts use too.
  console = {
    earlySetup = true;
    font = "ter-v32n";
    packages = [ pkgs.terminus_font ];
  };

  environment.systemPackages = [
    gregnix-install
    pkgs.git
    # Also at hand to redo a step by hand, e.g. `disko --mode mount`.
    self.inputs.disko.packages.${system}.disko
  ];
}
