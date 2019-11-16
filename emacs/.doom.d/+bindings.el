;;; ~/.doom.d/+bindings.el -*- lexical-binding: t; -*-

(when (eq system-type 'gnu/linux)
  (setq x-super-keysym 'meta))

(map! :leader

      :desc "Search for symbol in project excluding test folder"
      "&" #'rg-ignoring-folder)

;; Expand-region
(global-set-key (kbd "M-=") 'er/expand-region)
(global-set-key (kbd "M--") (lambda () (interactive) (er/expand-region -1)))

(define-key evil-normal-state-map (kbd "M-r") 'evil-multiedit-match-all)
