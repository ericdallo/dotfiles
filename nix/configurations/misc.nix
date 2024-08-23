{ pkgs, ... }:

{
  console = {
    useXkbConfig = true;
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "America/Sao_Paulo";
}
