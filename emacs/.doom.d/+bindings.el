;;; ~/.doom.d/+bindings.el -*- lexical-binding: t; -*-

(when (eq system-type 'gnu/linux)
  (setq x-super-keysym 'meta))

(map! :leader

      :desc "Search for symbol in project excluding test folder"
      "&" #'rg-ignoring-folder)
