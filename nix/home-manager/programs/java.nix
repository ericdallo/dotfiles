{ config, lib, pkgs, ... }:

{
  programs = {
    java = {
      enable = true;
      package = pkgs.jdk11;
    };
  };
}
