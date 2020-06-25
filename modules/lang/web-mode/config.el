;;; lang/web-mode/config.el -*- lexical-binding: t; -*-

(use-package! web-mode
  :mode (("\\.css$" . web-mode)
         ("\\.scss$" . web-mode)
         ("\\.json$" . web-mode)
         ("\\.[jt]s[x]?$" . web-mode)
         ("\\.[jt]s[x]?$" . web-mode)
         ("\\.html$" . web-mode)
         ("\\.tpl$" . web-mode)
         ("\\.hbs$" . web-mode)
         ("\\.svelte$" . web-mode))
  :init
  ;; hook into dtrt-indent
  (defun xa:web-mode-all-indent-offset (n)
    (setq
     web-mode-markup-indent-offset n
     web-mode-attr-indent-offset n
     web-mode-attr-value-indent-offset n
     web-mode-code-indent-offset n))
  :config
  (setq web-mode-engines-alist
        '(("ctemplate" . "\\.html\\'")))

  (setq web-mode-content-types-alist
        '(("jsx" . "\\.[jt]s[x]?\\'")))

  (setq web-mode-auto-close-style 2)
  (setq web-mode-enable-auto-closing t)
  (setq web-mode-enable-auto-expanding t)
  (setq web-mode-enable-auto-quoting nil)
  (setq web-mode-enable-auto-pairing t)
  (setq web-mode-enable-auto-opening t)
  (setq web-mode-enable-current-element-highlight t)
  (setq web-mode-auto-close-style 2)
  (setq web-mode-enable-html-entities-fontification t)
  (setq web-mode-enable-css-colorization t)
  )

(use-package! paredit
  :init
  (defun xa:paredit-web ()
    "Turn on paredit mode for non-lisps."
    (interactive)
    (set (make-local-variable 'paredit-space-for-delimiter-predicates)
         '((lambda (endp delimiter) nil)))
    (define-key web-mode-map "{" 'paredit-open-curly)
    (define-key web-mode-map "}" 'paredit-close-curly)
    ;;  (define-key web-mode-map "<" 'paredit-open-angled)
    ;;  (define-key web-mode-map ">" 'paredit-close-angled)
    (paredit-mode 1)))

(use-package! dtrt-indent
  :config
  (setq xa:web-mode-indent-offset 2)
  (add-to-list 'dtrt-indent-hook-mapping-list '(web-mode sgml xa:web-mode-indent-offset))
  (add-to-list 'dtrt-indent-hook-mapping-list '(web-mode default xa:web-mode-indent-offset))
  (add-to-list 'dtrt-indent-hook-mapping-list '(web-mode javascript xa:web-mode-indent-offset))
  )

(use-package! tide
  :init
  ;; https://github.com/ananthakumaran/tide
  (defun setup-tide-mode ()
    (interactive)
    (tide-setup)
    (flycheck-mode +1)
    (setq flycheck-check-syntax-automatically '(save mode-enabled))
    (eldoc-mode +1)
    (tide-hl-identifier-mode +1)
    ;; company is an optional dependency. You have to
    ;; install it separately via package-install
    ;; `M-x package-install [ret] company`
    (after! company (company-mode +1))
    (message "tide mode setup"))
  :config
  (setq tide-node-executable "~/.local/bin/podman/node")
  )

;; aligns annotation to the right hand side
(setq company-tooltip-align-annotations t)

;; formats the buffer before saving
(add-hook 'before-save-hook 'tide-format-before-save)
(add-hook 'typescript-mode-hook #'setup-tide-mode)



(use-package! flycheck
  :config
  ;; use eslint with web-mode for jsx files
  (flycheck-add-mode 'javascript-eslint 'web-mode)
  (after! tide (flycheck-add-next-checker 'javascript-eslint 'jsx-tide 'append)))


(defun xa:web-mode-hook () (interactive)
  (progn
    (message "runing hook")
    (xa:paredit-web)
    (xa:web-mode-all-indent-offset xa:web-mode-indent-offset)
    (when (string-match "[jt]s[x]?" (file-name-extension buffer-file-name))
      (progn
        (message "in js")
        (setup-tide-mode)))))

(add-to-list 'auto-mode-alist '("\\.\\(html\\|tag\\|hbs\\)$" . web-mode))
;;(add-hook 'web-mode-hook 'skewer-mode)
;;(add-hook 'web-mode-hook 'skewer-html-mode)
(add-hook 'web-mode-hook 'dtrt-indent-adapt)
(add-hook 'web-mode-hook 'xa:web-mode-hook)


(defadvice company-tern (before web-mode-set-up-ac-sources activate)
  "Set `tern-mode' based on current language before running company-tern."
  (if (equal major-mode 'web-mode)
      (let ((web-mode-cur-language
             (web-mode-language-at-pos)))
        (if (or (string= web-mode-cur-language "jsx")
                (string= web-mode-cur-language "javascript"))
            (unless tern-mode (tern-mode))
          (if tern-mode (tern-mode))))))


(setq web-mode-extra-snippets
      '(("jsx" . (("class" . ("class | extends React.Component {\nrender() {\nreturn (\n\n)\n}\n}"))
                  ("cssclass" . ("class | extends ReactCSS.Component {\nclasses() {\n'default': {\n}\n}\nrender() {\nreturn (\n\n)\n}\n}"))
                  ))))
