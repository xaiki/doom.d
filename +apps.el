;;; +apps.el -*- lexical-binding: t; -*-

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; TELEGRAM                                                               ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package telega
  :load-path  "~/src/telega.el"
  :defer t
  :config
  (setq telega-server-libs-prefix (expand-file-name "~/.local/"))
  ;;  (setq telega-use-docker "podman")
  (require 'telega-stories)
  (telega-stories-mode 1)
  ;; "Emacs Stories" rootview
  (define-key telega-root-mode-map (kbd "v e") 'telega-view-emacs-stories)
  ;; Doom Dashboard
  (defun telega-dashboard ()
    (telega-stories-dashboard-insert 5))
  (add-to-list 'dashboard-items '(telega-stories . 5))
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MASTODON                                                               ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package! mastodon
  :config
  (setq mastodon-instance-url "https://kolektiva.social"
        mastodon-active-user "xaiki"))

(use-package! mastodon-alt
  :after mastodon
  :init
  (mastodon-alt-tl-activate))
