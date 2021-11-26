{ pkgs, ... }:

{
  home.packages = with pkgs; [
    (clojure.override { jdk = jdk11; })
    clojure-lsp
    babashka
    clj-kondo
    polylith
    (leiningen.override { jdk = jdk11; })
    neil
    master.jet
  ];

  # xdg.configFile."clojure/deps.edn".source = ../../../.config/clojure/deps.edn;
}
