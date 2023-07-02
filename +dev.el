;;; +dev.el -*- lexical-binding: t; -*-

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MISC
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; less is more
(defun rainbow-delimiters-mode () nil)

;; find rust stuff
(add-to-list 'exec-path (concat (getenv "HOME") "/.cargo/bin"))
(add-to-list 'exec-path (concat (getenv "HOME")
                                "/.rustup/toolchains/" "stable-" system-configuration "/bin"))

(use-package! format-all
  :defer t)

(use-package! which-func
  :defer t
  :commands which-function)

(use-package! paredit
  :defer t
  :config
  (setq paredit-indent-after-open nil)
  (define-key paredit-mode-map (kbd "C-<left>") nil)
  (define-key paredit-mode-map (kbd "C-<right>") nil)

  (require 'eldoc) ; if not already loaded
  (eldoc-add-command
   'paredit-backward-delete
   'paredit-close-round)

  (eval-after-load 'paredit
    '(progn (define-key paredit-mode-map (kbd "{")
	      'paredit-open-curly)
	    (define-key paredit-mode-map (kbd "}")
	      'paredit-close-curly)
	    (define-key paredit-mode-map (kbd "M-}")
	      'paredit-close-curly-and-newline))))

(defun xa:paredit-coding ()
  "Turn on paredit mode for non-lisps."
  (interactive)
  (set (make-local-variable 'paredit-space-for-delimiter-predicates)
       '((lambda (endp delimiter) nil)))
  (paredit-mode 1))

(defun xa:company-setup()
  "settings for prog modes"
  (interactive)
  (progn
    (local-set-key (kbd "TAB") #'company-indent-or-complete-common)
    (local-set-key (kbd "C-c C-h") #'company-show-doc-inhibit-popup)))

(defun xa:indent-buffer ()
  (interactive)
  (save-excursion
    (indent-region (buffer-end -1) (buffer-end 1))))

(add-hook! '(prog-mode-hook) #'xa:paredit-coding)
;;(add-hook! '(prog-mode-hook) #'xa:set-prog-setup)
;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; GET THE PATH RIGHT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; we do all this to load ~/.profile
;;(setq shell-command-switch "-c")
;;(defun set-exec-path-from-shell-PATH ()
;;  (let ((path-from-shell (replace-regexp-in-string
;;                          "[ \t\n(cannot)]*$"
;;                          ""
;;                          (shell-command-to-string ". ~/.profile && echo $PATH"))))
                                        ; ;   (setenv "PATH" path-from-shell)
;;    (setq eshell-path-env path-from-shell) ; for eshell users
;;    (setq exec-path (split-string path-from-shell path-separator))))

;;(when window-system (set-exec-path-from-shell-PATH))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; JS, WEB
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package! eglot)
;;(use-package! css-in-js-mode)

;; (use-package! tsx-mode
;;   :config

;;   (setq tsx-mode-use-css-in-js nil)
;;   (add-to-list
;;    'eglot-server-programs
;;    '(tsx-mode "typescript-language-server" "--stdio")))
;; (use-package! tree-sitter-langs
;;   :config
;;   (global-tree-sitter-mode)
;;   (add-to-list 'tree-sitter-major-mode-language-alist '(tsx-ts-mode . tsx))
;;   )

(add-to-list
   'eglot-server-programs
   '(typescript-ts-mode "typescript-language-server" "--stdio"))
(add-to-list
   'eglot-server-programs
   '(tsx-ts-mode "typescript-language-server" "--stdio"))

(add-to-list 'exec-path (concat (getenv "XDG_DATA_HOME") "/node/bin"))
;;(unless (eq 0 (shell-command "node --version"))
;;  (shell-command "export N_PREFIX=$XDG_DATA_HOME/node; curl -fsSL https://raw.githubusercontent.com/tj/n/master/bin/n | bash -s lts"))

(add-hook! '(web-mode-hook html-mode-hook) (setq-local format-all-formatters '(("HTML" prettier))))
(add-hook! 'typescript-mode-hook (setq-local format-all-formatters '(("TypeScript" prettier))))
;;(add-hook! 'tsx-mode-hook (setq-local format-all-formatters '(("TypeScript" prettier))))

(after! web-mode
  (web-mode-toggle-current-element-highlight)
  (web-mode-dom-errors-show))

(setq lsp-clients-typescript-init-opts
      '(:importModuleSpecifierPreference "relative"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; LSP & DAP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Use format-all by default
(setq +format-with-lsp nil)

(setq +lsp-prompt-to-install-server 'quiet)

(after! lsp-mode
  (setq lsp-log-io nil
        lsp-file-watch-threshold 4000
        lsp-headerline-breadcrumb-enable t
        lsp-headerline-breadcrumb-icons-enable nil
        lsp-headerline-breadcrumb-segments '(file symbols)
        lsp-imenu-index-symbol-kinds '(File Module Namespace Package Class Method Enum Interface
                                            Function Variable Constant Struct Event Operator TypeParameter)
        )
  (dolist (dir '("[/\\\\]\\.ccls-cache\\'"
                 "[/\\\\]\\.mypy_cache\\'"
                 "[/\\\\]\\.pytest_cache\\'"
                 "[/\\\\]\\.cache\\'"
                 "[/\\\\]\\.clwb\\'"
                 "[/\\\\]__pycache__\\'"
                 "[/\\\\]bazel-bin\\'"
                 "[/\\\\]bazel-code\\'"
                 "[/\\\\]bazel-genfiles\\'"
                 "[/\\\\]bazel-out\\'"
                 "[/\\\\]bazel-testlogs\\'"
                 "[/\\\\]third_party\\'"
                 "[/\\\\]third-party\\'"
                 "[/\\\\]buildtools\\'"
                 "[/\\\\]out\\'"
                 ))
    (push dir lsp-file-watch-ignored-directories))
  )

(after! lsp-ui
  (setq lsp-ui-doc-enable nil
        lsp-lens-enable nil
        lsp-ui-sideline-enable nil
        lsp-ui-doc-include-signature t
        lsp-ui-doc-max-height 15
        lsp-ui-doc-max-width 100))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; JUPYTER
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(after! ein
  (setq ein:jupyter-docker-image "docker.io/jupyter/scipy-notebook"
        ein:jupyter-use-containers "podman"))
