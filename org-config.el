;;; org-config.el --- My Org mode configuration.
;;; Commentary:
;;; Author: Pratik Abhyankar
;;; Created on: 26 October 2020
;;; Copyright (c) 2020 Pratik Abhyankar <https://pratikabhyankar.com>

;;; Credit: This Emacs configuration is adapted from the GitHub repository
;;; "dot-emacs-dot-d" created by Suvrat Apte <https://github.com/suvratapte/dot-emacs-dot-d>

;; This file is not part of GNU Emacs.

;;; License:

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the Do What The Fuck You Want to
;; Public License, Version 2, which is included with this distribution.
;; See the file LICENSE.txt

;;; Code:

(use-package org
  :config
  ;; Enable spell check in org
  (add-hook 'org-mode-hook 'turn-on-flyspell)

  (setq-default
   org-list-demote-modify-bullet '(("+" . "-") ("-" . "+"))
   ;; Hide leading stars
   org-hide-leading-stars t

   ;; Enable source code highlighting in org-mode.
   org-src-fontify-natively t

   ;; Open the link at point when RET is pressed
   org-return-follows-link t

   ;; Use LOGBOOK drawer to take notes
   org-log-into-drawer t

   ;; Add 'closed' log when marked done
   org-log-done t
   
   ;; C-{a,e} should behave differently on headings
   org-special-ctrl-a/e t
   
   ;; ToDo task statuses
   ;; Adding a "!" adds a timestamp when the status is set. Adding a "@" adds a note to that task
   org-todo-keywords '((sequence
                        "TODO(t)" "STARTED(s)" "WAITING(w)" "|" "CANCELED(c)" "DONE(d!)"))

   org-todo-keyword-faces-doom-dark-theme
   '(("TODO" :foreground "#d62d2d" :weight bold)
     ("STARTED" :foreground "#22d3e3" :weight bold)
     ("WAITING" :foreground "#eb8934" :weight bold)
     ("CANCELED" :foreground "#737373" :weight bold)
     ("DONE" :foreground "#2b8c0b" :weight bold))

  org-todo-keyword-faces org-todo-keyword-faces-doom-dark-theme

  org-enforce-todo-dependencies t
  org-enforce-todo-checkbox-dependencies t

  ;; When dependencies are enforced (by both vars above), agenda views highlight tasks
  ;; highlights blocked tasks i.e. tasks with incomplete sub tasks.
  org-agenda-dim-blocked-tasks nil

  org-agenda-skip-scheduled-if-done t

  org-agenda-block-separator
  (propertize
  "────────────────────────────────────────────────────────────────────────"
  'face '(:foreground "#81a1c1")))
  
  :bind (:map
         global-map
         ("C-c c" . org-capture)
         ("C-c a" . org-agenda)
         ("C-c l" . org-stored-links)
         ("C-c g" . org-clock-goto)
         ("C-c o" . jump-to-org-agenda))
  :delight)


(use-package org-bullets
  :ensure t
  :init
  (setq org-bullets-face-name "Inconsolata-12")
  :config
  (add-hook 'org-mode-hook 'org-bullets-mode)
  :delight)


(bind-key
 "C-9"
 (lambda ()
   (interactive)
   (find-file "~/.emacs.d/org-config.el")))

(bind-key
 "C-M-9"
 (lambda ()
   (interactive)
   (load-file "~/.emacs.d/org-config.el")))


(provide 'org-config)

;;; org-config ends here
