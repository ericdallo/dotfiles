{ config, lib, pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
        # bbenoist.Nix
        # ms-python.python
        formulahendry.code-runner
        ms-dotnettools.csharp
        msjsdiag.debugger-for-chrome
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "dart-code";
        publisher = "dart-code";
        version = "3.42.1";
        sha256 = "sha256-a3p+2ZRpDQKp7v/1y6wDm1o+j1JjuGaWn/whh7pBcUg";
      }
      {
        name = "calva";
        publisher = "betterthantomorrow";
        version = "2.0.287";
        sha256 = "sha256-AweIsNm0tTGAtDx23qAeQb6j/G74MCG5PyXlMLVG+58=";
      }
    ];
  };
}
