;;; init.el -*- lexical-binding: t; -*-

;; This file controls what Doom modules are enabled and what order they load
;; in. Remember to run 'doom sync' after modifying it!

;; NOTE Press 'SPC h d h' (or 'C-h d h' for non-vim users) to access Doom's
;;      documentation. There you'll find a "Module Index" link where you'll find
;;      a comprehensive list of Doom's modules and what flags they support.

;; NOTE Move your cursor over a module's name (or its flags) and press 'K' (or
;;      'C-c c k' for non-vim users) to view its documentation. This works on
;;      flags as well (those symbols that start with a plus).
;;
;;      Alternatively, press 'gd' (or 'C-c c d') on a module to browse its
;;      directory (for easy access to its source code).

(doom! :input
       :completion
       (company +childframe)
       (vertico +icons)

       :ui
       doom
       doom-dashboard
       (emoji +github)
       hl-todo
       indent-guides
       ;; ligatures
       ;; modeline
       neotree
       ophints
       (popup +defaults)
       treemacs
       (vc-gutter +pretty)
       vi-tilde-fringe
       (window-select +numbers)
       workspaces
       zen

       :editor
       ;;(evil +everywhere)
       file-templates
       fold
       multiple-cursors
       snippets
       word-wrap

       :emacs
       (dired +icons)
       electric
       (ibuffer +icons)
       (undo +tree)
       vc

       :term
       vterm

       :checkers
       (spell +everywhere +flyspell +hunspell)
       grammar
       (syntax +childframe)

       :tools
       (eval +overlay)
       lookup
       (lsp +eglot)
       magit
       pdf

       :os
       (:if IS-MAC macos)
       tty

       :lang
       (cc +lsp)
       csharp                   ; unity, .NET, and mono shenanigans
       data                     ; config/data formats
       emacs-lisp
       json              ; At least it ain't XML
       (javascript +lsp)        ; all(hope(abandon(ye(who(enter(here))))))
       (julia +lsp)
       latex             ; writing papers in Emacs has never been so fun
       markdown         ; writing docs for people to ignore
       (org +dragndrop +pretty +roam2)
       python
       qt
       sh     ; she sells {ba,z,fi}sh shells on the C xor
       (rust +lsp +tree-sitter)       ; Fe2O3.unwrap().unwrap().unwrap().unwrap()
       (web +lsp)                       ; the tubes
       yaml              ; JSON, but readable

       :email
       (mu4e +org)

       :app
       everywhere

       :config
       ;;literate
       (default +bindings))

;; Disable deferred compilation.
;;
;;    See: https://github.com/doomemacs/doomemacs/issues/6811
;;
(setq native-comp-deferred-compilation nil)
(after! (doom-packages straight)
  (setq straight--native-comp-available t))
