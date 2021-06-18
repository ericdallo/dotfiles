{ config, lib, pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
        bbenoist.Nix
        ms-python.python
        formulahendry.code-runner
        ms-dotnettools.csharp
        msjsdiag.debugger-for-chrome
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "dart-code";
        publisher = "dart-code";
        version = "3.23.0";
        sha256 = "0kf7h19h4ll6sg14dylx272swhsi8zgh04v64p5yfm0ymh3sc5wz";
      }
      {
        name = "calva";
        publisher = "betterthantomorrow";
        version = "2.0.199";
        sha256 = "1n8q1wp40scmixkw22f8m5a52yk54qqyfa0c4rmlr78587rsmhna";
      }
    ];
  };
}
