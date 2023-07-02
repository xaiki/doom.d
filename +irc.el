;;; +irc.el -*- lexical-binding: t; -*-

(defun xa:get-login-password (name)
  (secrets-get-secret "login" name))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ERC                                                                    ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq erc-email-userid "user")
(defun run-erc ()
  (interactive)
  (erc-tls :server "xaiki.net"
           :port 6697
           :id "oftc.irc.xaiki.net"
           :user (concat "xaiki/irc.oftc.net@emacs-" (user-real-login-name) "-" (system-name))
           :nick "xaiki"
           :password (xa:get-login-password "irc.xaiki.net")))

(require 'erc-track)
(setq erc-track-exclude-types '("NICK" "JOIN" "PART" "QUIT" "MODE"
                                "301"   ; away notice
                                "305"   ; return from awayness
                                "306"   ; set awayness
                                "332"   ; topic notice
                                "333"   ; who set the topic
                                "353"   ; Names notice
                                "324"   ; modes
                                "329"   ; channel creation date
                                )
      erc-track-exclude-server-buffer t
      erc-track-exclude '("*stickychan" "*status" "&bitlbee")
      erc-track-showcount t
      erc-track-shorten-start 3
      erc-track-switch-direction 'importance
      erc-track-visibility 'selected-visible
      erc-track-use-faces t
      erc-format-query-as-channel-p t
      erc-header-line-format "%t: %o"
      erc-join-buffer 'bury
      erc-warn-about-blank-lines nil
      erc-interpret-mirc-color t
      erc-rename-buffers t
      erc-prompt (lambda ()
                   (concat "[" (car erc-default-recipients) "]")))



(erc-modified-channels-update)
(defun erc-history ()
  (interactive)
  (let* ((date (decoded-time-add (decode-time nil nil t) (make-decoded-time :day -7)))
        (d (format "%02d" (nth 3 date)))
        (m (format "%02d" (nth 4 date)))
        (y (nth 5 date)))
(erc-server-send (format "CHATHISTORY AFTER %s timestamp=%s-%s-%sT00:00:00.000Z 1000"
                             (car erc-default-recipients)
                             y m d))
    )
)
(add-to-list 'erc-join-hook 'erc-history)
