{ pkgs, ... }:

{
  home.packages = with pkgs; [
    clojure
    clojure-lsp
  ];

  # xdg.configFile."clojure/deps.edn".source = ../../../.config/clojure/deps.edn;
}
