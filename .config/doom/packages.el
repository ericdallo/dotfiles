;; -*- no-byte-compile: t; -*-
;;; ~/dev/dotfiles/emacs/.config/doom/packages.el

;; Local packages that I maintain
;; (package! lsp-dart :recipe (:local-repo "~/dev/lsp-dart" :files ("*.el") :build (:not compile)))
;; (package! lsp-mode :recipe (:local-repo "~/dev/lsp-mode" :files ("*.el" "clients/*.el") :build (:not compile)))
;; (package! jet :recipe (:local-repo "~/dev/jet.el" :files ("*.el") :build (:not compile)))
(package! eca :recipe (:local-repo "~/dev/eca-emacs" :files ("*.el") :build (:not compile)))

;; (package! eca)
;; (unpin! lsp-mode)

(package! scss-mode)
(package! treemacs-all-the-icons)
(package! paredit)
(package! posframe)
(package! yaml-mode)
(package! org-present)
(package! visual-fill-column)

(unpin! hover)
(unpin! treemacs)
(unpin! lsp-treemacs)
(unpin! lsp-ui)
(unpin! lsp-dart)

;; Temporary / bugs that maybe are already fixed
(package! map :pin "bb50dba")
(unpin! iedit)
(unpin! evil-multiedit)
(unpin! evil)
;; (unpin! cider)
