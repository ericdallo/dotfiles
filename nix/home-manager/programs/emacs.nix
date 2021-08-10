{ config, lib, pkgs, ... }:

let
  emacsPackage = (pkgs.emacsPackagesGen pkgs.emacsGcc).emacsWithPackages
    (epkgs: [ epkgs.vterm ]);
in {

  home.sessionVariables = { EDITOR = "emacs"; };
  programs.emacs = {
    enable = true;
    package = emacsPackage;
  };
  services.emacs = with pkgs; {
    enable = true;
    package = emacsPackage;
    client.enable = true;
  };
}
