{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    globalprotect-openconnect
  ];

  xdg.desktopEntries = {
    vpn = {
      name = "GlobalProtect Openconnect VPN Client";
      genericName = "GlobalProtect VPN Client";
      exec = "nix shell github:fzakaria/GlobalProtect-openconnect/add-flake-nix -c gpclient launch-gui %u";
      terminal = true;
      categories = [ "Application" "Network"];
      mimeType = [ "x-scheme-handler/globalprotectcallback" ];
    };
  };
}
