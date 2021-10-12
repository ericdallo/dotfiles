{ pkgs, ... }:

{
  imports = [
    ./shell.nix
    ./git.nix
    ./network-manager.nix
    ./tmux.nix
    ./tmuxinator.nix
    ./urxvt.nix
    ./emacs.nix
  ];

  home.packages = with pkgs; [
    google-drive-ocamlfuse
    rnix-lsp
    sqlite
  ];

  programs = {
    vim = {
      enable = true;
      plugins = [ ];
    };
  };
}
