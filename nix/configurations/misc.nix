{ pkgs, ... }:

let
  xmodmapLayout = pkgs.writeText "xkb-layout" ''
    keycode 105 = Pause
    keycode 127 = Control_R
  '';
in {
  boot = {
    tmpOnTmpfs = true;
  };

  console.keyMap = "us-acentos";

  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "America/Sao_Paulo";

  services.xserver.displayManager.sessionCommands = "${pkgs.xorg.xmodmap}/bin/xmodmap ${xmodmapLayout}";

  system.autoUpgrade = {
    enable = true;
    dates = "daily";
  };
}
