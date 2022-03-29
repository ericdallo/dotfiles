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
        version = "3.36.0";
        sha256 = "sha256-7GIcR6UaW1QqpgyK/J0Gz2yXlKWIVg9LnZDa9DJfYgE=";
      }
      {
        name = "calva";
        publisher = "betterthantomorrow";
        version = "2.0.259";
        sha256 = "sha256-o1/FAiImeyNlkVSCPKHqW+1XkrYTktj1Upp1yTloeic=";
      }
    ];
  };
}
