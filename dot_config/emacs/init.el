;;; -*- lexical-binding: t -*-

(setq custom-file "~/.config/emacs/custom.el")

;; FIXME move this to proper place
(custom-set-variables
 '(tab-always-indent 'complete nil nil "Customized with use-package emacs"))

;; FIXME Set default font w/ custom-set-faces
(custom-set-faces
 '(default ((t (:inherit nil :extend nil :stipple nil :background "#000000" :foreground "#d0d0d0" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight medium :height 120 :width normal :foundry "CYEL" :family "Iosevka")))))

(load custom-file)

(windmove-default-keybindings)
(which-key-mode)

(use-package emacs
  :custom
  (auto-save-default nil)
  (custom-enabled-themes '(ef-dark))
  (fill-column 80)
  (indent-tabs-mode nil)
  (inhibit-startup-screen t)
  (create-lockfiles nil)
 ;; FIXME
 ;; (tab-always-indent complete)
  (make-backup-files nil)
  (org-startup-indented t)
  (scroll-bar-mode nil)
  (tab-width 4)
  (recentf-max-saved-items 200)
  (tool-bar-mode nil)
  (use-short-answers t))

(use-package eglot
  :defer t
  :ensure t)

(use-package typescript-mode
  :defer t
  :ensure t)

(use-package ef-themes
  :ensure t)

(use-package vertico
  :config
  (vertico-mode)
  :ensure t)

(use-package corfu
  :config
  (global-corfu-mode)
  (corfu-popupinfo-mode)
  :ensure t
  :custom
  (corfu-popupinfo-delay '(1.0 . 0.5)))

(use-package magit
  :defer t
  :ensure t)

(use-package undo-tree
  :config
  (global-undo-tree-mode)
  :ensure t
  :custom
  (undo-tree-auto-save-history nil))

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion))))
  (completion-pcm-leading-wildcard t)) ;; Emacs 31: partial-completion behaves like substring

;; Remap annoying set-fill-column to find-file
(keymap-global-set "C-x f" 'find-file)
;; Remap annoying list-directory to dired
(keymap-global-set "C-x C-d" 'dired)

(keymap-global-set "C-c r" 'recentf)
(keymap-global-set "C-c E" 'eglot)
(keymap-global-set "C-c e" (lambda () (interactive) (eshell "")))
 
