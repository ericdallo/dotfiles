{ pkgs, config, self, ... }:
let
  dotfilesDir = "$HOME/.dotfiles";
in
{
  imports = [
    ../configurations/overlays.nix
    ./programs/common.nix
    ./programs/vscode.nix
    ./programs/clojure.nix
    ./programs/python.nix
    ./programs/android.nix
    ./programs/java.nix
  ];

  nixpkgs.overlays = [
    (import self.inputs.nubank)
  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.android_sdk.accept_license = true;

  home = {
    stateVersion = "22.11";
    packages = with pkgs; [
      aws-iam-authenticator
      awslogs
      master.discord
      fzf
      gcc
      git-lfs
      hashdeep
      kubectl
      master.ferdium
      mob
      maven
      sassc
      stable.yubikey-manager
      stable.yubikey-personalization-gui
      visualvm
      tektoncd-cli
      protobuf
      buf
      xsv
      zoom-us
      insomnia
      nubank.dart
      (nubank.flutter.override { flutterPackages = master.flutterPackages; })
      nubank.hover
    ] ++ nubank.jupyter-tools;

    activation.linkFiles = config.lib.dag.entryAfter [ "writeBoundary" ] ''
      cp -n ${dotfilesDir}/.critical-keys.sample ~/.critical-keys

      ln -sf ${dotfilesDir}/.nubank_aliases ~/.nubank_aliases
      ln -sf ${dotfilesDir}/.nubank_extra ~/.extra

      ln -Tsf ${dotfilesDir}/.config/bspwm ~/.config/bspwm
      ln -Tsf ${dotfilesDir}/.config/sxhkd ~/.config/sxhkd
      ln -Tsf ${dotfilesDir}/.config/rofi ~/.config/rofi
      ln -Tsf ${dotfilesDir}/.config/polybar ~/.config/polybar
      ln -Tsf ${dotfilesDir}/.config/dunst ~/.config/dunst
      ln -Tsf ${dotfilesDir}/.config/libinput-gestures.conf ~/.config/libinput-gestures.conf
      ln -Tsf ${dotfilesDir}/.config/gdfuse ~/.config/gdfuse
      ln -Tsf ${dotfilesDir}/.config/networkmanager-dmenu ~/.config/networkmanager-dmenu
      ln -sf ${dotfilesDir}/.config/zoomus.conf ~/.config/zoomus.conf
      mkdir -p ~/.config/clojure-lsp
      ln -sf ${dotfilesDir}/.config/clojure-lsp/config.edn ~/.config/clojure-lsp/config.edn

      ln -Tsf ${dotfilesDir}/.doom.d ~/.doom.d
      ln -sf ${dotfilesDir}/.midje.clj ~/.midje.clj
    '';
  };
}
