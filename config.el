;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq user-full-name "Niv Sardi"
      user-mail-address "x@btn.sh")

(add-load-path! "~/.doom.d/settings")

;; Setup the theme.
(require 'setup-theme)

(when (or (string-match "flatpak" (getenv "EMACS"))
          (string-match "/home" (getenv "EMACS")))
  (setenv "EMACS" "emacs"))

;; Select locale.
(defcustom xa:lang "en_US"
  "language for all things emacs")
(defcustom xa:coding "UTF-8"
  "encoding for all things emacs")
(defun xa:lang-code ()
  (concat xa:lang "." xa:coding))

(setenv "LANG" (xa:lang-code))
(setenv "LC_CTYPE" (xa:lang-code))
(setenv "LC_ALL" (xa:lang-code))
(set-locale-environment (xa:lang-code))

;; Set fill-columns at position 92.
(setq-default fill-column 80)

;; Enable smooth scrolling by default.
(pixel-scroll-precision-mode 1)

;; This determines the style of line numbers in effect. If set to `nil', line numbers are
;; disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; Custom settings.
(require 'setup-auctex)
(require 'setup-company)
(require 'setup-doom-nano-modeline)
(require 'setup-emojify)
(require 'setup-julia-ts-mode)
(require 'setup-keybindings)
(require 'setup-layout)
(require 'setup-menu-bar)
(require 'setup-org-mode)
(require 'setup-prog-mode)
(require 'setup-recentf)
(require 'setup-spell)
(require 'setup-svg-tag-mode)
(require 'setup-treemacs)
(require 'setup-treesit-auto)
(require 'setup-vertico)
(require 'setup-vterm)

(load! "+dev")

;; Local packages.
(use-package! comment-align
  :load-path "~/.doom.d/local-lisp")
(use-package! fill-line
  :load-path "~/.doom.d/local-lisp")
(use-package! text-align
  :load-path "~/.doom.d/local-lisp")

;; =========================================================================================
;;                                     Local packages
;; =========================================================================================

(use-package! julia-docstrings
  :load-path "~/.doom.d/local-packages/julia-docstrings")
