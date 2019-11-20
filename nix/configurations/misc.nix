{ pkgs, ... }:

{
  boot = {
    tmpOnTmpfs = true;
  };

  system.autoUpgrade = {
    enable = true;
    dates = "daily";
  };
}
