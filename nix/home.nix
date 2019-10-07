{ pkgs, ... }:
let
  dotfilesDir = ~/dev/dotfiles;
in {
  home = {

    sessionVariables = {
      DOTFILES_DIR = dotfilesDir;
    };

    file = {
      # Critical keys
      # ".critical-keys".source = dotfilesDir + /basic/.critical-keys.sample;

      # Doom
      ".doom.d".source = dotfilesDir + /emacs/.doom.d;

      # Functions
      ".functions".source = dotfilesDir + /basic/.functions;

      # Gregflix
      ".gregflix-functions".source = dotfilesDir + /gregflix/.tmdb-functions;
      ".tmdb-functions".source = dotfilesDir + /gregflix/.gregflix-functions;

      # Joker
      ".joker".source = dotfilesDir + /emacs/.joker;
      ".jokerd".source = dotfilesDir + /emacs/.jokerd;

      # Tmux
      ".tmux.conf".source = dotfilesDir + /tmux/.tmux.conf;
      ".tmuxinator".source = dotfilesDir + /tmux/.tmuxinator;

      # Vim
      ".vimrc".source = dotfilesDir + /vim/.vimrc;

      # VScode
      ".config/Code/User/keybindings.json".source = dotfilesDir + /vscode/keybindings.json;
      ".config/Code/User/settings.json".source = dotfilesDir + /vscode/settings.json;

      # Zsh
      ".zsh_aliases".source = dotfilesDir + /basic/.zsh_aliases;
      ".zshrc".source = dotfilesDir + /basic/.zshrc;
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.home-manager.path = https://github.com/rycee/home-manager/archive/master.tar.gz;

  programs = {

    emacs = {
      enable = true;
    };

    git = {
      enable = true;

      package = pkgs.gitAndTools.hub;

      includes = [
        { path = "${dotfilesDir}/git/.gitconfig"; }
      ];

    };

    vim = {
      enable = true;
      plugins = [  ];
    };
  };
}
