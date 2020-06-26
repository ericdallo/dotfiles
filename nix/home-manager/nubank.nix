{ pkgs, config, ... }:
let
  dotfilesDir = "$HOME/.dotfiles";
in {
  imports = [
    ./common/programs.nix
    ./common/dconf.nix
  ];

  nixpkgs.config.allowUnfree = true;

  home = {
    packages = with pkgs; [
      discord
      fzf
      gcc
      git-lfs
      xsv
      zoom-us
    ];

    activation.linkFiles = config.lib.dag.entryAfter ["writeBoundary"] ''
        cp -n ${dotfilesDir}/basic/.critical-keys.sample ~/.critical-keys
        ln -sf ${dotfilesDir}/basic/.zsh_aliases ~/.zsh_aliases
        ln -sf ${dotfilesDir}/basic/.nubank_aliases ~/.nubank_aliases
        ln -sf ${dotfilesDir}/basic/.zshrc ~/.zshrc
        ln -sf ${dotfilesDir}/basic/.nubank_extra ~/.extra
        ln -sf ${dotfilesDir}/basic/.functions ~/.functions

        ln -sf ${dotfilesDir}/rofi/config.rasi ~/.config/rofi/config.rasi
        ln -sf ${dotfilesDir}/networkmanager-dmenu/config.ini ~/.config/networkmanager-dmenu/config.ini

        ln -Tsf ${dotfilesDir}/emacs/.doom.d ~/.doom.d
        ln -Tsf ${dotfilesDir}/emacs/.lsp ~/.lsp
        ln -Tsf ${dotfilesDir}/emacs/.clj-kondo ~/.clj-kondo
        ln -sf ${dotfilesDir}/emacs/.joker ~/.joker
        ln -Tsf ${dotfilesDir}/emacs/.jokerd ~/.jokerd
        ln -sf ${dotfilesDir}/emacs/.midje.clj ~/.midje.clj

        ln -sf ${dotfilesDir}/git/.gitconfig ~/.gitconfig
        ln -sf ${dotfilesDir}/git/.gitignore_global ~/.gitignore_global

        ln -sf ${dotfilesDir}/tmux/.tmux.conf ~/.tmux.conf
        ln -Tsf ${dotfilesDir}/tmux/.tmuxinator ~/.tmuxinator

        ln -sf ${dotfilesDir}/vim/.vimrc ~/.vimrc

        ln -sf ${dotfilesDir}/urxvt/.Xresources ~/.Xresources
    '';
  };
}
