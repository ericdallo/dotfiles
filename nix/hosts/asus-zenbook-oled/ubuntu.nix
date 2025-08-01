{ config, lib, self, system, ... }:

let
  username = "greg";
in {
  imports = [
    ../../home-manager/common.nix
    ../../configurations/overlays.nix
    ../../home-manager/programs/zsh.nix
    ../../home-manager/programs/clojure.nix
    ../../home-manager/programs/vscode.nix
    ../../home-manager/programs/idea.nix
    ../../home-manager/programs/python.nix
    ../../home-manager/programs/audio.nix
    ../../home-manager/programs/java.nix
    ../../home-manager/programs/nubank.nix
  ];

  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    sessionVariables = {
      DOTFILES = "$HOME/.dotfiles";
      NIXOS_OZONE_WL = "1";
    };
  };
}
