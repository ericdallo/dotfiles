{ config, lib, pkgs, ... }:

let
  custom-python-packages = python-packages:
    with python-packages; [
      # pandas
      # jupyter
      # matplotlib
      # virtualenvwrapper
      python-language-server
      pybluez
      # bluepy
      # seaborn
      # pillow
      fonttools
      pip
    ];
  python-with-my-packages = pkgs.python37Full; # .withPackages custom-python-packages;
in {
  home.packages = with pkgs; [
    python-with-my-packages
  ];
}
