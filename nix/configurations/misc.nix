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

  services.xserver.displayManager.sessionCommands = "${pkgs.xorg.xmodmap}/bin/xmodmap ${xmodmapLayout}";

  system.autoUpgrade = {
    enable = true;
    dates = "daily";
  };
}
