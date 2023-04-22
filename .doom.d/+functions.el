;;; ../.dotfiles/.doom.d/+functions.el -*- lexical-binding: t; -*-

(defun font-exists-p (font)
  (if (null (x-list-fonts font)) nil t))

(defun +present/org-present-start ()
  (setq header-line-format " ")
  (org-display-inline-images)
  (org-present-hide-cursor)
  (org-present-read-only)
  (visual-fill-column-mode 1)
  (visual-line-mode 1)
  (doom-disable-line-numbers-h)
  (org-present-big)
  (hl-line-mode 0)
  (+modeline-mode 0)
  (org-present-bindings-start))

(defun +present/org-present-prepare-slide (&rest _args)
  (org-overview)
  (org-fold-show-entry)
  (org-fold-show-children)
  (org-fold-show-all))

(defun +present/org-present-end ()
  (setq header-line-format nil)
  (org-remove-inline-images)
  (org-present-small)
  (org-present-show-cursor)
  (org-fold-show-children)
  (visual-fill-column-mode 0)
  (visual-line-mode 0)
  (hl-line-mode 1)
  (+modeline-mode 1)
  (org-present-bindings-end)
  (doom-enable-line-numbers-h)
  (doom/reset-font-size))

(defun +custom/search-ignoring-folders (folders)
  "Search across project excluding FOLDERS."
  (let ((symbol (rxt-quote-pcre (or (doom-thing-at-point-or-region) "")))
        (dir (let ((projectile-project-root nil))
               (if current-prefix-arg
                   (if-let (projects (projectile-relevant-known-projects))
                       (completing-read "Search project: " projects nil t)
                     (user-error "There are no known projects"))
                 (doom-project-root default-directory))))
        (args (mapcar (lambda (folder) (concat "-g !/" folder ""))
                      folders)))
    (+vertico-file-search
      :query (concat symbol " -- " (string-join args " "))
      :in dir)))

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

(defun magit-open-pr-page (target-branch)
  (interactive
   (list (magit-read-branch "Target branch")))
  (let* ((repo (forge-get-repository (forge-current-topic)))
         (branch (magit-get-current-branch))
         (url (format "https://%s/%s/%s/compare/%s...%s"
                      (oref repo githost)
                      (oref repo owner)
                      (oref repo name)
                      target-branch
                      branch)))
    (browse-url url)))
