;; -*- no-byte-compile: t; -*-
;;; ~/dev/dotfiles/emacs/.doom.d/packages.el

;; (package! dap-mode :recipe (:local-repo "~/dev/dap-mode" :files ("*.el") :no-byte-compile t))
(package! dhall-mode)
(package! emidje)
(package! flycheck-package)
;; (package! lsp-dart :recipe (:local-repo "~/dev/lsp-dart" :files ("*.el") :no-byte-compile t))
;; (package! lsp-mode :recipe (:local-repo "~/dev/lsp-mode" :files ("*.el") :no-byte-compile t))
;; (package! lsp-ui :recipe (:local-repo "~/dev/lsp-ui" :files ("*.el") :no-byte-compile t))
(package! scss-mode)
(package! treemacs-all-the-icons)
(package! paredit)
(package! posframe)
(package! yaml-mode)

(unpin! hover)
(unpin! doom-modeline)
(unpin! treemacs)
(unpin! lsp-treemacs)
(unpin! lsp-mode)
(unpin! lsp-ui)
(unpin! lsp-dart)
