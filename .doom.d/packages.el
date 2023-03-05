;; -*- no-byte-compile: t; -*-
;;; ~/dev/dotfiles/emacs/.doom.d/packages.el

;; (package! lsp-dart :recipe (:local-repo "~/dev/lsp-dart" :files ("*.el") :build (:not compile)))
;; (package! lsp-mode :recipe (:local-repo "~/dev/lsp-mode" :files ("*.el" "clients/*.el") :build (:not compile)))
;; (package! jet :recipe (:local-repo "~/dev/jet.el" :files ("*.el") :build (:not compile)))
(package! scss-mode)
(package! treemacs-all-the-icons)
(package! paredit)
(package! posframe)
(package! yaml-mode)
(package! company-quickhelp)
(package! org-present)
(package! visual-fill-column)

(unpin! hover)
(unpin! treemacs)
(unpin! lsp-treemacs)
;; (unpin! lsp-mode)
(unpin! lsp-ui)
(unpin! lsp-dart)

;; Temporary
(package! map :pin "bb50dba")
(unpin! iedit)
(unpin! evil-multiedit)
(unpin! evil)
(unpin! cider)
