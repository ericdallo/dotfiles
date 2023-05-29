{ pkgs, ... }:

let
  layout = ../layout.xkb;
in {
  boot = {
    tmp.useTmpfs = true;
  };

  console = {
    useXkbConfig = true;
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "America/Sao_Paulo";

  # services.xserver = {
    # xkbOptions = "ctrl:nocaps";
    # displayManager.sessionCommands = "${pkgs.xorg.xkbcomp}/bin/xkbcomp ${layout} $DISPLAY";
  # };
}
