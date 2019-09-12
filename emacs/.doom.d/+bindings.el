;;; ~/.doom.d/+bindings.el -*- lexical-binding: t; -*-

(when (eq system-type 'gnu/linux)
  (setq x-super-keysym 'meta))

(map!
 :gnvime "M-x" #'execute-extended-command
 :gnvime "A-x" #'execute-extended-command

 ;; Window Movements
 "C-h"    #'evil-window-left
 "C-j"    #'evil-window-down
 "C-k"    #'evil-window-up
 "C-l"    #'evil-window-right
 "A-q"    #'delete-window
 "C-`"      #'+popup/toggle
 "<C-tab>"  #'+popup/other
 "C-z"    #'winner-undo

 (:map evil-window-map ; prefix "C-w"
    ;; Navigation
    "C-h"     #'evil-window-left
    "C-j"     #'evil-window-down
    "C-k"     #'evil-window-up
    "C-l"     #'evil-window-right
    "C-w"     #'ace-window
    ;; Swapping windows
    "H"       #'+evil/window-move-left
    "J"       #'+evil/window-move-down
    "K"       #'+evil/window-move-up
    "L"       #'+evil/window-move-right
    "C-S-w"   #'ace-swap-window
    ;; Window undo/redo
    "u"       #'winner-undo
    "C-u"     #'winner-undo
    "C-r"     #'winner-redo
    "o"       #'doom/window-enlargen
    ;; Delete window
    "c"       #'+workspace/close-window-or-workspace
    "C-C"     #'ace-delete-window)
)
