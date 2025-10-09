;;; -*- lexical-binding: t -*-

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auto-save-default nil)
 '(custom-enabled-themes '(modus-vivendi-tritanopia))
 '(make-backup-files nil)
 '(package-selected-packages '(corfu magit orderless typescript-mode vertico)))

(windmove-default-keybindings)

(use-package eglot)

(use-package typescript-mode
  :ensure t)

(use-package vertico
  :config (vertico-mode)
  :ensure t)

(use-package corfu
  :config (global-corfu-mode)
  :ensure t)

(use-package magit
  :defer t
  :ensure t)

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion))))
  (completion-pcm-leading-wildcard t)) ;; Emacs 31: partial-completion behaves like substring

(keymap-global-set "C-c r" 'recentf)
(keymap-global-set "C-c e" 'eglot)
(keymap-global-set "C-c t" 'term)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
