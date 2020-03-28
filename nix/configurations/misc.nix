{ pkgs, ... }:

{
  boot = {
    tmpOnTmpfs = true;
  };

  console = {
    useXkbConfig = true;
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "America/Sao_Paulo";

  services.xserver = {
    xkbOptions = "ctrl:nocaps";
  };

  system.autoUpgrade = {
    enable = true;
    dates = "daily";
  };
}
