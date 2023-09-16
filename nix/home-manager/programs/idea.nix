{ config, lib, self, pkgs, ... }:

{
  home.packages = with pkgs; [
    master.jetbrains.idea-community
  ];
}
