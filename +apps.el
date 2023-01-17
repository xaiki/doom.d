;;; +apps.el -*- lexical-binding: t; -*-

(use-package telega
  :load-path  "~/src/telega.el"
  :defer t
  :config
  (setq telega-server-command "~/src/telega.el/server/telega-server")
  (require 'telega-stories)
  (telega-stories-mode 1)
  ;; "Emacs Stories" rootview
  (define-key telega-root-mode-map (kbd "v e") 'telega-view-emacs-stories)
  ;; Doom Dashboard
  (defun telega-dashboard ()
    (telega-stories-dashboard-insert 5))
  (add-to-list 'dashboard-items '(telega-stories . 5))
;;  (add-to-list '+doom-dashboard-functions 'telega-dashboard)
  )
