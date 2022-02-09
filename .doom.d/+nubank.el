;;; ../.dotfiles/.doom.d/+nubank.el -*- lexical-binding: t; -*-

;; Specific configurations for Nubank (work) environment

(let ((nudev-emacs-path "~/dev/nu/nudev/ides/emacs/"))
  (when (file-directory-p nudev-emacs-path)
    (add-to-list 'load-path nudev-emacs-path)
    (require 'nu nil t)
    (require 'nu-datomic-query nil t)))

(add-to-list 'projectile-project-search-path "~/dev/nu/" "~/dev/nu/mini-meta-repo/packages")
