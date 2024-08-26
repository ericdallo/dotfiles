{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    # dolphin-emu-beta
    lutris
    wineWowPackages.staging
    godot_4
    cemu
    winetricks
  ];
}
