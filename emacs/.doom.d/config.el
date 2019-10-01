;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here
(add-to-list 'default-frame-alist '(fullscreen . maximized))
(add-to-list 'auto-mode-alist '("\\.repl\\'" . clojure-mode))

;; disable confirmation message on exit
(setq confirm-kill-emacs nil)

;; set window title with "[project] filename"
(setq frame-title-format
    (setq icon-title-format
          '(""
            (:eval
              (format "[%s] " (projectile-project-name)))
            "%b")))

;; font
(setq doom-font (font-spec :family "Hack" :size 18)
      doom-big-font-increment 4
      doom-unicode-font (font-spec :family "DejaVu Sans"))

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

;; clojure-mode
(with-eval-after-load 'clojure-mode
  (define-clojure-indent
  (fact 1)
  (facts 1)
  (flow 1)))

;; clj-refactor
;(setq cljr-inject-dependencies-at-jack-in nil)
;(setq cljr-warn-on-eval nil)
;(setq cljr-ignore-analyzer-errors t)
(defun my-clojure-mode-hook ()
  (setq cljr-warn-on-eval nil
        ;cljr-eagerly-build-asts-on-startup nil
        ;cljr-inject-dependencies-at-jack-in nil
        cider-show-error-buffer 'only-in-repl)
  (clj-refactor-mode 1)
  (yas-minor-mode 1) ; for adding require/use/import statements
    ;; This choice of keybinding leaves cider-macroexpand-1 unbound
  (cljr-add-keybindings-with-prefix "C-c C-c"))
(add-hook 'clojure-mode-hook #'my-clojure-mode-hook)

(setq cljr-clojure-test-declaration
      "[midje.sweet :refer :all]")

(with-eval-after-load 'clj-refactor
  (setq cljr-thread-all-but-last t)
  (dolist (mapping '(("s"   . "schema.core")
                   ("th"  . "common-core.test-helpers")
                   ("gen" . "common-test.generators")
                   ("d-pro" . "common-datomic.protocols.datomic")
                   ("ex" . "common-core.exceptions")
                   ("dth" . "common-datomic.test-helpers")
                   ("t-money" . "common-core.types.money")
                   ("d" . "datomic.api")
                   ("init" . "postmanaux.init")))
    (add-to-list 'cljr-magic-require-namespaces mapping t))

  (define-key clj-refactor-map "\C-ctf" #'cljr-thread-first-all)
  (define-key clj-refactor-map "\C-ctl" #'cljr-thread-last-all)
  (define-key clj-refactor-map "\C-cu" #'cljr-unwind)
  (define-key clj-refactor-map "\C-cU" #'cljr-unwind-all))

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
