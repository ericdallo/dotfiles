{ config, pkgs, ... }:

{
  home.file.".env".source = ../../../.env;
  home.file.".functions".source = ../../../.functions;
}
