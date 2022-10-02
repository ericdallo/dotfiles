{ pkgs, config, ... }:
let
  dotfilesDir = "$HOME/.dotfiles";
in {
  imports = [
    ../configurations/overlays.nix
    ./programs/common.nix
    ./programs/clojure.nix
    ./programs/rust.nix
    ./programs/vscode.nix
    ./programs/android.nix
    ./programs/gregflix.nix
    ./programs/python.nix
    ./programs/games.nix
  ];

  nixpkgs.config.allowUnfree = true;

  home = {
    stateVersion = "21.11";
    packages = with pkgs; [
      alda
      blender
      master.graalvm11-ce
      heroku
      imagemagick
      maven
      mysql
      nodePackages.node2nix
      omnisharp-roslyn
      hugo
      pandoc
      postman
      master.ferdium
      s3cmd
      sass
      sassc
      srt-to-vtt-cl
      teamviewer
      unityhub
      websocat
      dart
      flutter
      hover
      upx
      zoom-us
    ];
    activation.linkFiles = config.lib.dag.entryAfter [ "writeBoundary" ] ''
      cp -n ${dotfilesDir}/.critical-keys.sample ~/.critical-keys

      ln -Tsf ${dotfilesDir}/.config/bspwm ~/.config/bspwm
      ln -Tsf ${dotfilesDir}/.config/sxhkd ~/.config/sxhkd
      ln -Tsf ${dotfilesDir}/.config/rofi ~/.config/rofi
      ln -Tsf ${dotfilesDir}/.config/polybar ~/.config/polybar
      ln -Tsf ${dotfilesDir}/.config/dunst ~/.config/dunst
      ln -Tsf ${dotfilesDir}/.config/nvim ~/.config/nvim
      ln -Tsf ${dotfilesDir}/.config/libinput-gestures.conf ~/.config/libinput-gestures.conf
      ln -Tsf ${dotfilesDir}/.config/clojure ~/.config/clojure
      ln -Tsf ${dotfilesDir}/.config/gdfuse ~/.config/gdfuse
      ln -Tsf ${dotfilesDir}/.config/networkmanager-dmenu ~/.config/networkmanager-dmenu
      ln -sf ${dotfilesDir}/.config/zoomus.conf ~/.config/zoomus.conf
      mkdir -p ~/.config/clojure-lsp
      ln -sf ${dotfilesDir}/.config/clojure-lsp/config.edn ~/.config/clojure-lsp/config.edn

      ln -Tsf ${dotfilesDir}/.doom.d ~/.doom.d

      ln -sf ${dotfilesDir}/.config/Code/User/keybindings.json ~/.config/Code/User/keybindings.json
      ln -sf ${dotfilesDir}/.config/Code/User/settings.json ~/.config/Code/User/settings.json

      mkdir -p ~/.android/avd/device.avd
      ln -sf ${dotfilesDir}/nix/android/emulator-config.ini ~/.android/avd/device.avd/config.ini
    '';
  };
}
