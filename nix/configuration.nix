{ config, pkgs, system, self, ... }:
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
      ./configurations/samba.nix
      ./configurations/misc.nix
    ];

  home-manager = {
    useUserPackages = true;
    extraSpecialArgs = {
      inherit self system;
    };
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  services.printing.enable = true;

  users.users.greg = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "docker"
      "gamemode"
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
    settings.trusted-users = [ "root" "greg" ];
    nixPath = [
      "nixpkgs=${self.inputs.nixpkgs}"
    ];

    package = pkgs.nixVersions.stable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  system.stateVersion = "24.05";
}
