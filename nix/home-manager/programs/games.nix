{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    # dolphin-emu-beta
    aseprite
    lutris
    steam
    # wineWowPackages.staging
    master.godot
    audacity
    steam-run
    cemu
    winetricks
    gamemode
  ];
}
