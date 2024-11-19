{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    jdt-language-server
  ];

  # programs = {
  #   java = {
  #     enable = true;
  #     package = pkgs.jdk17;
  #   };
  # };
}
