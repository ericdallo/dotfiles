{ pkgs, ... }:

{
  console = {
    useXkbConfig = true;
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  services.automatic-timezoned.enable = true;
}
