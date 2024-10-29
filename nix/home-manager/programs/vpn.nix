{ config, lib, pkgs, ... }:

{
  home.packages = [
    # pkgs.vpn
  ];

  xdg.desktopEntries = {
    vpn = {
      name = "GlobalProtect Openconnect VPN Client";
      genericName = "GlobalProtect VPN Client";
      exec = "nix shell github:yuezk/GlobalProtect-openconnect -c gpclient launch-gui %u";
      terminal = true;
      categories = [ "Application" "Network"];
      mimeType = [ "x-scheme-handler/globalprotectcallback" ];
    };
  };
}
