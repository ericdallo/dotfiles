;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-

(let ((nudev-emacs-path "~/dev/nu/nudev/ides/emacs/"))
  (when (file-directory-p nudev-emacs-path)
    (add-to-list 'load-path nudev-emacs-path)
    (require 'nu)))

(add-to-list 'default-frame-alist '(fullscreen . maximized))
(add-to-list 'auto-mode-alist '("\\.repl\\'" . clojure-mode))

(setq-default evil-kill-on-visual-paste nil)

(setq
 confirm-kill-emacs nil ;; disable confirmation message on exit

 projectile-project-search-path '("~/dev/")

 counsel-rg-base-command "rg -i -M 1000 --no-heading --line-number --color never %s ."

 frame-title-format (setq icon-title-format  ;; set window title with "[project] filename"
                          '(""
                            (:eval
                             (format "[%s] " (projectile-project-name)))
                            "%b"))
 company-idle-delay 0
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
        clojure-thread-all-but-last t)
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
  :hook ((clojure-mode . lsp)
         (dart-mode . lsp)
         (java-mode . lsp))
  :commands lsp
  :init
  (setq lsp-enable-indentation nil
        lsp-prefer-flymake nil)
  :custom
  ((lsp-clojure-server-command '("bash" "-c" "clojure-lsp")))

  :config
  (dolist (m '(clojure-mode
               clojurec-mode
               clojurescript-mode
               clojurex-mode))
    (add-to-list 'lsp-language-id-configuration `(,m . "clojure"))))

(use-package! lsp-ui
  :after lsp-mode
  :commands lsp-ui-mode
  :config
  (setq lsp-ui-peek-enable nil)
  (define-key lsp-mode-map (kbd "M-[") 'lsp-ui-sideline-apply-code-actions))

(use-package! company
    :init
    :config
    (setq company-idle-delay 0.02
          company-minimum-prefix-length 4
          company-echo-delay 0
          company-dabbrev-downcase nil
          company-dabbrev-code-everywhere t
          company-dabbrev-code-modes t
          company-dabbrev-code-ignore-case t
          company-tooltip-align-annotations t
          company-transformers '(company-sort-prefer-same-case-prefix)))

(use-package! company-lsp
  :commands company-lsp
  :config
  (setq company-lsp-async t
        ;company-lsp-filter-candidates t
        ;company-lsp-cache-candidates nil
        )
  (push '(company-lsp :with company-yasnippet) company-backends))

(use-package! lsp-java
  :after lsp)

(use-package! dart-mode
  :init
  (setq dart-sdk-path "~/flutter/bin/cache/dark-sdk/"
        lsp-dart-analysis-sdk "~/flutter/bin/cache/dart-sdk/"
        dart-format-on-save t))

(use-package! dart-server
  :bind
  (:map dart-mode-map
    ("M-p" . dart-server-format)))

(use-package! flutter
  :after dart-mode
  :bind (:map dart-mode-map
          ("C-M-x" . #'flutter-run-or-hot-reload))
  :init
  (setq flutter-sdk-path "~/flutter/")) ;TODO after package flutter

(use-package! flutter-l10n-flycheck
  :after flutter
  :config
  (flutter-l10n-flycheck-setup))

(after! projectile
  (add-to-list 'projectile-project-root-files-bottom-up "pubspec.yaml")
  (add-to-list 'projectile-project-root-files-bottom-up "BUILD"))

(load! "+bindings")
