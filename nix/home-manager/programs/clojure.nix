{ pkgs, ... }:

{
  home.packages = with pkgs; [
    clojure
    clojure-lsp
    babashka
    clj-kondo
    polylith
    # override
    neil
    master.jet
  ];

  # xdg.configFile."clojure/deps.edn".source = ../../../.config/clojure/deps.edn;
}
