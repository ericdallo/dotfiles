{ pkgs, config, self, ... }:
let
  username = "greg";
in
{
  imports = [
    ../../home-manager/common.nix
    ../../configurations/overlays.nix
    ../../home-manager/programs/vscode.nix
    ../../home-manager/programs/clojure.nix
    ../../home-manager/programs/python.nix
    ../../home-manager/programs/android.nix
    ../../home-manager/programs/java.nix
    ../../home-manager/programs/idea.nix
    ../../home-manager/programs/zsh.nix
  ];

  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    sessionVariables = {
      DOTFILES = "$HOME/.dotfiles";
    };
  };
}
