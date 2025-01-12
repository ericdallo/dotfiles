{ config, lib, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = false;
    autosuggestion.enable = true;
    syntaxHighlighting = {
      enable = true;
      styles.cursor = "fg=#ffffff";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "fzf"];
      theme = "simple";
    };
    plugins = [
      {
        name = "dracula/zsh-syntax-highlighting";
        file = "zsh-syntax-highlighting.sh";
        src = pkgs.fetchFromGitHub {
          owner = "dracula";
          repo = "zsh-syntax-highlighting";
          rev = "09c89b657ad8a27ddfe1d6f2162e99e5cce0d5b3";
          sha256 = "sha256-JrSKx8qHGAF0DnSJiuKWvn6ItQHvWpJ5pKo4yNbrHno=";
        };
      }
    ];
  };
}
