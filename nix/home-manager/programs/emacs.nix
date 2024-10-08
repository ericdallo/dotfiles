{ config, lib, pkgs, ... }:

{
  programs.emacs = {
    enable = true;
    package = pkgs.emacs-unstable-pgtk;
    extraPackages = (epkgs: [ epkgs.vterm ]);
  };
  services.emacs = with pkgs; {
    enable = true;
    client.enable = true;
  };
}
