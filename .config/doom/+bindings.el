;;; ~/.config/doom/+bindings.el -*- lexical-binding: t; -*-

(when (eq system-type 'gnu/linux)
  (setq x-super-keysym 'meta))

(define-key evil-normal-state-map (kbd "M-r") 'evil-multiedit-match-all)
(define-key evil-normal-state-map (kbd "<tab>") 'evil-jump-item)
(define-key evil-motion-state-map (kbd "] e") #'flycheck-next-error)
(define-key evil-motion-state-map (kbd "[ e") #'flycheck-previous-error)

(with-eval-after-load 'vertico
  (define-key vertico-map (kbd "<next>") #'vertico-scroll-up)
  (define-key vertico-map (kbd "<prior>") #'vertico-scroll-down))

(defun scroll-up-bottom-window ()
  "Scroll up bottom window"
  (interactive)
  (save-selected-window
    (when-let ((bottom-window (-first (lambda (w)
                                        (and (window-full-width-p w)
                                             (not (eq w (get-buffer-window))))) (window-list))))
      (select-window bottom-window)
      (scroll-up-line))))

(defun scroll-down-bottom-window ()
  "Scroll down bottom window"
  (interactive)
  (save-selected-window
    (when-let ((bottom-window (-first (lambda (w)
                                        (and (window-full-width-p w)
                                             (not (eq w (get-buffer-window))))) (window-list))))
      (select-window bottom-window)
      (scroll-down-line))))

(map! :nvi

      :desc "Toggle buffer full screen"
      "<f10>" #'doom/window-maximize-buffer

      :desc "increase window width"
      "C-S-<left>" (lambda () (interactive) (enlarge-window 5 t))

      :desc "decrease window width"
      "C-S-<right>" (lambda () (interactive) (enlarge-window -5 t))

      :desc "increase window height"
      "C-S-<down>" (lambda () (interactive) (enlarge-window 5))

      :desc "decrease window height"
      "C-S-<up>" (lambda () (interactive) (enlarge-window -5))

      :desc "scroll up bottom window"
      "C-S-M-<down>" #'scroll-up-bottom-window

      :desc "scroll down bottom window"
      "C-S-M-<up>" #'scroll-down-bottom-window

      :desc "Expand region"
      "M-=" #'er/expand-region

      :desc "Reverse expand region"
      "M--" (lambda () (interactive) (er/expand-region -1))

      :desc "zone"
      "C-<f12>" #'zone)

(map! :nv
      :desc "Evil multiedit word"
      "M-r" #'evil-multiedit-match-all)

(map! :leader

      :desc "Open dotfiles"
      "f T" #'open-dotfiles

      :desc "Find file in dotfiles"
      "f t" #'find-in-dotfiles

      :desc "Present slide"
      "t p" #'org-present

      :desc "ECA: start/open"
      "e e" #'eca

      :desc "ECA: restart"
      "e E" #'eca-restart

      :desc "ECA: approve tool call"
      "e a" #'eca-chat-tool-call-accept-all

      :desc "ECA: rewrite"
      "e r" #'eca-rewrite)

(map! :i
      :desc "ECA: complete"
      "C-0" (lambda ()
              (interactive)
              (corfu-quit)
              (eca-complete)))

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

        :desc "Backward"
        "C-c <left>" #'paredit-backward

        :desc "Forward"
        "C-c <right>" #'paredit-forward))

(after! clojure-mode
  (define-key lsp-mode-map (kbd "C-M-<up>") #'lsp-clojure-move-coll-entry-up)
  (define-key lsp-mode-map (kbd "C-M-<down>") #'lsp-clojure-move-coll-entry-down)

  (map! :leader

        :desc "Search for symbol in project excluding test folders"
        "&" (lambda () (interactive) (+custom/search-ignoring-folders (list "test" "postman")))

        :desc "Search for symbol in project excluding src folder"
        "(" (lambda () (interactive) (+custom/search-ignoring-folders (list "src")))

        :desc "lsp-clojure cursor info"
        "-" #'lsp-clojure-cursor-info))

(map! :after cider-mode
      :map cider-mode-map
      :localleader

      :desc "Cider eval last sexpr and copy to clipboard"
      "e c" #'cider-eval-last-sexpr-and-copy-to-clipboard)

(map! :after lsp-mode
      :map lsp-mode-map
      :n

      :desc "Start lsp on buffer"
      "M-l" #'lsp

      :leader

      :desc "Format workaround"
      "c f" #'lsp-format-buffer)

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

(map! :after java-mode
      :map java-mode-map
      :localleader

      :desc "Run method test"
      "t" #'dap-java-run-test-method

      :desc "Run class tests"
      "T" #'dap-java-run-test-class)

(defun org-present-bindings-start ()
  (map! :map org-present-mode-keymap

        :desc "Show cursor"
        "C-<up>" #'org-present-show-cursor

        :desc "Hide cursor"
        "C-<down>" #'org-present-hide-cursor

        :desc "Next slide"
        "C-<right>" #'org-present-next

        :desc "Previous slide"
        "C-<left>" #'org-present-prev

        :desc "Next slide controller"
        "<next>" #'org-present-next

        :desc "Previous slide"
        "<prior>" #'org-present-prev))

(defun org-present-bindings-end ()
  (define-key org-present-mode-keymap (kbd "C-<up>") nil)
  (define-key org-present-mode-keymap (kbd "C-<down>") nil)
  (define-key org-present-mode-keymap (kbd "C-<right>") nil)
  (define-key org-present-mode-keymap (kbd "C-<left>") nil)
  (define-key org-present-mode-keymap (kbd "<prior>") nil)
  (define-key org-present-mode-keymap (kbd "<next>") nil))
