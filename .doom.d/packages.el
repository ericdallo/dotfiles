;; -*- no-byte-compile: t; -*-
;;; ~/dev/dotfiles/emacs/.doom.d/packages.el

;; (package! dap-mode :recipe (:local-repo "~/dev/dap-mode" :files ("*.el") :no-byte-compile t))
;; (package! lsp-dart :recipe (:local-repo "~/dev/lsp-dart" :files ("*.el") :build (:not compile)))
;; (package! lsp-mode :recipe (:local-repo "~/dev/lsp-mode" :files ("*.el" "clients/*.el") :build (:not compile)))
;; (package! lsp-ui :recipe (:local-repo "~/dev/lsp-ui" :files ("*.el") :no-byte-compile t))
(package! scss-mode)
(package! treemacs-all-the-icons)
(package! paredit)
(package! posframe)
(package! yaml-mode)

(unpin! hover)
(unpin! treemacs)
(unpin! lsp-treemacs)
(unpin! lsp-mode)
(unpin! lsp-ui)
(unpin! lsp-dart)

;; Temporary
(package! map :pin "bb50dba")
(unpin! iedit)
(unpin! evil-multiedit)
(unpin! evil)
(unpin! cider)
