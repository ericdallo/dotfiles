{ config, lib, pkgs, ... }:

let
  emacsPackage = (pkgs.emacsPackagesFor pkgs.emacsGcc).emacsWithPackages
    (epkgs: [ epkgs.vterm ]);
in {

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
