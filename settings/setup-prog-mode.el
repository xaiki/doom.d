;;; ~/.doom.d/settings/setup-prog-mode.el --- Configure prog-mode -*- lexical-binding: t; -*-

;; Show trailing spaces.
(add-hook! prog-mode #'doom-enable-show-trailing-whitespace-h)

;; Show fill column line.
(add-hook! prog-mode (display-fill-column-indicator-mode t))

(provide 'setup-prog-mode)
