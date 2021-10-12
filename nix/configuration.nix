# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  imports =
    [
      <home-manager/nixos>
      /etc/nixos/host.nix
      ./configurations/boot.nix
      ./configurations/hardware.nix
      ./configurations/desktop.nix
      ./configurations/cli.nix
      ./configurations/misc.nix
    ];

  nixpkgs.overlays = import ./configurations/overlays.nix;

  networking.extraHosts = ''
    172.17.0.1 mysql
    172.17.0.1 datomic
  '';

  services.printing.enable = true;

  sound.enable = true;

  users.users.greg = {
    isNormalUser = true;
    extraGroups = [ "wheel"
                    "docker"
                    "networkmanager"
                    "vboxusers"
                    "video"
                    "audio"
                    "sound"
                    "adbusers"
                    "input"];

    shell = pkgs.zsh;
  };
  nix.allowedUsers = [ "greg" ];
  nix.trustedUsers = [ "greg" ];

  home-manager.useGlobalPkgs = true;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "21.05"; # Did you read the comment?

}
