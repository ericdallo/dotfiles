{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    # dolphin-emu-beta
    lutris
    wineWowPackages.staging
    cemu
    winetricks
  ];
}
