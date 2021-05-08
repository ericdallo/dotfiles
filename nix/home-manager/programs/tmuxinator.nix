{ pkgs, ... }:

{
  home.packages = [ pkgs.tmuxinator ];

  xdg.configFile."tmuxinator/personal.yml".source = ../../../.config/tmuxinator/personal.yml;
}
