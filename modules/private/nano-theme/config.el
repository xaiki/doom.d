;;; private/nano-theme/config.el -*- lexical-binding: t; -*-

;; https://github.com/skyler544/doom-nano-testing/blob/main/load-nano.el

(use-package! nano-layout
  :config

  ;; ; necessary for proper appearance of nano
  (setq doom-theme 'nil)

  (require 'nano-base-colors)
  (require 'nano-faces)
  (require 'nano-defaults)
  (require 'nano-colors)

  (require 'nano-theme-light)
  (require 'nano-theme-dark)
  (require 'nano-theme)
  (require 'nano-help)
  (require 'nano-modeline)
  ;;(require 'nano-session)
  ;;(require 'nano-bindings)
  ;;(require 'nano-counsel)
  ;;(require 'nano-command)
  (require 'nano-writer)

  (when (modulep! +minibuffer)
    (require 'nano-minibuffer))

  (when (modulep! +splash)
    (require 'nano-splash))

  (nano-theme-set-dark)
  (nano-faces)
  (nano-theme)

  ;;(nano-mode)

  (setq display-line-numbers-type nil
        evil-default-cursor t
        custom-blue "#718591"
        custom-yellow "#BDA441")

                                        ; still haven't figured out what is up with point
                                        ; related to nano. this is a stopgap measure to
                                        ; get a decent looking cursor
  (if (daemonp)
      (add-hook 'after-make-frame-functions
                (lambda (frame)
                  (with-selected-frame frame
                    (set-cursor-color custom-blue))))
    (set-cursor-color custom-blue))

  )

(use-package! org-outer-indent)
