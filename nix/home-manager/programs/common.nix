{ pkgs, ... }:

{
  imports = [
    ./cli.nix
    ./shell.nix
    ./git.nix
    ./network-manager.nix
    ./tmux.nix
    ./tmuxinator.nix
    ./urxvt.nix
    ./emacs.nix
  ];

  programs = {
    vim = {
      enable = true;
      plugins = [ ];
    };
  };
}
