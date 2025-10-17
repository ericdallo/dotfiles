{ config, lib, inputs, system, pkgs, ... }:

{
  home.packages = [
    # pkgs.vpn  # Temporarily disabled to debug webkitgtk issue
  ];

  xdg.desktopEntries = {
    vpn = {
      name = "GlobalProtect Openconnect VPN Client";
      genericName = "GlobalProtect VPN Client";
      exec = "gpclient launch-gui %u";
      terminal = true;
      categories = [ "Application" "Network"];
      mimeType = [ "x-scheme-handler/globalprotectcallback" ];
    };
  };
}
