;;; ~/.doom.d/+bindings.el -*- lexical-binding: t; -*-

(when (eq system-type 'gnu/linux)
  (setq x-super-keysym 'meta))

(define-key evil-normal-state-map (kbd "M-r") 'evil-multiedit-match-all)

(map! :nvi

      :desc "Toggle buffer full screen"
      "<f10>" #'toggle-maximize-buffer

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
      "f t" #'find-in-dotfiles

      :desc "Find definition"
      "c d" #'lsp-find-definition

      :desc "Find references"
      "c D" #'lsp-find-references)

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

(after! clojure-mode
  (map! :leader

        :desc "Search for symbol in project excluding test folders"
        "&" (lambda () (interactive) (rg-ignoring-folders (list "test" "postman")))

        :desc "Search for symbol in project excluding src folder"
        "(" (lambda () (interactive) (rg-ignoring-folders (list "src")))))

(after! clj-refactor
  (define-key clj-refactor-map "\C-ctf" #'cljr-thread-first-all)
  (define-key clj-refactor-map "\C-ctl" #'cljr-thread-last-all)
  (define-key clj-refactor-map "\C-cu" #'cljr-unwind)
  (define-key clj-refactor-map "\C-cU" #'cljr-unwind-all))

(after! lsp-ui
  (map! :nvi

        :desc "LSP-ui apply code action"
        "M-[" #'lsp-ui-sideline-apply-code-actions))

(after! dart-server
  (map! :nvi

        :desc "Dart format"
        "M-p" #'dart-server-format))

(after! dart-mode
  (map! :leader

        :desc "Flutter run or hot reload"
        "m k" #'flutter-run-or-hot-reload))
