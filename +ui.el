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

(tool-bar-mode -1)
;; (use-package! dashboard
;;   :ensure t
;;   :config
;;   (dashboard-setup-startup-hook))
;;

(setq x-gtk-resize-child-frames 'resize-mode)
(after! mini-frame
        (custom-set-variables
         '(mini-frame-show-parameters
           '((bottom . 10)
             (width . 0.7)
             (left . 0.5)))))

(use-package! nano-theme
  :config
  ;; ; necessary for proper appearance of nano
  (setq doom-theme 'nil)

  (nano-dark)
  (nano-mode))

(use-package! nano-emacs
  :config
  (require 'doom-modeline))
