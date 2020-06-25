;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Niv Sardi"
      user-mail-address "x@btn.sh")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-opera)
;;(load-theme 'doom-opera)
;;(load-theme 'doom-nord)
;;(load-theme 'doom-molokai)
;;(load-theme 'doom-material)
;;(load-theme 'doom-vibrant)
;;(load-theme 'doom-one)
;;(load-theme 'doom-snazzy)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Documents/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.

(setq ispell-dictionary "es")

(setq org-log-done t
      org-footnote-auto-label t)

;; Populates only the EXPORT_FILE_NAME property in the inserted headline.
(use-package! org-capture
  :config
  (defun org-hugo-new-subtree-post-capture-template ()
    "Returns `org-capture' template string for new Hugo post.
See `org-capture-templates' for more information."
    (let* ((title (read-from-minibuffer "Post Title: ")) ;Prompt to enter the post title
           (fname (org-hugo-slug title)))
      (mapconcat #'identity
                 `(
                   ,(concat "* TODO " title)
                   ":PROPERTIES:"
                   ,(concat ":EXPORT_FILE_NAME: " fname)
                   ":END:"
                   "%?\n")          ;Place the cursor here finally
                 "\n")))

  (add-to-list 'org-capture-templates
               '("h"                ;`org-capture' binding + h
                 "Hugo post"
                 entry
                 ;; It is assumed that below file is present in `org-directory'
                 ;; and that it has a "Blog Ideas" heading. It can even be a
                 ;; symlink pointing to the actual location of all-posts.org!
                 (file+olp "blog.org" "Blog")
                 (function org-hugo-new-subtree-post-capture-template))))

;; auto-close gpg buffers, taken from
;; http://stackoverflow.com/questions/15255080/how-to-auto-close-an-auto-encryption-mode-buffer-in-emacs

(defun dwim-kill-buffers-by-ext (ext &optional timeout)
  (interactive)
  (let ((timeout (or timeout 60))
        (buffers-killed 0))
    (dolist (buffer (buffer-list))
      (with-current-buffer buffer
          (when (string-match ext (buffer-name buffer))
          (let ((current-time (second (current-time)))
                (last-displayed-time (second buffer-display-time)))
            (when (> (- current-time last-displayed-time)
                     timeout)
              (message "Auto killing .gpg buffer '%s'" (buffer-name buffer))
              (when (buffer-modified-p buffer)
                (save-buffer))
              (kill-buffer buffer)
              (incf buffers-killed))))))
    (unless (zerop buffers-killed)
      (message "%s .%s buffers have been autosaved and killed" buffers-killed ext))))

(defun xa:kill-gpg-buffers (&optional timeout)
  (dwim-kill-buffers-by-ext "\\.gpg$" timeout))

(defun xa:kill-crypt-buffers (&optional timeout)
  (dwim-kill-buffers-by-ext "crypt" timeout))

(run-with-idle-timer 60 t 'xa:kill-gpg-buffers)
(run-with-idle-timer 60 t 'xa:kill-crypt-buffers)
