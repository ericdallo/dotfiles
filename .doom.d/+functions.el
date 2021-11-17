;;; ../.dotfiles/.doom.d/+functions.el -*- lexical-binding: t; -*-

(defun rg-ignoring-folders (folders)
  "ripgrep selected word in project excluding folder"
  (let ((symbol (thing-at-point 'symbol t))
        (args (mapconcat 'identity
                         (mapcar #'(lambda(folder) (concat "-g '!" folder "/*'"))
                                 folders)
                         " ")))
    (counsel-rg symbol (counsel--git-root) args)))

(defun lsp-clojure-nrepl-connect ()
  "Connect to the running nrepl debug server of clojure-lsp."
  (interactive)
  (let ((info (lsp-clojure-server-info-raw)))
    (save-match-data
      (when-let (port (and (string-match "\"port\":\\([0-9]+\\)" info)
                           (match-string 1 info)))
        (cider-connect-clj `(:host "localhost"
                             :port ,port))))))

(defun cider-eval-clipboard-handler ()
  (nrepl-make-response-handler
   (current-buffer)
   (lambda (buffer value)
     (with-current-buffer buffer
       (with-temp-buffer
         (insert value)
         (clipboard-kill-region (point-min) (point-max)))))
   (lambda (_buffer out)
     (cider-emit-interactive-eval-output out))
   (lambda (_buffer err)
     (cider-emit-interactive-eval-err-output err))
   '()))

(defun cider-eval-last-sexpr-and-copy-to-clipboard ()
  (interactive)
  (cider-interactive-eval nil
                         (cider-eval-clipboard-handler)
                         (cider-last-sexp 'bounds)
                         (cider--nrepl-pr-request-map)))
