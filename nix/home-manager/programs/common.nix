{ pkgs, ... }:

{
  nixpkgs.overlays = [
    (import (fetchGit {
      url = "https://github.com/nix-community/emacs-overlay";
      ref = "master";
      rev = "ca18017fa61a4bb8069d1bba74c4198c3c21c6fc";
    }))
  ];

  imports = [
    ./shell.nix
    ./git.nix
    ./network-manager.nix
    ./tmux.nix
    ./tmuxinator.nix
    ./urxvt.nix
    ./emacs.nix
  ];

  home.packages = with pkgs; [ google-drive-ocamlfuse sqlite ];

  programs = {
    home-manager.enable = true;

    vim = {
      enable = true;
      plugins = [ ];
    };
  };
}
