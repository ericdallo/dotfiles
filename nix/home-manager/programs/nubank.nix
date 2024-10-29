{ config, lib, pkgs, ... }:

{
  imports = [
    ./vpn.nix
  ];

  home.packages = with pkgs; [
    aws-iam-authenticator
    kubelogin-oidc
    stable.kubectl
    zoom-us
    plantuml
    tektoncd-cli
    stable.yubikey-manager
    stable.yubikey-personalization-gui
    scala
    scalafmt
    mob
    stable.protobuf
    stable.buf
    # (nubank.flutter.override { flutterPackages = stable.flutterPackages; })
  ];
}
