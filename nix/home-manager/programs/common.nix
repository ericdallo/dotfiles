{ pkgs, ... }:

{
  # home.stateVersion = "20.09";

  imports = [
    ./network-manager.nix
    ./tmux.nix
    ./tmuxinator.nix
    ./urxvt.nix
  ];

  home.packages = with pkgs; [
    google-drive-ocamlfuse
    sqlite
  ];

  programs = {
    home-manager.enable = true;

    git = {
      enable = true;

      package = pkgs.gitAndTools.hub;
    };

    vim = {
      enable = true;
      plugins = [ ];
    };
  };
}
