;;;;;;;;;;;;;;;;;;;;;;
;; General Settings ;;
;;;;;;;;;;;;;;;;;;;;;;

;; Enable recent file mode
(recentf-mode 1)
(setq recentf-max-saved-items 50)

;; Save what you enter into minibuffer prompts
(setq history-length 50)
(savehist-mode 1)

;; Remember and restore the last cursor location of opened files
(save-place-mode 1)

;; Move customization variables to a separate file and load it
(setq custom-file (locate-user-emacs-file "custom-vars.el"))
(load custom-file 'noerror 'nomessage)

;; Refresh buffers when the underlying file has changed
(global-auto-revert-mode 1)

;; Refresh Dired and other buffers
(setq global-auto-revert-non-file-buffers t)

;; Don't show the splash screen
(setq inhibit-startup-message t) 

;; Display line numbers in every buffer
(global-display-line-numbers-mode 1)
(setq display-line-numbers-type 'relative)

;;;;;;;;;;;;;;;;;;
;; Gui Settings ;;
;;;;;;;;;;;;;;;;;;

;; Turn off some unneeded UI elements
(menu-bar-mode -1)
(tool-bar-mode -1)

;; Apply the following settings conditionally
;; Not all Emacs installs have GUI support
(when (display-graphic-p)
    (scroll-bar-mode -1)
    ;; Select theme
    (load-theme 'deeper-blue)
    ;; Set font - TODO - check if exists
    (set-frame-font "Iosevka 12" nil t)
) 

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Package configuration ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Set up package.el to work with MELPA
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))

;; Download use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; Evil mod
(use-package evil
  :ensure t
  :init
  ;; Disable evil-keybindings because of evil-collection. See
  ;; https://github.com/emacs-evil/evil-collection/issues/60
  (setq evil-want-keybinding nil)
  (evil-mode 1)
  (define-key evil-normal-state-map (kbd "<SPC> q") 'evil-quit)
  (define-key evil-normal-state-map (kbd "<SPC> w") 'evil-write)
  (define-key evil-normal-state-map (kbd "<SPC> r") 'consult-recent-file)
  (define-key evil-normal-state-map (kbd "<SPC> b") 'consult-buffer)
  (define-key evil-normal-state-map (kbd "<SPC> f") 'consult-ripgrep)
  (define-key evil-normal-state-map (kbd "<SPC> p") 'consult-find)
  (define-key evil-normal-state-map (kbd "<SPC> x") 'execute-extended-command)
  (define-key evil-normal-state-map (kbd "<SPC> gg") 'magit)
  (define-key evil-normal-state-map (kbd "<SPC> gf") 'magit-file-dispatch)
  (define-key evil-normal-state-map (kbd "C-h") 'evil-window-left)
  (define-key evil-normal-state-map (kbd "C-l") 'evil-window-right)
  (define-key evil-normal-state-map (kbd "C-j") 'evil-window-down)
  (define-key evil-normal-state-map (kbd "C-k") 'evil-window-up)
  (define-key evil-normal-state-map (kbd "-") 'dired-current-file-dir)
  :custom
  (evil-want-C-u-scroll t)
  )

(use-package evil-collection
  :ensure t
  :after (:all evil)
  :init (evil-collection-init))

;; doom-modeline for modeline

(use-package doom-modeline
  :ensure t
  :init
  (doom-modeline-mode 1)
  (setq doom-modeline-height 14))

;; Install doom themes

(use-package doom-themes
  :ensure t)

;; Company for in-buffer completion
(use-package company
  :ensure t
  :config
  (global-company-mode))

;; Selectrum for minibuffer selection
(use-package selectrum
  :ensure t
  :init
  (selectrum-mode +1)
  )

(use-package selectrum-prescient
  :ensure t
  :init
  (selectrum-prescient-mode +1)
  (prescient-persist-mode +1)
  )

;; consult.el for additional completion commands
(use-package consult
  :ensure t)

;; Magit for git

(use-package magit
  :ensure t)

;;;;;;;;;;;;;;;;;;;;;;
;; Helper functions ;;
;;;;;;;;;;;;;;;;;;;;;;

;; Helper function for Evil mode
(defun dired-current-file-dir ()
  "Opens the directory of the current buffer in dired"
  (interactive)
  (dired default-directory))
