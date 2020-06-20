;;; init.el --- My Emacs configuration.
;;; Commentary:
;;; Author: Pratik Abhyankar
;;; Created on: 17 May 2020
;;; Copyright (c) 2020 Pratik Abhyankar <abhyankarpratik@gmail.com>

;;; Credit: This Emacs configuration is adapted from the GitHub repository
;;; "dot-emacs-dot-d" created by Suvrat Apte <suvratapte@gmail.com>

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
	     '("melpa" . "http://melpa.milkbox.net/packages/") t)

;; Load and activate emacs packages. Do this first so that the packages are loaded before
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

 ;; Don't use hard tabs
 indent-tabs-mode nil

 ;; Emacs can automatically create backup files. This tells Emacs to put all backups in
 ;; ~/.emacs.d/backups. More info:
 ;; http://www.gnu.org/software/emacs/manual/html_node/elisp/Backup-Files.html
 backup-directory-alist `(("." . ,(concat user-emacs-directory "backups")))

 ;; Do not autosave.
 auto-save-default nil

 ;; Allow commands to be run on minibuffers.
 enable-recursive-minibuffers t)

;; Change all yes/no questions to y/n type
(fset 'yes-or-no-p 'y-or-n-p)

;; Make the command key behave as 'meta'
(when (eq system-type 'darwin)
  (setq mac-command-modifier 'meta)
  (setq mac-right-command-modifier 'hyper))

;; `C-x o' is a 2 step key binding. `M-o' is much easier.
(global-set-key (kbd "M-o") 'other-window)

;; Unbind `save-buffers-kill-terminal` to avoid accidentally quiting Emacs.
(global-unset-key (kbd "C-x C-c"))

;; Delete whitespace just when a file is saved.
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Enable narrowing commands.
(put 'narrow-to-region 'disabled nil)
(put 'narrow-to-page 'disabled nil)

(global-set-key (kbd "H-d") 'narrow-to-defun)
(global-set-key (kbd "H-t") 'narrow-to-defun)
(global-set-key (kbd "H-w") 'widen)

;; Automatically update buffers if file content on the disk has changed.
(global-auto-revert-mode t)


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

(use-package ace-jump-mode
  :doc "Jump around the visible buffer using 'Head Chars'"
  :ensure t
  :bind ("C-." . ace-jump-mode)
  :delight)

(use-package flycheck
  :ensure t
  :config
  (global-flycheck-mode)
  :delight)


;; ─────────────────────────────── Programming Languages ────────────────────────────────
;; Install 'black' python code formattor. Required for elpy.
(use-package blacken
  :ensure t
  :delight)

(use-package elpy
  :ensure t
  :init
  (elpy-enable)
  :config
  (setq elpy-rpc-python-command "python3")
  :delight)

;; Enable Flycheck
(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))

;; Enable blacken to format on save
(add-hook 'elpy-mode-hook (lambda ()
                            (add-hook 'before-save-hook
                                      'elpy-black-fix-code nil t)))

;; Use Jupyter Python interpreter instead of default Python Interpreter
(setq python-shell-interpreter "jupyter"
      python-shell-interpreter-args "console --simple-prompt"
      python-shell-prompt-detect-failure-warning nil)
(add-to-list 'python-shell-completion-native-disabled-interpreters
             "jupyter")

;; Use Ein package for creating and running Jupyter notebooks from within Emacs
(use-package ein
  :ensure t
  :delight)


;; ──────────────────────────────────── Look and feel ───────────────────────────────────
(use-package "faces"
  :doc "Set font and font-height. Set the height to 150 if using Emacs on Mac, else 105"
  :config
  (set-face-attribute 'default nil :height (if (eq system-type 'darwin) 150 105))
  (when (member "Hack" (font-family-list))
    (set-frame-font "Hack")))

(use-package powerline
  :doc "Better mode line"
  :ensure t
  :config
  (powerline-center-theme)
  :delight)

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

;;; init.el ends here
