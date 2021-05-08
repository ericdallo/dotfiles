{ config, lib, pkgs, ... }:

{
  home.file.".gregflix-functions".source = ../../../.gregflix-functions;
  home.file.".tmdb-functions".source = ../../../.tmdb-functions;
}
