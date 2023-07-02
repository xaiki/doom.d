;;; +email.el -*- lexical-binding: t; -*-

(defface bookmark-menu-heading nil "defined just to please nano")

(after! mu4e
        (setq mu4e-get-mail-command "ls")
        (setq mu4e-drafts-folder "/Drafts"
              mu4e-spam-folder "/Junk"
              mu4e-refile-folder "/Archive"
              mu4e-sent-folder "/Sent"
              mu4e-trash-folder "/Trash")

        (setq +mu4e-header-colorized-faces
              '(all-the-icons-pink all-the-icons-dpink all-the-icons-lpink
                all-the-icons-red all-the-icons-red-alt all-the-icons-dred all-the-icons-lred
                all-the-icons-blue all-the-icons-blue-alt all-the-icons-dblue all-the-icons-lblue
                all-the-icons-cyan all-the-icons-cyan-alt all-the-icons-dcyan all-the-icons-lcyan
                all-the-icons-green all-the-icons-dgreen all-the-icons-lgreen
                all-the-icons-maroon all-the-icons-dmaroon all-the-icons-lmaroon
                all-the-icons-orange all-the-icons-dorange all-the-icons-lorange
                all-the-icons-purple
                all-the-icons-silver 
                all-the-icons-yellow all-the-icons-dyellow all-the-icons-lyellow
                ))

        (setq +mu4e-header-colorized-faces
              '( all-the-icons-lpink
                 all-the-icons-lred
                 all-the-icons-lblue
                 all-the-icons-lcyan
                 all-the-icons-lgreen
                 all-the-icons-lmaroon
                 all-the-icons-lorange
                 all-the-icons-lyellow
                ))
        
        (setq +mu4e-header--maildir-colors
              '(("/bank" . all-the-icons-dgreen)
                ("bank" . all-the-icons-lgreen)
                ("btn.sh" . all-the-icons-purple)
                ("jobs" . all-the-icons-dblue)
                ("/Sent" . all-the-icons-dyellow)
                ("/Trash" . all-the-icons-lblue)
                ("/Archive" . all-the-icons-silver)
                ("/" . all-the-icons-yellow)
                ("/Junk" . all-the-icons-dred)
                ("lists" . all-the-icons-purple))
              )

        (setq mu4e-bookmarks
              '((:name "Unread messages" :query "flag:unread AND NOT flag:trashed AND NOT maildir:/Junk" :key ?u)
                (:name "Today's messages" :query "date:today..now AND NOT maildir:/Junk" :key ?t)
                (:name "Last 7 days" :query "date:7d..now AND NOT maildir:/Junk" :hide-unread t :key ?d)
                (:name "Last month" :query "date:1m..now AND NOT maildir:/Junk" :hide-unread t :key ?m)
                (:name "Messages with images" :query "mime:image/* AND NOT maildir:/Junk" :key ?p)
                ("flag:flagged" "Flagged messages" ?f)))
        
        ;; Mark as read and move to spam
        (add-to-list 'mu4e-marks
                     '(spam
                       :char       "S"
                       :prompt     "Spam"
                       :show-target (lambda (target) mu4e-spam-folder)
                       :action      (lambda (docid msg table-target-history)
                                      (mu4e--server-move docid mu4e-spam-folder "+S-u-N"))))

        (add-to-list 'mu4e-marks
                     '(archive
                       :char       "A"
                       :prompt     "Archive"
                       :show-target (lambda (target) mu4e-refile-folder)
                       :action      (lambda (docid msg table-target-history)
                                      (mu4e--server-move docid mu4e-refile-folder "+S-u-N"))))

        (mu4e~headers-defun-mark-for spam)
        (mu4e~headers-defun-mark-for archive)

        (define-key mu4e-headers-mode-map (kbd ".") 'mu4e-headers-mark-for-archive)
        (define-key mu4e-headers-mode-map (kbd "'") 'mu4e-headers-mark-for-spam))

(use-package! mu4e-dashboard
  :config
  (setq mu4e-dashboard-file "~/.doom.d/mail-dashboard.org"))


(require 'smtpmail)
(require 'auth-source)
(require 'secrets)
(setq auth-sources '(default
                     "secrets:session"
                     "secrets:Login"))

(defun xa:async-smtpmail-send-it ()
  (async-start
   `(lambda ()
      (require 'smtpmail)
      (with-temp-buffer
        (insert ,(buffer-substring-no-properties (point-min) (point-max)))
        ;; Pass in the variable environment for smtpmail
        ,(async-inject-variables "\\`\\(smtpmail\\|\\(user-\\)?mail\\)-")
        (smtpmail-send-it)))
   ;; What to do when it finishes
   (lambda (result)
     (message "Async process done, result: %s" result))))

(defun xa:get-smtp-passwords-from-goa ()
  (let (passwords)
    (dolist (item (secrets-list-items "login") passwords)
      (let ((identity (secrets-get-attribute "login" item :goa-identity)))
        (if (and (char-or-string-p identity) (string-match "smtp" identity))
            (let ((hash (json-parse-string
                         (replace-regexp-in-string
                          "<?'>?" "\""
                          (secrets-get-secret "login" item))
                         )))
              (push (gethash "smtp-password" hash) passwords)
              )
          )))
    passwords))

(let ((password (car (xa:get-smtp-passwords-from-goa))))
  (setq send-mail-function 'xa:async-smtpmail-send-it
        smtpmail-stream-type 'starttls
        smtpmail-default-smtp-server "mail.xaiki.net"
        message-send-mail-function 'xa:async-smtpmail-send-it
        smtpmail-starttls-credentials '(("xaiki.net" 587 nil password))
        smtpmail-auth-credentials
        '(("xaiki.net" "imaps" "x@btn.sh" password)
          ("mail.xaiki.net" "imaps" "x@btn.sh" password)
          ("xaiki.net" "smtp" "x@btn.sh" password)
          ("mail.xaiki.net" "smtp" "x@btn.sh" password))
        smtpmail-smtp-server "mail.xaiki.net"
        smtpmail-smtp-service 587
        smtpmail-debug-info t
        smtpmail-debug-verb t))
