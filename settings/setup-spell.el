;;; ~/.doom.d/settings/setup-spell.el --- Configure spell-checker -*- lexical-binding: t; -*-

(after! flyspell
  ;; Select default dictionary.
  (setq ispell-dictionary xa:lang)
  (ispell-change-dictionary xa:lang)

  ;; Function to switch dictionaries.
  (defun ronisbr/flyspell-switch-dictionary ()
    (interactive)
    (let* ((old_dic ispell-current-dictionary)
           (new_dic (if (string= old_dic "en_US") xa:lang "en_US")))
      (ispell-change-dictionary new_dic)
      (message "Dictionary switched to %s." new_dic))))

(provide 'setup-spell)
