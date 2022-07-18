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

;;;;;;;;;;;;;;;;;;
;; Gui Settings ;;
;;;;;;;;;;;;;;;;;;

;; Turn off some unneeded UI elements
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; Display line numbers in every buffer
(global-display-line-numbers-mode 1)

;; Select theme
(when (display-graphic-p)
(load-theme 'deeper-blue)) 

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Package configuration ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Set up package.el to work with MELPA
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))

;; Download use-package
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

;; Evil mode
(use-package evil
  :ensure t
  :init
  (evil-mode 1)
  (define-key evil-normal-state-map (kbd "<SPC> q") 'evil-quit)
  (define-key evil-normal-state-map (kbd "<SPC> w") 'evil-write)
  (define-key evil-normal-state-map (kbd "<SPC> r") 'consult-recent-file)
  (define-key evil-normal-state-map (kbd "<SPC> b") 'consult-buffer)
  (define-key evil-normal-state-map (kbd "<SPC> f") 'consult-ripgrep)
  (define-key evil-normal-state-map (kbd "<SPC> p") 'consult-find)
  (define-key evil-normal-state-map (kbd "<SPC> x") 'execute-extended-command)
  (define-key evil-normal-state-map (kbd "-") 'dired-current-file-dir)
  :custom
  (evil-want-C-u-scroll t)
  )


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

;;;;;;;;;;;;;;;;;;;;;;
;; Helper functions ;;
;;;;;;;;;;;;;;;;;;;;;;

;; Helper function for Evil mode
(defun dired-current-file-dir ()
  "Opens the directory of the current buffer in dired"
  (interactive)
  (dired default-directory))
