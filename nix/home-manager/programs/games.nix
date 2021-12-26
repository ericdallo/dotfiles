{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    dolphin-emu-beta
    lutris
    gnome3.adwaita-icon-theme # for lutris
  ];
}
