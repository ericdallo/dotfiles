{ pkgs, config, ... }:
let
  dotfilesDir = "$HOME/.dotfiles";
in {
  home = {
    packages = with pkgs; [
      fzf
      gcc
      xsv
      git-lfs
    ];

    activation.linkFiles = config.lib.dag.entryAfter ["writeBoundary"] ''
        cp -n ${dotfilesDir}/basic/.critical-keys.sample ~/.critical-keys
        ln -sf ${dotfilesDir}/basic/.zsh_aliases ~/.zsh_aliases
        ln -sf ${dotfilesDir}/basic/.nubank_aliases ~/.nubank_aliases
        ln -sf ${dotfilesDir}/basic/.zshrc ~/.zshrc
        ln -sf ${dotfilesDir}/basic/.nubank_extra ~/.extra
        ln -sf ${dotfilesDir}/basic/.functions ~/.functions
        ln -sf ${dotfilesDir}/basic/.Xmodmap ~/.Xmodmap

        ln -Tsf ${dotfilesDir}/emacs/.doom.d ~/.doom.d
        ln -Tsf ${dotfilesDir}/emacs/.lsp ~/.lsp
        ln -Tsf ${dotfilesDir}/emacs/.clj-kondo ~/.clj-kondo
        ln -sf ${dotfilesDir}/emacs/.joker ~/.joker
        ln -Tsf ${dotfilesDir}/emacs/.jokerd ~/.jokerd
        ln -sf ${dotfilesDir}/emacs/.midje ~/.midje

        ln -sf ${dotfilesDir}/git/.gitconfig ~/.gitconfig
        ln -sf ${dotfilesDir}/git/.gitignore_global ~/.gitignore_global

        ln -sf ${dotfilesDir}/tmux/.tmux.conf ~/.tmux.conf
        ln -Tsf ${dotfilesDir}/tmux/.tmuxinator ~/.tmuxinator

        ln -sf ${dotfilesDir}/vim/.vimrc ~/.vimrc

        ln -sf ${dotfilesDir}/urxvt/.Xresources ~/.Xresources
    '';
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
    };

    vim = {
      enable = true;
      plugins = [ ];
    };
  };
}
