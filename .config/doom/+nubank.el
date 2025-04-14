;;; ../.dotfiles/.config/doom/+nubank.el -*- lexical-binding: t; -*-

;; Specific configurations for Nubank (work) environment

(let ((nudev-emacs-path "~/dev/nu/nudev/ides/emacs/"))
  (when (file-directory-p nudev-emacs-path)
    (add-to-list 'load-path nudev-emacs-path)
    (require 'nu nil t)))

(add-to-list 'projectile-project-search-path "~/dev/nu/" "~/dev/nu/mini-meta-repo/packages")

(use-package! ellama
  :config
  (setq llm-warn-on-nonfree nil))

(use-package! nu-llm
  :after ellama
  :load-path (lambda () (expand-file-name "nu-llm.el" (getenv "NU_HOME")))
  :config
  ;; Add the Nu OpenAI LLM provider.
  (add-to-list 'ellama-providers (cons "Nu OpenAI" (nu-llm-make-openai)))
  ;; Set the default provider to the one we just added (optional).
  (setq ellama-provider (alist-get "Nu OpenAI" ellama-providers nil nil #'string=)))

(use-package! aidermacs
  :config
  (set-popup-rule! "\\*aidermacs.*\\*" :side 'right :width 0.4)
  (require 'aidermacs-backend-vterm)
  (setq aidermacs-backend 'vterm
        aidermacs-auto-accept-architect t
        aidermacs-use-architect-mode t
        aidermacs-config-file (expand-file-name "nudev/aider/.aider.conf.yml" (getenv "NU_HOME"))))

(after! aidermacs
  (map! :leader

        :desc "Aidermacs"
        "=" #'aidermacs-transient-menu))
