{ pkgs, ... }:

{
  home.packages = [ pkgs.networkmanager_dmenu ];

  xdg.configFile."networkmanager-dmenu/config.ini".source = ../../../.config/networkmanager-dmenu/config.ini;
}
