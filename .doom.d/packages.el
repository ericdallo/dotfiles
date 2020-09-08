;; -*- no-byte-compile: t; -*-
;;; ~/dev/dotfiles/emacs/.doom.d/packages.el

(package! clj-refactor)
(package! clojure-mode)
(package! dap-mode)
;; (package! dap-mode :recipe (:local-repo "~/dev/dap-mode" :files ("*.el") :no-byte-compile t))
(package! dhall-mode)
(package! emidje)
(package! flutter)
(package! flycheck-clojure)
(package! flycheck-package)
(package! hover)
(package! lsp-dart)
;; (package! lsp-dart :recipe (:local-repo "~/dev/lsp-dart" :files ("*.el") :no-byte-compile t))
(package! lsp-java)
(package! lsp-mode)
;; (package! lsp-mode :recipe (:local-repo "~/dev/lsp-mode" :files ("*.el") :no-byte-compile t))
(package! lsp-ui)
;; (package! lsp-ui :recipe (:local-repo "~/dev/lsp-ui" :files ("*.el") :no-byte-compile t))
(package! lsp-treemacs)
(package! scss-mode)
;; (package! treemacs :recipe (:local-repo "~/dev/treemacs" :files (:defaults
;;                                                                  "Changelog.org"
;;                                                                  "icons"
;;                                                                  "src/elisp/treemacs*.el"
;;                                                                  "src/scripts/treemacs*.py"
;;                                                                  "src/extra/treemacs-all-the-icons.el"
;;                                                                  ) :no-byte-compile t))
(package! treemacs-all-the-icons)
(package! paredit)
(package! posframe)
(package! yaml-mode)

(unpin! doom-modeline)
(unpin! treemacs)
(unpin! lsp-treemacs)
(unpin! lsp-mode)
(unpin! (:lang dart))
