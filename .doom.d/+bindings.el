;;; ~/.doom.d/+bindings.el -*- lexical-binding: t; -*-

(when (eq system-type 'gnu/linux)
  (setq x-super-keysym 'meta))

(define-key evil-normal-state-map (kbd "M-r") 'evil-multiedit-match-all)
(define-key evil-normal-state-map (kbd "<tab>") 'evil-jump-item)

(map! :n

      :desc "Multi edit lines"
      "M-r" #'evil-multiedit-match-all)

(map! :nvi

      :desc "Toggle buffer full screen"
      "<f10>" #'doom/window-maximize-buffer

      :desc "increase window width"
      "C-S-<right>" (lambda () (interactive) (enlarge-window 5 t))

      :desc "decrease window width"
      "C-S-<left>" (lambda () (interactive) (enlarge-window -5 t))

      :desc "increase window height"
      "C-S-<up>" (lambda () (interactive) (enlarge-window 5))

      :desc "decrease window height"
      "C-S-<down>" (lambda () (interactive) (enlarge-window -5))

      :desc "Expand region"
      "M-=" #'er/expand-region

      :desc "Reverse expand region"
      "M--" (lambda () (interactive) (er/expand-region -1)))

(map! :nv
      :desc "Evil multiedit word"
      "M-r" #'evil-multiedit-match-all)

(map! :leader

      :desc "Open dotfiles"
      "f T" #'open-dotfiles

      :desc "Find file in dotfiles"
      "f t" #'find-in-dotfiles)

(after! paredit
  (define-key paredit-mode-map (kbd "C-<left>") nil)
  (define-key paredit-mode-map (kbd "C-<right>") nil)

  (map! :nvi

        :desc "Forward barf"
        "M-<left>" #'paredit-forward-barf-sexp

        :desc "Forward slurp"
        "M-<right>" #'paredit-forward-slurp-sexp

        :desc "Backward slurp"
        "M-S-<left>" #'paredit-backward-slurp-sexp

        :desc "Backward barf"
        "M-S-<right>" #'paredit-backward-barf-sexp

        :desc "Reverse transpose sexps"
        "M-<up>" #'reverse-transpose-sexps

        :desc "Transpose sexps"
        "M-<down>" #'transpose-sexps

        :desc "Backward"
        "C-c <left>" #'paredit-backward

        :desc "Forward"
        "C-c <right>" #'paredit-forward))

(map! :after clojure-mode
      :leader

      :desc "Search for symbol in project excluding test folders"
      "&" (lambda () (interactive) (rg-ignoring-folders (list "test" "postman")))

      :desc "Search for symbol in project excluding src folder"
      "(" (lambda () (interactive) (rg-ignoring-folders (list "src"))))

(after! clj-refactor
  (define-key clj-refactor-map "\C-ctf" #'cljr-thread-first-all)
  (define-key clj-refactor-map "\C-ctl" #'cljr-thread-last-all)
  (define-key clj-refactor-map "\C-cu" #'cljr-unwind)
  (define-key clj-refactor-map "\C-cU" #'cljr-unwind-all))

(map! :after dap-mode
      :map dap-mode-map
      :n

      :desc "DAP step-in"
      "<f4>" #'dap-step-in

      :desc "DAP step-out"
      "<f5>" #'dap-step-out

      :desc "DAP next"
      "<f6>" #'dap-next

      :desc "DAP continue"
      "<f8>" #'dap-continue)

(after! lsp-ui
  (map! :nvi

        :desc "LSP-ui apply code action"
        "M-[" #'lsp-ui-sideline-apply-code-actions))

(map! :leader

      :desc "LSP-treemacs list errors"
      "c X" #'lsp-treemacs-errors-list

      :desc "LSP-treemacs find references"
      "c R" (lambda () (interactive) (lsp-treemacs-references t)))

(map! :after java-mode
      :map java-mode-map
      :localleader

      :desc "Run method test"
      "t" #'dap-java-run-test-method

      :desc "Run class tests"
      "T" #'dap-java-run-test-class)

(map! :after dart-mode
      :map dart-mode-map
      :localleader

      :desc "Flutter run or hot reload"
      "j" #'flutter-run-or-hot-reload

      :desc "Hover run or hot reload"
      "k" #'hover-run-or-hot-reload

      :desc "Hover run or hot restart"
      "K" #'hover-run-or-hot-restart

      :desc "Run current file test"
      "t" #'lsp-dart-run-test-file

      :desc "Run test at point"
      "T" #'lsp-dart-run-test-at-point

      :desc "Run all tests"
      "M-t" #'lsp-dart-run-all-tests)
