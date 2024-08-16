{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    globalprotect-openconnect
  ];
}
