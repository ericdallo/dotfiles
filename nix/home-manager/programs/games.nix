{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    # dolphin-emu-beta
    aseprite
    lutris
    steam
    wineWowPackages.staging
    godot_4
    steam-run
    cemu
    winetricks
    gamemode
  ];
}
