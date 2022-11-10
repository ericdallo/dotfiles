# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, self, ... }:
let
  inherit (self) inputs;
in
{
  nixpkgs.config.allowUnfree = true;

  imports =
    [
      self.inputs.home-manager.nixosModules.home-manager
      ./configurations/overlays.nix
      ./configurations/boot.nix
      ./configurations/hardware.nix
      ./configurations/desktop.nix
      ./configurations/cli.nix
      ./configurations/misc.nix
    ];

  networking.extraHosts = ''
    172.17.0.1 mysql
    172.17.0.1 datomic
  '';

  services.printing.enable = true;

  sound.enable = true;

  users.users.greg = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "docker"
      "networkmanager"
      "vboxusers"
      "video"
      "audio"
      "sound"
      "adbusers"
      "input"
    ];

    shell = pkgs.zsh;
  };

  nix = {
    settings.allowed-users = [ "greg" ];
    # Set the $NIX_PATH entry for nixpkgs. This is necessary in
    # this setup with flakes, otherwise commands like `nix-shell
    # -p pkgs.htop` will keep using an old version of nixpkgs
    nixPath = [
      "nixpkgs=${self.inputs.nixpkgs}"
    ];

    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "22.05"; # Did you read the comment?

}
