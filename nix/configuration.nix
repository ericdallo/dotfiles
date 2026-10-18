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
      self.inputs.zscaler-docker.nixosModules.zscaler
    ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit self system;
    };
  };

  nixpkgs.config.permittedInsecurePackages = [
    "libsoup-2.74.3"
    # Pulled in transitively (likely by an Electron-based app such as
    # Ferdium). Node 20 is EOL upstream; we accept the risk because the
    # app sandboxes its renderer.
    "nodejs-20.20.2"
    "nodejs-slim-20.20.2"
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
