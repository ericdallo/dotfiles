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
        version = "3.32.0";
        sha256 = "sha256-+PfG6+XqOFbZFr4pKPUnq3AK8OKBBEAdiB4cqm2UCew=";
      }
      {
        name = "calva";
        publisher = "betterthantomorrow";
        version = "2.0.236";
        sha256 = "sha256-mZrdroJumlhV6zHLqX+2k/JxJS0dMyhbDkSqIdokHnI=";
      }
    ];
  };
}
