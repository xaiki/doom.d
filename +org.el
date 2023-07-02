;;; +org.el -*- lexical-binding: t; -*-

(use-package! org-outer-indent)
(use-package! svg-tag-mode
  :config
  (require 'svg-tag-mode))

(defvar xa:org-is-exporting nil "is org currently exporting")
(advice-add 'org-export-as
            :before (lambda (a &optional b c d e)  (setq xa:org-is-exporting t)))
(advice-add 'org-export-as
            :after (lambda (a &optional b c d e)  (setq xa:org-is-exporting nil)))

(add-to-list 'org-latex-default-packages-alist
             '(nil "fontspec"))
(add-to-list 'org-latex-default-packages-alist
             '("spanishmx" "babel"))

(add-to-list 'org-latex-packages-alist
             '("AUTO" "babel" t ("pdflatex")))
(add-to-list 'org-latex-packages-alist
             '("AUTO" "polyglossia" t ("xelatex" "lualatex")))

(setenv "TEXINPUTS" (concat user-emacs-directory "latex"))
(setq org-export-latex-classes nil)
(setq xa:pdftk-cmd (concat "pdftk %b.pdf output %b.crypt.pdf owner_pw "
                           (shell-command-to-string "apg -n 1 +s")))
(setq xa:latex-podman "podman run -ti -v `echo %O | sed s/'\\\/[^\/]*$'//`:/data:Z -w /data docker.io/moss/xelatex  %latex -interaction nonstopmode -output-directory %o %f")
(setq org-latex-pdf-process
      '("podman run -ti -v `echo %O | sed s/'\\\/[^\/]*$'//`:/data:Z -w /data docker.io/mrchoke/texlive  %latex -interaction nonstopmode -output-directory %o %f"
      "podman run -ti -v `echo %O | sed s/'\\\/[^\/]*$'//`:/data:Z -w /data docker.io/mrchoke/texlive  %latex -interaction nonstopmode -output-directory %o %f"
        "pdftk %b.pdf output %b.crypt.pdf owner_pw `apg -n 1 +s` || true"))
(setq org-latex-compiler "xelatex")

(defun xa:org-screenshot ()
  "Take a screenshot into a time stamped unique-named file in the
same directory as the org-buffer and insert a link to this file."
  (interactive)
    (let* ((selection-coding-system 'no-conversion) ;for rawdata
         (filename (concat
         (make-temp-name
          (concat (file-name-nondirectory (buffer-file-name))
                  "_"
                  (format-time-string "%Y%m%d_%H%M%S_")) ) ".png"))
         (coding-system-for-write 'binary))
      (write-region (or (gui-get-selection 'CLIPBOARD 'image/png)
                        (error "No image in CLIPBOARD"))
                    nil filename nil 'quiet)
      (insert (concat "[[./" filename "]]"))
      (org-display-inline-images)))

(use-package! org-caldav
  :config )
