;;; +dashboard.el -*- lexical-binding: t; -*-

(setq +doom-dashboard-menu-sections
      '(("Reload last session" :icon
         (all-the-icons-octicon "history" :face 'doom-dashboard-menu-title)
         :when
         (cond
          ((modulep! :ui workspaces)
           (file-exists-p
            (expand-file-name persp-auto-save-fname persp-save-dir)))
          ((require 'desktop nil t)
           (file-exists-p
            (desktop-full-file-name))))
         :face
         (:inherit
          (doom-dashboard-menu-title bold))
         :action doom/quickload-session)
        ("Open Mail" :icon
         (all-the-icons-octicon "mail" :face 'doom-dashboard-menu-title)
         :when
         (fboundp 'mu4e-dashboard)
         :action mu4e-dashboard)
        ("Open Telegram" :icon
         (all-the-icons-material "chat_bubble_outline" :face 'doom-dashboard-menu-title)
         :when
         (fboundp 'telega)
         :action telega)
        ("Open Social" :icon
         (all-the-icons-material "leak_add" :face 'doom-dashboard-menu-title)
         :when
         (fboundp 'mastodon)
         :action mastodon)
        ("Open org-agenda" :icon
         (all-the-icons-octicon "calendar" :face 'doom-dashboard-menu-title)
         :when
         (fboundp 'org-agenda)
         :action org-agenda)
        ("Recently opened files" :icon
         (all-the-icons-octicon "file-text" :face 'doom-dashboard-menu-title)
         :action recentf-open-files)
        ("Open project" :icon
         (all-the-icons-octicon "briefcase" :face 'doom-dashboard-menu-title)
         :action projectile-switch-project)
        ("Jump to bookmark" :icon
         (all-the-icons-octicon "bookmark" :face 'doom-dashboard-menu-title)
         :action bookmark-jump)
        ("Open private configuration" :icon
         (all-the-icons-octicon "tools" :face 'doom-dashboard-menu-title)
         :when
         (file-directory-p doom-user-dir)
         :action doom/open-private-config)
        ("Open documentation" :icon
         (all-the-icons-octicon "book" :face 'doom-dashboard-menu-title)
         :action doom/help)))
