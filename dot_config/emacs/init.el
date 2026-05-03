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
  (use-short-answers t))

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

(use-package direnv
  :ensure t
  :init
  (direnv-mode))

(use-package treesit-auto
  :ensure t
  :custom
  (treesit-auto-install 'prompt)
  :config
  ;; These are required because there is no tsx-mode installed
  ;; so treesit-auto cannot upgrade it to tsx-ts-mode
  (add-to-list 'auto-mode-alist '("\\.tsx\\'" . tsx-ts-mode))
  (add-to-list 'auto-mode-alist '("\\.jsx\\'" . tsx-ts-mode))
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
  :bind ("C-c C-c" . claude-code-ide-menu) ; Set your favorite keybinding
  :config
  (claude-code-ide-emacs-tools-setup)) ; Optionally enable Emacs MCP tools

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

;; Custom mappings
(keymap-global-set "C-c E" 'eglot)
(keymap-global-set "C-c t" (lambda () (interactive)
                             (setq current-prefix-arg '(nil))
                             (call-interactively 'vterm)))
(keymap-global-set "C-c e" (lambda () (interactive) (eshell "")))
(keymap-global-set "C-c u" 'browse-url-xdg-open)
(keymap-global-set "C-c l" 'ffap-menu)
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
