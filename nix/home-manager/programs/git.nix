{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs;
    [
      difftastic
    ];
  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.hub;
    userName = "Eric Dallo";
    userEmail = "ericdallo06@hotmail.com";
    includes = [{ path = "~/.dotfiles/.gitconfig"; }];

    ignores = [ ".lsp/.cache" ".clj-kondo/.cache" ".aider*" ];
  };
}
