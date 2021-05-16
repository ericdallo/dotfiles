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
        version = "3.21.1";
        sha256 = "1b8k30hjss91ch45qp2hljy1idwvs2j0q40kpiwm8s1ik9v82wd0";
      }
      {
        name = "calva";
        publisher = "betterthantomorrow";
        version = "2.0.197";
        sha256 = "097ixzyblrm48960yl6bz2zcdmv4rsjaam81rknp4fnmms3szlnp";
      }
    ];
  };
}
