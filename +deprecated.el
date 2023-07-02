;;; +deprecated.el -*- lexical-binding: t; -*-


(after! circe
  ;; make circe(IRC) work
  ;; XXX(xaiki): there is a bug in nano-emacs that sets mode-line-format to ""
  ;; then circe's tracking mode expects it to be a list, set it back
  ;; to the real default

  (setq-default mode-line-format (list "%-"))
  (setq circe-network-options
        '(("xaiki.net" :host "xaiki.net" :port 6697
           :tls t
           :nick "admin"
           :nickserv-password (lambda (&rest params) (xa:get-login-password "irc.xaiki.net"))
           :nickserv-mask "^NickServ!NickServ@services\\.libera\\.chat$"
           :nickserv-identify-challenge "This nickname is registered."
           :nickserv-identify-command "PRIVMSG NickServ :IDENTIFY {nick} {password}"
           :nickserv-identify-confirmation "^You are now identified for \x02.*\x02\\.$"
           :nickserv-ghost-command "PRIVMSG NickServ :GHOST {nick} {password}"
           :nickserv-ghost-confirmation "has been ghosted\\.$\\|is not online\\.$"
           ))))
