;;; ~/.config/doom/config.el -*- lexical-binding: t; -*-

;; Emacs 29 bug
(general-auto-unbind-keys :off)
(remove-hook 'doom-after-init-modules-hook #'general-auto-unbind-keys)

(add-to-list 'default-frame-alist '(fullscreen . maximized))
(add-to-list 'auto-mode-alist '("\\.repl\\'" . clojure-mode))
(add-to-list 'auto-mode-alist '("\\.ect\\'" . html-mode))
(add-to-list 'auto-mode-alist '("\\.ejs\\'" . html-mode))
(add-to-list 'auto-mode-alist '("\\.xtend\\'" . java-mode))
(add-hook 'html-mode-hook #'turn-off-auto-fill)
(add-hook 'markdown-mode-hook #'turn-off-auto-fill)

(setq-default evil-kill-on-visual-paste nil)

(setq
 history-length 300
 confirm-kill-emacs nil
 mode-line-default-help-echo nil
 show-help-function nil
 compilation-scroll-output 'first-error

 x-select-request-type 'text/plain\;charset=utf-8 ;; fix wayland clipboard paste

 read-process-output-max (* 1024 1024)

 projectile-project-search-path '("~/dev/")
 projectile-enable-caching nil

 evil-split-window-below t
 evil-vsplit-window-right t

 doom-font (font-spec :family "Hack" :size 18)
 doom-unicode-font (font-spec :size 18)
 doom-big-font-increment 2

 doom-theme 'doom-dracula
 doom-themes-treemacs-theme "all-the-icons"
 doom-localleader-key ","

 +format-on-save-enabled-modes '(dart-mode)

 treemacs-width-is-initially-locked nil
 evil-collection-setup-minibuffer t
 org-directory "~/google-drive/Notes")

(set-popup-rule! "\\*Treemacs-Scoped.*\\*" :side 'left :width 0.2) ;; Fix treemacs opening on bottom

(use-package! cider
  :after clojure-mode
  :config
  (setq cider-show-error-buffer t ;'only-in-repl
        cider-font-lock-dynamically nil ; use lsp semantic tokens
        cider-eldoc-display-for-symbol-at-point nil ; use lsp
        cider-prompt-for-symbol nil
        cider-reuse-dead-repls nil
        cider-use-xref nil) ; use lsp
  (set-lookup-handlers! '(cider-mode cider-repl-mode) nil) ; use lsp
  (set-popup-rule! "*cider-test-report*" :side 'right :width 0.4)
  (set-popup-rule! "^\\*cider-repl" :side 'bottom :quit nil)
  ;; use lsp completion
  (add-hook 'cider-mode-hook (lambda () (remove-hook 'completion-at-point-functions #'cider-complete-at-point))))

(use-package! clj-refactor
  :after clojure-mode
  :config
  (set-lookup-handlers! 'clj-refactor-mode nil)
  (setq cljr-warn-on-eval nil
        cljr-eagerly-build-asts-on-startup nil
        cljr-add-ns-to-blank-clj-files nil ; use lsp
        cljr-magic-require-namespaces
        '(("s"   . "schema.core")
          ("gen" . "common-test.generators")
          ("d-pro" . "common-datomic.protocols.datomic")
          ("ex" . "common-core.exceptions.core")
          ("dth" . "common-datomic.test-helpers")
          ("t-money" . "common-core.types.money")
          ("t-time" . "common-core.types.time")
          ("d" . "datomic.api")
          ("m" . "matcher-combinators.matchers")
          ("pp" . "clojure.pprint"))))

(use-package! clojure-mode
  :config
  (setq clojure-indent-style 'align-arguments))

(use-package! company
  :config
  (setq company-tooltip-align-annotations t
        company-frontends '(company-pseudo-tooltip-frontend)))

(use-package! company-quickhelp
  :init
  (company-quickhelp-mode)
  :config
  (setq company-quickhelp-delay nil
        company-quickhelp-use-propertized-text t
        company-quickhelp-max-lines 10))

(use-package! dap-mode
  :init
  (require 'dap-chrome)
  (require 'dap-cpptools)
  :config
  (setq dap-enable-mouse-support nil)
  (set-popup-rule! "\\*dap-ui-locals\\*" :side 'right :width 0.3)
  (set-popup-rule! "\\*dap-ui-sessions\\*" :side 'right :width 0.3))

(use-package! hover
  :after dart-mode
  :config
  (setq hover-hot-reload-on-save t
        hover-clear-buffer-on-hot-restart t
        hover-screenshot-path "$HOME/Pictures"))

(defvar use-local-dart nil)

(use-package! lsp-dart
  :after dart-mode
  :config
  (setq lsp-dart-dap-flutter-hot-reload-on-save t)
  (when use-local-dart
    (setq lsp-dart-sdk-dir (expand-file-name "~/flutter/bin/cache/dart-sdk")
          lsp-dart-flutter-sdk-dir (expand-file-name "~/flutter")))
  (set-popup-rule! "\\*LSP Dart tests\\*" :height 0.3))

(use-package! lsp-java
  :after java-mode
  :config
  (setq lsp-java-references-code-lens-enabled t
        lsp-java-implementations-code-lens-enabled t))

(after! lsp-java
  (defun lsp-java--ls-command ()
    (list "jdtls"
          "-configuration" "../config-linux"
          "-data" "../java-workspace")))

(use-package! lsp-mode
  :commands lsp
  :config

  ;; Core
  (setq lsp-headerline-breadcrumb-enable nil
        lsp-signature-render-documentation nil
        lsp-signature-function 'lsp-signature-posframe
        lsp-signature-auto-activate nil
        lsp-semantic-tokens-enable t
        lsp-copilot-enabled t
        lsp-enable-indentation nil
        lsp-inlay-hint-enable t
        lsp-idle-delay 0.05 ;; Smoother LSP features response in cost of performance (Most servers I use have good performance)
        lsp-use-plists nil)
  (add-hook 'lsp-after-apply-edits-hook (lambda (&rest _) (save-buffer)))
  (add-hook 'lsp-mode-hook (lambda () (setq-local company-format-margin-function #'company-vscode-dark-icons-margin)))

  ;; C#
  (when-let ((omnisharp-path (-some-> (executable-find "omnisharp") file-chase-links file-name-directory directory-file-name file-name-directory)))
    (setq lsp-csharp-server-install-dir omnisharp-path
          lsp-csharp-server-path (f-join omnisharp-path "bin/omnisharp")))

  ;; Clojure
  (let ((clojure-lsp-dev (expand-file-name "~/dev/clojure-lsp/clojure-lsp")))
    (when (file-exists-p clojure-lsp-dev)
      ;; clojure-lsp local development
      (setq lsp-clojure-custom-server-command `("bash" "-c" ,clojure-lsp-dev)
            lsp-completion-no-cache t
            lsp-completion-use-last-result nil)))

  ;; Rust
  (setq lsp-rust-analyzer-server-display-inlay-hints t
        lsp-rust-analyzer-display-parameter-hints t
        lsp-rust-analyzer-display-chaining-hints t))

(use-package! lsp-treemacs
  :config
  (setq lsp-treemacs-error-list-current-project-only t))

(use-package! lsp-ui
  :after lsp-mode
  :commands lsp-ui-mode
  :config
  (setq lsp-ui-doc-enable nil
        lsp-ui-peek-enable nil))

(use-package! org-present
  :init
  (add-hook 'org-present-mode-hook '+present/org-present-start)
  (add-hook 'org-present-mode-quit-hook '+present/org-present-end)
  (add-hook 'org-present-after-navigate-functions '+present/org-present-prepare-slide)
  :config
  (setq visual-fill-column-width 150
        visual-fill-column-center-text t)
  (define-key org-present-mode-keymap (kbd "<right>") nil)
  (define-key org-present-mode-keymap (kbd "<left>") nil))

(use-package! paredit
  :hook ((clojure-mode . paredit-mode)
         (emacs-lisp-mode . paredit-mode)))

(use-package! treemacs-all-the-icons
  :after treemacs)

;; (setq projectile-project-root-functions '(projectile-root-local
;;                                           projectile-root-top-down
;;                                           projectile-root-top-down-recurring
;;                                           projectile-root-bottom-up))

;; (after! projectile
;;   (add-to-list 'projectile-project-root-files-bottom-up "pubspec.yaml")
;;   (add-to-list 'projectile-project-root-files-bottom-up "BUILD")
;;   (add-to-list 'projectile-project-root-files-bottom-up "project.clj"))

(put 'narrow-to-region 'disabled nil)

(def-modeline-var! +modeline-modes ; remove minor modes
  '(""
    mode-line-process
    "%n"))

(def-modeline! :main
  '(""
    +modeline-matches
    " "
    +modeline-buffer-identification
    +modeline-position)
  `(""
    mode-line-misc-info
    +modeline-modes
    "  "
    (+modeline-checker ("" +modeline-checker "    "))))

(set-modeline! :main 'default)

(load! "+bindings")
(load! "+functions")
(load! "+nubank")
