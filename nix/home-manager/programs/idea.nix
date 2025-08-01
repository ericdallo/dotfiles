{ config, lib, self, pkgs, ... }:

{
  home.packages = with pkgs; [
    jetbrains.idea-community
  ];
}
