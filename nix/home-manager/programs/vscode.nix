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
        version = "3.27.2";
        sha256 = "sha256-Vv62r3UuNfWjpGJ/3QPlRk+Es+knHdCqOoZ9vimTk90=";
      }
      {
        name = "calva";
        publisher = "betterthantomorrow";
        version = "2.0.231";
        sha256 = "sha256-XUkUhcfEohLAkV1b77aO2VA8BNLaY/pLnmGc/IpCjdY=";
      }
    ];
  };
}
