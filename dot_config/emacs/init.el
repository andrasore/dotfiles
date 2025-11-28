;;; -*- lexical-binding: t -*-
 
;(require 'package)
;(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
;(package-initialize)

(setq custom-file "~/.config/emacs/custom.el")

;; FIXME move this to proper place
(custom-set-variables
 '(tab-always-indent 'complete nil nil "Customized with use-package emacs"))

(custom-set-faces
 '(default ((t ( :height 105 :width normal :family "DejaVu Sans Mono")))))
(load custom-file)

(windmove-default-keybindings)
(which-key-mode)

(use-package emacs
  :custom
  (auto-save-default nil)
  (custom-enabled-themes '(ef-trio-dark))
  (fill-column 80)
  (indent-tabs-mode nil)
  (inhibit-startup-screen t)
  (create-lockfiles nil)
  (make-backup-files nil)
  (org-startup-indented t)
  (scroll-bar-mode nil)
  (tab-width 4)
  (recentf-max-saved-items 200)
  (menu-bar-mode nil)
  (tool-bar-mode nil)
  (use-short-answers t))

(use-package eglot
  :defer t
  :ensure t)

(use-package typescript-mode
  :defer t
  :ensure t)

(use-package markdown-mode
  :defer t
  :ensure t)

(use-package yaml-mode
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

;; Enable rich annotations using the Marginalia package
(use-package marginalia
  :ensure t
  ;; Bind `marginalia-cycle' locally in the minibuffer.  To make the binding
  ;; available in the *Completions* buffer, add it to the
  ;; `completion-list-mode-map'.
  :bind (:map minibuffer-local-map
         ("M-A" . marginalia-cycle))

  ;; The :init section is always executed.
  :init

  ;; Marginalia must be activated in the :init section of use-package such that
  ;; the mode gets enabled right away. Note that this forces loading the
  ;; package.
  (marginalia-mode))

(use-package eat
  :defer t
  :ensure t
  :custom
  (eat-kill-buffer-on-exit t)
  ;; This is bc on ssh connections we cannot load terminfo
  (eat-term-name "xterm-256color"))

;; Enable auto-fill-mode for org-mode for wrapping long lines
(add-hook 'org-mode-hook #'auto-fill-mode)

;; Remap annoying set-fill-column to find-file
(keymap-global-set "C-x f" 'find-file)
;; Remap annoying list-directory to dired
(keymap-global-set "C-x C-d" 'dired)
;; Use ibuffer instead of buffer menu
(keymap-global-set "C-x C-b" 'ibuffer)
;; Extra project mappings
(keymap-global-set "C-x p R" 'project-remember-projects-under)
(keymap-global-set "C-x p F" 'project-forget-zombie-projects)

;; Custom mappings
(keymap-global-set "C-c r" 'recentf)
(keymap-global-set "C-c E" 'eglot)
(keymap-global-set "C-c e" (lambda () (interactive) (eat "/bin/bash" "")))
(keymap-global-set "C-c u" 'browse-url-xdg-open)

;; Advice for kill-region and kill-ring-save
;; https://emacs.stackexchange.com/questions/2347/kill-or-copy-current-line-with-minimal-keystrokes
(defun slick-cut (beg end)
  (interactive
   (if mark-active
       (list (region-beginning) (region-end))
     (list (line-beginning-position) (line-beginning-position 2)))))

(advice-add 'kill-region :before #'slick-cut)

(defun slick-copy (beg end)
  (interactive
   (if mark-active
       (list (region-beginning) (region-end))
     (list (line-beginning-position) (line-beginning-position 2)))))

(advice-add 'kill-ring-save :before #'slick-copy)

;; Recursive search
;; https://www.reddit.com/r/emacs/comments/skd03i/comment/hvk9pkt/
;; TODO this does not work on remote hosts
(let ((find-files-program (cond
                           ((executable-find "rg") '("rg" "--color=never" "--files"))
                           ((executable-find "find") '("find" "-type" "f")))))
(defun find-file-rec ()
  "Find a file in the current working directory recursively."
  (interactive)
  (find-file
   (completing-read "Find file: "
                    (apply #'process-lines find-files-program)))))

;; Set up some keybinds for it
(keymap-global-set "C-c f" 'find-file-rec)
(eval-after-load "dired" '(progn
  (define-key dired-mode-map (kbd "f") 'find-file-rec) ))
