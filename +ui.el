;;; +ui.el -*- lexical-binding: t; -*-

(use-package! ido
  :config
  (setq ido-enter-matching-directory 'first)
  (setq ido-default-buffer-method 'selected-window
        ido-default-file-method 'selected-window
        ido-enable-flex-matching t
        ido-case-fold t) ; case insensitive matching
  (setq ido-use-filename-at-point 'guess)
  (ido-mode 'both)                            ; Interactively Do Things
  (global-set-key "" 'ido-find-file)
  )

;; (use-package! dashboard
;;   :ensure t
;;   :config
;;   (dashboard-setup-startup-hook))
