{ pkgs, ... }:

let
  nixpkgsUnstable = import <nixpkgs-unstable> {};
in {
  home.packages = with pkgs; [
    clojure
    nixpkgsUnstable.clojure-lsp
    nixpkgsUnstable.babashka
    nixpkgsUnstable.clj-kondo
    (leiningen.override { jdk = jdk11; })

  ];

  # xdg.configFile."clojure/deps.edn".source = ../../../.config/clojure/deps.edn;
}
