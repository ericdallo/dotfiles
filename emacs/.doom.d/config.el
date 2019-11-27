;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-

(let ((nudev-emacs-path "~/dev/nu/nudev/ides/emacs/"))
  (when (file-directory-p nudev-emacs-path)
    (add-to-list 'load-path nudev-emacs-path)
    (require 'nu)))

(add-to-list 'default-frame-alist '(fullscreen . maximized))
(add-to-list 'auto-mode-alist '("\\.repl\\'" . clojure-mode))

(setq
 confirm-kill-emacs nil ;; disable confirmation message on exit

 projectile-project-search-path '("~/dev/")

 counsel-rg-base-command "rg -i -M 120 --no-heading --line-number --color never %s ."

 frame-title-format (setq icon-title-format  ;; set window title with "[project] filename"
                          '(""
                            (:eval
                             (format "[%s] " (projectile-project-name)))
                            "%b"))

 doom-font (font-spec :family "Hack" :size 18)
 doom-big-font-increment 4
 doom-unicode-font (font-spec :family "DejaVu Sans")

 evil-collection-setup-minibuffer t ;; enable minibuffer to work correctly in evil mode

 cljr-clojure-test-declaration "[midje.sweet :refer :all]")

(add-hook! 'after-make-frame-functions
  (set-fontset-font t 'unicode
                    (font-spec :family "Font Awesome 5 Free")
                    nil 'append)
  (set-fontset-font t 'unicode
                    (font-spec :family "Font Awesome 5 Brands")
                    nil 'append))

;; Maximize buffer
(defun toggle-maximize-buffer ()
  (interactive)
  (if (= 1 (length (window-list)))
      (jump-to-register '_)
    (progn
      (window-configuration-to-register '_)
      (delete-other-windows))))
(global-set-key (kbd "<f12>") 'toggle-maximize-buffer)

(use-package! flycheck-clj-kondo
  :after clojure-mode
  :config
  (dolist (checkers '((clj-kondo-clj . clojure-joker)
                      (clj-kondo-cljs . clojurescript-joker)
                      (clj-kondo-cljc . clojure-joker)
                      (clj-kondo-edn . edn-joker)))))

(use-package! clj-refactor
  :after clojure-mode
  :init
  (setq cljr-warn-on-eval nil
        cljr-thread-all-but-last t)
  (setq cljr-magic-require-namespaces
        '(("s"   . "schema.core")
          ("th"  . "common-core.test-helpers")
          ("gen" . "common-test.generators")
          ("d-pro" . "common-datomic.protocols.datomic")
          ("ex" . "common-core.exceptions")
          ("dth" . "common-datomic.test-helpers")
          ("t-money" . "common-core.types.money")
          ("d" . "datomic.api")
          ("pp" . "clojure.pprint")
          ("init" . "postmanaux.init"))))

(after! clojure-mode
  (define-clojure-indent
    (fact 1)
    (facts 1)
    (flow 1)
    (fnk 1)
    (provided 1)
    (clojure.test.check/quick-check 2)
    (clojure.test.check.properties/for-all 2)
    (common-datomic.test-helpers/let-entities 2))

  (setq cider-show-error-buffer 'only-in-repl)
  (clj-refactor-mode 1)
  (yas-minor-mode 1) ; for adding require/use/import statements
  (cljr-add-keybindings-with-prefix "C-c C-c")

  (defun reverse-transpose-sexps (arg)
    (interactive "*p")
    (transpose-sexps (- arg))
    (backward-sexp (1+ arg))
    (forward-sexp 1))

  (defun rg-ignoring-folders (folders)
    "ripgrep selected word in project excluding folder"
    (let ((symbol (thing-at-point 'symbol t))
          (args (mapconcat 'identity
                           (mapcar #'(lambda(folder) (concat "-g '!" folder "/*'"))
                                   folders)
                           " ")))
      (counsel-rg symbol (counsel--git-root) args))))

(after! clj-refactor
  (define-key clj-refactor-map "\C-ctf" #'cljr-thread-first-all)
  (define-key clj-refactor-map "\C-ctl" #'cljr-thread-last-all)
  (define-key clj-refactor-map "\C-cu" #'cljr-unwind)
  (define-key clj-refactor-map "\C-cU" #'cljr-unwind-all))

(use-package! paredit
  :hook ((clojure-mode . paredit-mode))
  :config
   (global-unset-key (kbd "M-<left>"))
   (global-unset-key (kbd "M-<right>"))
   (define-key paredit-mode-map (kbd "C-<left>") nil)
   (define-key paredit-mode-map (kbd "C-<right>") nil)
   (define-key paredit-mode-map (kbd "M-<up>") nil)
   (define-key paredit-mode-map (kbd "M-<down>") nil)

   (global-set-key (kbd "M-<up>") 'reverse-transpose-sexps)
   (global-set-key (kbd "M-<down>") 'transpose-sexps)
   (define-key paredit-mode-map (kbd "M-S-<right>") 'paredit-backward-barf-sexp)
   (define-key paredit-mode-map (kbd "M-S-<left>") 'paredit-backward-slurp-sexp)
   (define-key paredit-mode-map (kbd "M-<right>") 'paredit-forward-slurp-sexp)
   (define-key paredit-mode-map (kbd "M-<left>") 'paredit-forward-barf-sexp)
   (define-key paredit-mode-map (kbd "C-c <left>") 'paredit-backward)
   (define-key paredit-mode-map (kbd "C-c <right>") 'paredit-forward))

(use-package! lsp-mode
  :hook ((clojure-mode . lsp))
  :commands lsp
  :init
  (setq lsp-enable-indentation nil
        lsp-print-io t)
  :custom
  ((lsp-clojure-server-command '("bash" "-c" "/home/greg/clojure-lsp/clojure-lsp"))) ;TODO fix to dynamic path

  :config
  (dolist (m '(clojure-mode
               clojurec-mode
               clojurescript-mode
               clojurex-mode))
    (add-to-list 'lsp-language-id-configuration `(,m . "clojure"))))

(use-package! lsp-ui
  :commands lsp-ui-mode)

(use-package! company-lsp
  :commands company-lsp)

;; themes
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (doom-molokai)))
 '(custom-safe-themes
   (quote
    ("f951343d4bbe5a90dba0f058de8317ca58a6822faa65d8463b0e751a07ec887c" "4e132458143b6bab453e812f03208075189deca7ad5954a4abb27d5afce10a9a" "6b2636879127bf6124ce541b1b2824800afc49c6ccd65439d6eb987dbf200c36" "136f5f950d1521f68aa3cfe491fb3e5a572dcaa350827e52c2de58a97beadc3d" "a8c210aa94c4eae642a34aaf1c5c0552855dfca2153fa6dd23f3031ce19453d4" default))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(load! "+bindings")
