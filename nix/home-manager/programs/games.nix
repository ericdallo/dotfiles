{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    # dolphin-emu-beta
    aseprite
    lutris
    wineWowPackages.staging
    master.godot_4
    steam-run
    cemu
    winetricks
    gamemode
  ];
}
