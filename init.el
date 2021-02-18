;;; init.el --- My Emacs configuration.
;;; Commentary:
;;; Author: Pratik Abhyankar
;;; Created on: 17 May 2020
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

;; ─────────────────────────────────── Set up 'package' ───────────────────────────────────
(require 'package)

;; Add melpa to package archives.
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/") t)

;; Update the package contents when Emacs starts
(package-refresh-contents)

;; Load and activate Emacs packages. Do this first so that the packages are loaded before
;; you start trying to modify them.  This also sets the load path.
(package-initialize)

;; Install 'use-package' if it is not installed.
(when (not (package-installed-p 'use-package))
  (package-refresh-contents)
  (package-install 'use-package))


;; ───────────────────────────────── Use better defaults ────────────────────────────────
(setq-default
 ;; Don't use the compiled code if its the older package.
 load-prefer-newer t

 ;; Do not show the startup message.
 inhibit-startup-message t

 ;; Do not put 'customize' config in init.el; give it another file.
 custom-file "~/.emacs.d/custom-file.el"

 ;; 72 is too less for the fontsize that I use.
 fill-column 90

 ;; Use your name in the frame title. :)
 frame-title-format (format "%s's Emacs" (capitalize user-login-name))

 ;; Do not create lockfiles.
 create-lockfiles nil

 ;; Change buffer focus to help window when opened
 help-window-select t
 
 ;; Don't use hard tabs
 indent-tabs-mode nil

 ;; Emacs can automatically create backup files. This tells Emacs to put all backups in
 ;; ~/.emacs.d/backups. More info:
 ;; http://www.gnu.org/software/emacs/manual/html_node/elisp/Backup-Files.html
 backup-directory-alist `(("." . ,(concat user-emacs-directory "backups")))

 ;; Do not autosave.
 auto-save-default nil

 ;; Allow commands to be run on minibuffers.
 enable-recursive-minibuffers t

 ;; Do not ring bell
 ring-bell-function 'ignore)

;; Set line-spacing and line-height. TODO: Find solution to vertically align the font to line.
(setq default-text-properties '(line-spacing 0.2 line-height 0.2))

;; Load `custom-file` manually as we have modified the default path.
(load-file custom-file)

;; Change all yes/no questions to y/n type
(fset 'yes-or-no-p 'y-or-n-p)

;; Make the command key behave as 'meta'
(when (eq system-type 'darwin)
 (setq mac-command-modifier 'meta))
;;  (setq mac-right-command-modifier 'hyper))

;; Enable narrowing commands.
(put 'narrow-to-region 'disabled nil)
(put 'narrow-to-page 'disabled nil)

(global-set-key (kbd "H-d") 'narrow-to-defun)
(global-set-key (kbd "H-t") 'narrow-to-defun)
(global-set-key (kbd "H-w") 'widen)

;; Automatically update buffers if file content on the disk has changed.
(global-auto-revert-mode t)

;; Start Emacsserver so that emacsclient can be used
(server-start)

;; ─────────────────────────────── Customize UI elements  ───────────────────────────────
(progn

  ;; Do not show tool bar.
  (when (fboundp 'tool-bar-mode)
    (tool-bar-mode -1))

  ;; Do not show scroll bar.
  (when (fboundp 'scroll-bar-mode)
    (scroll-bar-mode -1))

  ;; Do not show menu bar.
  (when (fboundp 'menu-bar-mode)
    (menu-bar-mode -1))

  ;; Highlight line on point.
  (global-hl-line-mode t))

;; Display line numbers.
(if (version<= "26.0.50" emacs-version)
    (global-display-line-numbers-mode)
  (display-line-numbers-mode))

;; Display column number in mode line.
(column-number-mode t)

;; Start Emacs in fullsceen mode
(add-to-list 'default-frame-alist '(fullscreen . maximized))


;; ─────────────────────────────── Generic Functionality ────────────────────────────────
(defun toggle-comment-on-line ()
  "Comment or uncomment current line."
  (interactive)
  (comment-or-uncomment-region (line-beginning-position) (line-end-position)))

(global-set-key (kbd "C-;") 'toggle-comment-on-line)


;; ───────────────────────────────── Use Package Config ─────────────────────────────────
(require 'use-package)

;; Add `:doc' support for use-package so that we can use it like what a doc-strings is for
;; functions.
(eval-and-compile
  (add-to-list 'use-package-keywords :doc t)
  (defun use-package-handler/:doc (name-symbol _keyword _docstring rest state)
    "An identity handler for :doc.
     Currently, the value for this keyword is being ignored.
     This is done just to pass the compilation when :doc is included
     Argument NAME-SYMBOL is the first argument to `use-package' in a declaration.
     Argument KEYWORD here is simply :doc.
     Argument DOCSTRING is the value supplied for :doc keyword.
     Argument REST is the list of rest of the  keywords.
     Argument STATE is maintained by `use-package' as it processes symbols."

    ;; just process the next keywords
    (use-package-process-keywords name-symbol rest state)))


;; ───────────────────────────────── Generic Packages ───────────────────────────────────
(use-package delight
  :ensure t
  :delight)

(use-package dashboard
  :doc "Set a good Emacs startup screen"
  :ensure t
  :config
  (dashboard-setup-startup-hook))

(use-package ace-jump-mode
  :doc "Jump around the visible buffer using 'Head Chars'"
  :ensure t
  :bind ("C-." . ace-jump-mode)
  :delight)

(use-package flycheck
  :doc "Spellcheck in Emacs"
  :ensure t
  :config
  (global-flycheck-mode)
  :delight)

(use-package which-key
  :doc "Prompt the next possible key bindings after a short wait"
  :ensure t
  :config
  (which-key-mode t)
  :delight)

(use-package ibuffer
  :doc "Better buffer management"
  :bind ("C-x C-b" . ibuffer)
  :delight)

(use-package projectile
  :doc "Project navigation"
  :ensure t
  :config
  (projectile-mode t)
  :bind ("C-x f" . projectile-find-file)
  :delight)

(use-package magit
  :doc "Git integration for Emacs"
  :ensure t
  :bind ("C-x g" . magit-status)
  :delight)

(use-package ivy
  :doc "A generic completion mechanism"
  :ensure t
  :config
  (ivy-mode t)
  (setq ivy-use-virtual-buffers t
        ;; Display index and count both.
        ivy-count-format "(%d/%d) "
        ;; By default, all ivy prompts start with `^'. Disable that.
        ivy-initial-inputs-alist nil)
  :bind (("C-x b" . ivy-switch-buffer)
         ("C-x B" . ivy-switch-buffer-other-window))
  :delight)

(use-package ivy-rich
  :doc "Have additional information in empty space of ivy buffers."
  :disabled t
  :ensure t
  :custom
  (ivy-rich-path-style 'abbreviate)
  :config
  (setcdr (assq t ivy-format-functions-alist)
          #'ivy-format-function-line)
  (ivy-rich-mode 1)
  :delight)

(use-package swiper
  :doc "A better search"
  :ensure t
  :bind (("C-s" . swiper-isearch)
         ("H-s" . isearch-forward-regexp))
  :delight)

(use-package counsel
  :doc "Ivy enhanced Emacs commands"
  :ensure t
  :bind (("M-x" . counsel-M-x)
         ("C-x C-f" . counsel-find-file)
         ("C-'" . counsel-imenu)
         ("C-c s" . counsel-rg)
         :map counsel-find-file-map
         ("RET" . ivy-alt-done))
  :delight)

(use-package git-gutter
  :doc "Shows modified lines"
  :ensure t
  :config
  (setq git-gutter:modified-sign "|")
  (setq git-gutter:added-sign "|")
  (setq git-gutter:deleted-sign "|")
  (global-git-gutter-mode t)
  :delight)

(use-package multiple-cursors
  :doc "A minor mode for editing with multiple cursors"
  :ensure t
  :config
  (setq mc/always-run-for-all t)
  :bind
  ;; Use multiple cursor bindings only when a region is active
  (:map region-bindings-mode-map
        ("C->" . mc/mark-next-like-this)
        ("C-<" . mc/mark-previous-like-this)
        ("C-c a" . mc/mark-all-like-this)
        ("C-c h" . mc-hide-unmatched-lines-mode)
        ("C-c l" . mc/edit-lines))
  :delight)

(use-package pdf-tools
  :doc "Better pdf viewing"
  :ensure t
  :mode ("\\.pdf\\'" . pdf-view-mode)
  :bind (:map pdf-view-mode-map
              ("j" . image-next-line)
              ("k" . image-previous-line))
  :config
  (pdf-tools-install)
  (add-hook 'pdf-view-mode-hook (lambda () (display-line-numbers-mode -1)))
  (setq-default pdf-view-display-size 'fit-page)
  :delight)

(use-package define-word
  :doc "Dictionary in Emacs."
  :ensure t
  :bind ("C-c w" . define-word-at-point)
  :delight)

(use-package company
  :doc "COMplete ANYthing"
  :ensure t
  :bind (:map
         global-map
         ("TAB" . company-complete-common-or-cycle)
         ;; Use hippie expand as secondary auto complete. It is useful as it is
         ;; 'buffer-content' aware (it uses all buffers for that).
         ("M-/" . hippie-expand)
         :map company-active-map
         ("C-n" . company-select-next)
         ("C-p" . company-select-previous))
  :config
  (setq company-idle-delay 0.1)
  (global-company-mode t)

  ;; Configure hippie expand as well.
  (setq hippie-expand-try-functions-list
        '(try-expand-dabbrev
          try-expand-dabbrev-all-buffers
          try-expand-dabbrev-from-kill
          try-complete-lisp-symbol-partially
          try-complete-lisp-symbol))
  :delight)


;; ────────────────────── Language Server Protocol (LSP) Client ─────────────────────────
(use-package lsp-mode
  :ensure t
  :init
  (setq lsp-keymap-prefix "C-c l")
  :hook (
         (python-mode . lsp)
         (java-mode . lsp)
         (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp)

(use-package lsp-ui
  :commands lsp-ui-mode
  :delight)

(use-package lsp-ivy
  :commands lsp-ivy-workspace-symbol
  :delight)

(use-package lsp-treemacs
  :commands lsp-treemacs-errors-list
  :delight)


;; ─────────────────────────────── Programming Languages ────────────────────────────────

;; Python Setup
;; --------------------------------------------------------------------------------------
(use-package lsp-python-ms
  :ensure t
  :init (setq lsp-python-ms-auto-install-server t)
  :hook (python-mode . (lambda ()
                          (require 'lsp-python-ms)
                          (lsp)))
  :delight)

;; Web Development Setup
;; --------------------------------------------------------------------------------------

(use-package emmet-mode
  :doc "Install for improved HTML and CSS workflow (https://emmet.io)"
  :ensure t
  :config
  (add-hook 'sgml-mode-hook 'emmet-mode) ;; Auto-start on any markup modes
  (add-hook 'css-mode-hook  'emmet-mode) ;; enable Emmet's css abbreviation.
  (setq emmet-move-cursor-between-quotes t)
  :bind ("TAB" . emmet-expand-line)
  :delight)


;; Miscellaneous Setup
;; --------------------------------------------------------------------------------------
(use-package markdown-mode
  :doc "Markdown support in Emacs. I use 'pandoc' for preview and export, which is installed
        separately via the system's package manager like 'brew install pandoc'"
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "/usr/local/bin/pandoc"))


;; ──────────────────────────────────── Look and feel ───────────────────────────────────
(use-package "faces"
  :doc "Set font and font-height. Set the height to 150 if using Emacs on Mac, else 105.
        This also assumes that you have already installed the 'Hack' font on your target system"
  :config
  (set-face-attribute 'default nil :height (if (eq system-type 'darwin) 150 105))
  (when (member "Monaco" (font-family-list))
    (set-frame-font "Monaco")))

(use-package powerline
  :doc "Better mode line"
  :ensure t
  :config
  (powerline-center-theme)
  :delight)

(use-package dired-sidebar
  :bind (("C-x C-n" . dired-sidebar-toggle-sidebar))
  :ensure t
  :commands (dired-sidebar-toggle-sidebar)
  :init
  (add-hook 'dired-sidebar-mode-hook
            (lambda ()
              (unless (file-remote-p default-directory)
                (auto-revert-mode))))
  :config
  (push 'toggle-window-split dired-sidebar-toggle-hidden-commands)
  (push 'rotate-windows dired-sidebar-toggle-hidden-commands)

  (setq dired-sidebar-subtree-line-prefix "__")
  (setq dired-sidebar-theme 'vscode)
  (setq dired-sidebar-use-term-integration t)
  (setq dired-sidebar-use-custom-font t)
  :delight)

;; I am not using this color scheme at the moment.
(use-package ewal-spacemacs-themes
  :disabled t
  :ensure t
  :config
  (setq-default spacemacs-theme-comment-bg nil
                spacemacs-theme-comment-italic t)
  (load-theme 'spacemacs-dark t)
  :delight)

(use-package doom-themes
  :ensure t
  :config
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)
  (load-theme 'doom-dark+ t)
  :delight)


;; ──────────────────────────────────── Bindings ───────────────────────────────────
(bind-key "C-j" 'newline-and-indent)

(bind-key "M-g" 'goto-line)
(bind-key "M-n" 'open-line-below)
(bind-key "M-p" 'open-line-above)
(bind-key "M-+" 'text-scale-increase)
(bind-key "M-_" 'text-scale-decrease)
(bind-key "M-k" 'kill-this-buffer)
(bind-key "M-]" 'next-buffer)
(bind-key "M-[" 'previous-buffer)
(bind-key "M-`" 'other-frame)
(bind-key "M-o" 'other-window)

(bind-key
 "C-8"
 (lambda ()
   (interactive)
   (find-file user-init-file)))

(bind-key
 "C-M-8"
 (lambda ()
   (interactive)
   (load-file user-init-file)))


;; ─────────────────────────────────── Ledger Mode ─────────────────────────────────
(use-package ledger-mode
  :ensure t
  :delight)


;; ──────────────────────────────────── Org Mode ───────────────────────────────────
(load-file "~/.emacs.d/org-config.el")

;; Open agenda view when Emacs is started.
;;(jump-to-org-agenda)
(delete-other-windows)

(provide 'init)

;;; init.el ends here
