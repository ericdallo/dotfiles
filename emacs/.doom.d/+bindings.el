;;; ~/.doom.d/+bindings.el -*- lexical-binding: t; -*-

(when (eq system-type 'gnu/linux)
  (setq x-super-keysym 'meta))

(map! :leader

      :desc "open dotfiles"
      "f T" #'open-dotfiles

      :desc "find file in dotfiles"
      "f t" #'find-in-dotfiles

      :desc "Find references"
      "c D" #'lsp-find-references)

(after! clojure-mode
  (map! :leader

        :desc "Search for symbol in project excluding test folders"
        "&" (lambda () (interactive) (rg-ignoring-folders (list "test" "postman")))

        :desc "Search for symbol in project excluding src folder"
        "(" (lambda () (interactive) (rg-ignoring-folders (list "src")))))

;; Expand-region
(global-set-key (kbd "M-=") 'er/expand-region)
(global-set-key (kbd "M--") (lambda () (interactive) (er/expand-region -1)))

(define-key evil-normal-state-map (kbd "M-r") 'evil-multiedit-match-all)
