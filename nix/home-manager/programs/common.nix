{ pkgs, ... }:

{
  imports = [
    ./shell.nix
    ./git.nix
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

    vim = {
      enable = true;
      plugins = [ ];
    };
  };
}
