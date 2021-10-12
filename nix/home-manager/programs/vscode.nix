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
        version = "3.25.1";
        sha256 = "000my46a74w9gx9kbilks1a1wx4bxb6xbcgx3328k7is2qamy8j7";
      }
      {
        name = "calva";
        publisher = "betterthantomorrow";
        version = "2.0.208";
        sha256 = "0v9xxj1jcqz0dlyij369gb61aqh9r762kjzrbk9c9xw37mb078np";
      }
    ];
  };
}
