;;; +org.el -*- lexical-binding: t; -*-

(use-package! org-outer-indent)
(use-package! svg-tag-mode
  :config
(require 'svg-tag-mode)

(defvar my/org-imenu-filter-history
  '("BINDING" "HOOK" "ADVICE" "FACE" "MODE" "DEFER"
    "PERSONAL" "INACTIVE" "BUGFIX" "OTHER" "TIMER" "OS")
  "Filter history list.")

(defvar my/org-imenu-filter-function
  (cdr (org-make-tags-matcher "*"))
  "Filter function to decide if a headline is kept")

(defun my/org-imenu-filter ()
  "Define and apply a new filter"

  (interactive)
  (let* ((match (completing-read-multiple
                 "FILTER: "
                 my/org-imenu-filter-history
                 nil nil nil
                 'my/org-imenu-filter-history))
         (match (mapconcat #'identity match " ")))
    (when (string= "" match)
      (setq match "*"))
    (setq my/org-imenu-filter-function
          (cdr (org-make-tags-matcher match)))
    (imenu-list-refresh)))


(defun my/org-imenu-filter-tree (&optional bound parent-match)
  "Build a imenu list using current filter function"

  (let* ((headlines '()))
    (save-excursion
      (org-with-wide-buffer
       (unless bound
         (setq bound (point-max))
         (goto-char (point-min)))
       (while (re-search-forward org-heading-regexp bound t)
         (let* ((element (org-element-at-point))
                (begin (org-element-property :begin element))
                (end (org-element-property :end element))
                (marker (copy-marker begin))
                (level (org-element-property :level element))
                (tags (save-excursion
                         (goto-char begin)
                          (org-get-tags)))
                (match (save-excursion
                         (goto-char begin)
                         (funcall my/org-imenu-filter-function
                                  nil (org-get-tags) level)))

                (title (org-element-property :raw-value element))
                (title (org-link-display-format
                        (substring-no-properties title)))
                (title (propertize title 'org-imenu-marker marker
                                         'org-imenu t))
                (title (if (member "INACTIVE" tags)
                           (propertize title 'face 'nano-faded)
                         title))
                (svg-tags (mapconcat #'(lambda (tag)
                                     (propertize tag 'display (svg-tag-make tag :face 'nano-faded)))
                                 tags " "))
                (title (if tags (format "%s %s" title svg-tags) title))
                (title (propertize title 'marker marker))
                (children (my/org-imenu-filter-tree end match)))
           (goto-char end)

           (cond ((> level org-imenu-depth)
                  nil)
                 ((> (length children) 0)
                  (add-to-list 'headlines (append (list title) children) t))
                 ((or match parent-match)
                  (add-to-list 'headlines (cons title marker) t)))))))
    headlines))

(advice-add #'org-imenu-get-tree :override #'my/org-imenu-filter-tree)
  )
