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
      ./configurations/flatpak.nix
      ./configurations/samba.nix
      ./configurations/sunshine.nix
      ./configurations/misc.nix
      ./configurations/power.nix
      self.inputs.zscaler-docker.nixosModules.zscaler
    ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    # home-manager activation refuses to overwrite pre-existing, unmanaged
    # dotfiles (e.g. ~/.config/nvim/init.lua) and otherwise aborts the WHOLE
    # activation (home-manager-greg.service fails), leaving the session
    # unconfigured. Back such files up (.hm-bak) instead of aborting.
    backupFileExtension = "hm-bak";
    extraSpecialArgs = {
      inherit self system;
    };
  };

  nixpkgs.config.permittedInsecurePackages = [
    "libsoup-2.74.3"
  ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  services.printing.enable = true;

  # Zscaler ZTNA transparent VPN (Docker-based). The module now lives in the
  # standalone zscaler-docker repo and is imported above as
  # self.inputs.zscaler-docker.nixosModules.zscaler. cloud/domain default to Nubank.
  services.zscaler.enable = true;

  users.users.greg = {
    isNormalUser = true;
    extraGroups = [
      "greg"
      "wheel"
      "docker"
      "fido"
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
    ignoreShellProgramCheck = true;
  };

  security.sudo.extraRules= [
    {  users = [ "greg" ];
       commands = [
         { command = "ALL" ;
           options= [ "NOPASSWD" ];
         }
       ];
    }
  ];

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
