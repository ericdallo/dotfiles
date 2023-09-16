{ pkgs, ... }:

{
  home.packages = with pkgs; [
    (clojure.override { jdk = jdk17; })
    clojure-lsp
    babashka
    clj-kondo
    polylith
    (leiningen.override { jdk = jdk17; })
    neil
    master.jet
  ];

  # xdg.configFile."clojure/deps.edn".source = ../../../.config/clojure/deps.edn;
}
