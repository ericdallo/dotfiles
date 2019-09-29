{ pkgs, ... }:

{
  environment.systemPackages = with pkgs;
  let
    # gnomeExtensions-drop-down-terminal = with pkgs; stdenv.mkDerivation rec {
    #   name = "gs-extensions-drop-down-terminal";
    #   version = "v24";
    #   src = fetchurl {
    #     url = "https://github.com/zzrough/${name}/archive/${version}.tar.gz";
    #     sha256 = "03cr79v5wz5azd2cshkcd76wgmzcpdh3qkr2f97hz0j8bdaspsmb";
    #   };
    # };
  in
    [
      franz
      google-chrome
      slack
      gnomeExtensions.battery-status
      # gnomeExtensions-drop-down-terminal
    ];

  services.xserver.enable = true;
  services.xserver.desktopManager = {
    gnome3.enable = true;
  };
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = false;

  services.xserver.libinput.enable = true;
}
