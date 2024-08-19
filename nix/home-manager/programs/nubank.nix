{ config, lib, pkgs, ... }:

let
  dotfilesDir = "$HOME/.dotfiles";
in {
  imports = [
    ./vpn.nix
  ];

  home = {
    packages = with pkgs; [
      kubelogin-oidc
      stable.kubectl
      zoom-us
    ];
  };
}
