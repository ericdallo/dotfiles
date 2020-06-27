{ pkgs, config, ... }:
let
  dotfilesDir = "$HOME/.dotfiles";

in {
  imports = [
    ./common/programs.nix
    ./common/dconf.nix
  ];

  home = {
    activation.linkFiles = config.lib.dag.entryAfter ["writeBoundary"] ''
        cp -n ${dotfilesDir}/basic/.critical-keys.sample ~/.critical-keys
        ln -sf ${dotfilesDir}/basic/.zsh_aliases ~/.zsh_aliases
        ln -sf ${dotfilesDir}/basic/.frigocenter_aliases ~/.frigocenter_aliases
        ln -sf ${dotfilesDir}/basic/.zshrc ~/.zshrc
        ln -sf ${dotfilesDir}/basic/.functions ~/.functions

        ln -Tsf ${dotfilesDir}/bspwm ~/.config/bspwm
        ln -Tsf ${dotfilesDir}/sxhkd ~/.config/sxhkd
        ln -Tsf ${dotfilesDir}/rofi ~/.config/rofi
        ln -Tsf ${dotfilesDir}/polybar ~/.config/polybar
        ln -Tsf ${dotfilesDir}/.env ~/.env
        ln -Tsf ${dotfilesDir}/dunst ~/.config/dunst
        ln -Tsf ${dotfilesDir}/networkmanager-dmenu ~/.config/networkmanager-dmenu

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

        mkdir -p ~/.android/avd/device.avd
        ln -sf ${dotfilesDir}/nix/android/emulator-config.ini ~/.android/avd/device.avd/config.ini
    '';
  };
}
