;; -*- no-byte-compile: t; -*-
;;; private/nano-theme/packages.el

(when (modulep! +minibuffer)
  (package! mini-frame))

(package! org-outer-indent :recipe (:host github :repo "rougier/org-outer-indent"))
(package! svg-lib :recipe (:host github :repo "rougier/svg-lib"))
(package! svg-tag-mode :recipe (:host github :repo "rougier/svg-tag-mode"))
(package! nano-emacs :recipe (:host github :repo "rougier/nano-emacs"))
