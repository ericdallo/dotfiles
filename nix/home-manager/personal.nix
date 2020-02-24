{ pkgs, config, ... }:
let
  dotfilesDir = "$HOME/.dotfiles";
in {
  dconf.settings = {
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/"
      ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "terminal";
      command = "urxvt";
      binding = "<Alt>t";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      name = "lock";
      command = "i3lock-fancy -f Roboto-Medium";
      binding = "<Alt>l";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
      name = "nautilius";
      command = "nautilus";
      binding = "<Alt>q";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
      name = "swith-workspace";
      command = "bash -c \"~/.dotfiles/scripts/alternate-desktop.sh\"";
      binding = "<Alt>backslash";
    };
  };

  home = {
    activation.linkFiles = config.lib.dag.entryAfter ["writeBoundary"] ''
        cp -n ${dotfilesDir}/basic/.critical-keys.sample ~/.critical-keys
        ln -sf ${dotfilesDir}/basic/.zsh_aliases ~/.zsh_aliases
        ln -sf ${dotfilesDir}/basic/.frigocenter_aliases ~/.frigocenter_aliases
        ln -sf ${dotfilesDir}/basic/.zshrc ~/.zshrc
        ln -sf ${dotfilesDir}/basic/.functions ~/.functions
        ln -sf ${dotfilesDir}/basic/.Xmodmap ~/.Xmodmap

        ln -Tsf ${dotfilesDir}/emacs/.doom.d ~/.doom.d
        ln -Tsf ${dotfilesDir}/emacs/.lsp ~/.lsp
        ln -Tsf ${dotfilesDir}/emacs/.clj-kondo ~/.clj-kondo
        ln -sf ${dotfilesDir}/emacs/.joker ~/.joker
        ln -Tsf ${dotfilesDir}/emacs/.jokerd ~/.jokerd

        ln -sf ${dotfilesDir}/git/.gitconfig ~/.gitconfig
        ln -sf ${dotfilesDir}/git/.gitignore_global ~/.gitignore_global

        ln -sf ${dotfilesDir}/gregflix/.tmdb-functions ~/.tmdb-functions
        ln -sf ${dotfilesDir}/gregflix/.gregflix-functions ~/.gregflix-functions
        ln -sf ${dotfilesDir}/gregflix/.s3cfg ~/.s3cfg

        ln -sf ${dotfilesDir}/tmux/.tmux.conf ~/.tmux.conf
        ln -Tsf ${dotfilesDir}/tmux/.tmuxinator ~/.tmuxinator

        ln -sf ${dotfilesDir}/vim/.vimrc ~/.vimrc

        ln -sf ${dotfilesDir}/vscode/keybindings.json ~/.config/Code/User/keybindings.json
        ln -sf ${dotfilesDir}/vscode/settings.json ~/.config/Code/User/settings.json

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
