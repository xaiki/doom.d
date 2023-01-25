;;; +email.el -*- lexical-binding: t; -*-

(defface bookmark-menu-heading nil "defined just to please nano")
(setq xa:mu4e-local-dir (concat doom-local-dir "mu"))
(setq xa:mu4e-binary (concat xa:mu4e-local-dir "/build/mu/mu"))
(unless (file-directory-p xa:mu4e-local-dir)
  (async-shell-command (concat "git clone https://github.com/djcb/mu " xa:mu4e-local-dir)))
(unless (file-executable-p xa:mu4e-binary)
  (shell-command (format "cd %s; make clean all MESON_FLAGS=\"-Demacs=disabled\""
                         xa:mu4e-local-dir)))
(let ((hack-mu4e-config (concat doom-user-dir "mu4e-config.el"))
      (mu-binary (concat xa:mu4e-local-dir "")))
  (unless (f-file-p hack-mu4e-config)
    (f-write-text "
;; auto-generated

(defconst mu4e-mu-version \"\"
  \"Required mu binary version; mu4e's version must agree with this.\")

(defconst mu4e-builddir \"@abs_top_builddir@\"
  \"Top-level build directory.\")

(defconst mu4e-doc-dir \"@MU_DOC_DIR@\"
  \"Mu4e's data-dir.\")

(provide 'mu4e-config)

"'utf-8 )
    ))


(add-to-list 'load-path (concat xa:mu4e-local-dir "/mu4e"))
(use-package! mu4e-dashboard
  :after nano-emacs
  :config
  (setq 'mu4e-dashboard-file "~/.doom.d/mail-dashboard.org"))
