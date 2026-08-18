;;; -*- lexical-binding: t -*-
 
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(setq custom-file "~/.config/emacs/custom.el")

;; FIXME move this to proper place
(custom-set-variables
 '(tab-always-indent 'complete nil nil "Customized with use-package emacs"))

(custom-set-faces
 '(default ((t ( :height 100 :width normal :family "DejaVu Sans Mono")))))
(load custom-file)

(which-key-mode)

(use-package emacs
  :custom
  (auto-save-default nil)
  (custom-enabled-themes '(modus-vivendi-tinted))
  (fill-column 80)
  (indent-tabs-mode nil)
  (inhibit-startup-screen t)
  (create-lockfiles nil)
  (make-backup-files nil)
  (dired-listing-switches "-alFh")
  (dired-create-destination-dirs 'ask)
  (org-startup-indented t)
  (scroll-bar-mode nil)
  (tab-width 4)
  (recentf-max-saved-items 200)
  (ring-bell-function 'ignore)
  (menu-bar-mode nil)
  (tool-bar-mode nil)
  (use-short-answers t)
  (initial-frame-alist
       '((top . 1) (left . 1) (width . 120) (height . 40))))

(use-package ef-themes
  :ensure t)

(use-package treemacs
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
  :ensure t
  :custom
  (magit-save-repository-buffers 'dontask)
  (magit-process-apply-ansi-colors t))

(use-package org
  :config
  (setq org-default-notes-file (concat org-directory "/notes.org"))
  :bind
  (("C-c l" . org-store-link)
  ("C-c a" . org-agenda)
  ("C-c c" . org-capture)))

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
  (completion-category-defaults nil)
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

(use-package eshell-vterm
  :defer t
  :ensure t)

(use-package vterm
  :defer t
  :ensure t
  :config
  (eshell-vterm-mode))

(use-package envrc
  :ensure t
  :custom
  (envrc-remote t)
  :config
  (envrc-global-mode))

(use-package treesit-auto
  :ensure t
  :custom
  (treesit-auto-install 'prompt)
  :config
  ;; These are required because there is no tsx-mode installed
  ;; so treesit-auto cannot upgrade it to tsx-ts-mode
  (add-to-list 'auto-mode-alist '("\\.tsx\\'" . tsx-ts-mode))
  (add-to-list 'auto-mode-alist '("\\.jsx\\'" . tsx-ts-mode))
  ;; TODO this is not entirely correct
  (add-to-list 'auto-mode-alist '("Dockerfile" . dockerfile-ts-mode))
  (add-to-list 'auto-mode-alist '("\\.jsonc\\'" . json-ts-mode))

  (global-treesit-auto-mode))

(use-package consult
  :ensure t
  :init
  (recentf-mode)
  :custom
  (consult-preview-key "M-.")
  :bind (
         ("C-x b" . consult-buffer)
         ("C-c r" . consult-recent-file)
         ("C-c f" . consult-fd)
         ("C-c g" . consult-ripgrep)))

(use-package claude-code-ide
  :vc (:url "https://github.com/manzaltu/claude-code-ide.el" :rev :newest)
  :bind ("C-c C" . claude-code-ide-menu)
  :config
  (claude-code-ide-emacs-tools-setup)
  :custom
  (claude-code-ide-use-side-window nil)) 

;; Enable auto-fill-mode for org-mode for wrapping long lines
(add-hook 'org-mode-hook #'auto-fill-mode)

;; Use ibuffer instead of buffer menu
(keymap-global-set "C-x C-b" 'ibuffer)
;; kill-current-buffer instead of kill-buffer
(keymap-global-set "C-x k" 'kill-current-buffer)
;; extra project mappings
(keymap-global-set "C-x p R" 'project-remember-projects-under)
(keymap-global-set "C-x p F" 'project-forget-zombie-projects)
;; Easier buffer navigation
(keymap-global-set "C-," 'previous-buffer)
(keymap-global-set "C-." 'next-buffer)

;; Remap these for better ergonomics
(keymap-global-set "C-x C-d" 'dired) ; replaces list-directory
(keymap-global-set "C-x f" 'find-file) ; replaces set-fill-column


(defun my/project-dired ()
  "Prompt for a known project and open Dired in its root."
  (interactive)
  (dired (project-prompt-project-dir)))

(keymap-global-set "C-x p p" 'my/project-dired)

;; Custom mappings
(keymap-global-set "C-c E" 'eglot)
(keymap-global-set "C-c t" (lambda () (interactive)
                             (setq current-prefix-arg '(nil))
                             (call-interactively 'vterm)))
(keymap-global-set "C-c e" (lambda () (interactive) (eshell "")))
(keymap-global-set "C-c u" 'ffap-menu)
(keymap-global-set "C-c T" 'treemacs)


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


;; ffap-menu fix - TODO remove when using emacs 31
;; https://github.com/minad/vertico?tab=readme-ov-file#ffap-menu-fixed-on-emacs-31
(advice-add #'ffap-menu-ask :around
            (lambda (&rest args)
              (cl-letf (((symbol-function #'minibuffer-completion-help)
                         #'ignore))
                (apply args))))


;; Monorepo fix for Eglot
(defvar eglot-project-roots '("package.json")
  "List of files/directories that indicate an Eglot project root.")

(defun my/eglot-project-find-function (dir)
  "Find project root for Eglot only, using `eglot-project-roots'.
Returns nil if not called from an Eglot context or no root marker is found."
  (when (bound-and-true-p eglot-lsp-context)
    (let ((root (locate-dominating-file dir
                  (lambda (d)
                    (seq-some (lambda (marker)
                                (file-exists-p (expand-file-name marker d)))
                              eglot-project-roots)))))
      (when root
        (cons 'transient root)))))

;; https://emacs.stackexchange.com/a/64263
(use-package project
  ;; Cannot use :hook because 'project-find-functions does not end in -hook
  ;; Cannot use :init (must use :config) because otherwise
  ;; project-find-functions is not yet initialized.
  :config
(add-hook 'project-find-functions #'my/eglot-project-find-function))

;; Window split only when frame is fullscreen
(defun my/split-window-maybe (window)
  "Split WINDOW only when frame is fullscreen or maximized."
  (when (memq (frame-parameter nil 'fullscreen) '(fullscreen maximized))
    (split-window-sensibly window)))

(setq split-window-preferred-function #'my/split-window-maybe)
