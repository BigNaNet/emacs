(version)

(org-version)

(setq user-full-name "Daniel Ferreira"
      user-mail-address "ferreira.d4.r@gmail.com")

(defun config-visit()
  "Visits my config file"
  (interactive)
  (find-file "~/.emacs.d/config.org"))
(defun config-reload()
  "Relads ~/.emacs.d/config.org at runtime"
  (interactive)
  (org-babel-load-file (expand-file-name "~/.emacs.d/config.org")))
(defun drf/append-to-path (path)
  "Add a path both to the $PATH variable and to Emacs' exec-path."
  (setenv "PATH" (concat (getenv "PATH") ":" path))
  (add-to-list 'exec-path path))
(defun drf/create-frame()
  (interactive)
  (make-frame . (transparency 90))
  (transparency 90))
(defun drf/init-file(filepath)
  (find-file filepath))

(global-set-key (kbd "C-c e") 'config-visit)
(global-set-key (kbd "C-c r") 'config-reload)
(global-set-key (kbd "C-<f1>") 'drf/create-frame)

(use-package diminish)

(add-hook 'before-save-hook 'delete-trailing-whitespace)
(add-hook 'prog-mode-hook 'subword-mode)
(delete-selection-mode t)
(setq require-final-newline t)
(setq-default fill-column 80)
(add-hook 'text-mode-hook 'turn-on-auto-fill)
(setq-default indent-tabs-mode nil)

(setq inhibit-startup-message t)
(setq initial-scratch-message nil)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(horizontal-scroll-bar-mode -1)
(fset 'yes-or-no-p 'y-or-n-p)
(show-paren-mode t)
(setq show-paren-delay 0.0)
(add-hook 'prog-mode-hook 'linum-mode)
(add-hook 'text-mode-hook 'linum-mode)
(global-hl-line-mode)
(setq-default dired-listing-switches "-Alh")

(setq scroll-preserve-screen-position 'always)
(save-place-mode 1)

(global-auto-revert-mode t)
(substitute-key-definition 'kill-buffer 'kill-buffer-and-window global-map)

(defun reset-text-size ()
  (interactive)
  (text-scale-set 0))

(define-key global-map (kbd "C-0") 'reset-text-size)
(define-key global-map (kbd "C-+") 'text-scale-increase)
(define-key global-map (kbd "C--") 'text-scale-decrease)

(define-key global-map (kbd "M-g") 'goto-line)
(define-key global-map (kbd "C-c s") 'replace-string)
(global-set-key (kbd "C-x C-b") 'ibuffer)
(global-set-key (kbd "M-SPC") 'other-frame)

(setq backup-directory-alist
        `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
        `((".*" ,temporary-file-directory t)))

(eval-after-load "linum"
  '(set-face-attribute 'linum nil :height 125))

; (use-package nord-theme
 ;  :ensure t
 ;  :config (load-theme 'nord t)
;;           (setq nord-comment-brightness 20))
  (defun transparency (value)
    "Sets the transparency of the frame window. 0=transparent/100=opaque."
    (interactive "nTransparency Value 0 - 100 opaque:")
    (set-frame-parameter (selected-frame) 'alpha value))

(use-package zenburn-theme
  :config
  (load-theme 'zenburn t)
  (transparency 90))

(use-package flycheck
  :init
  (global-flycheck-mode t))

(use-package pdf-tools
  :config (pdf-tools-install)
  (add-hook 'pdf-tools-enabled-hook 'pdf-view-midnight-minor-mode)
  (setq pdf-view-midnight-colors (quote ("#FFFFFF" . "#1C1C1C")))
)

(use-package smartparens
  :config
  (require 'smartparens-config)
  (smartparens-global-strict-mode)
  (show-smartparens-global-mode)
  (sp-local-pair 'org-mode "$$" "$$"))

(use-package magit
  :bind
  ("C-x g" . magit-status))

(use-package yaml-mode
 :config
 (add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode)))

(use-package python-mode)
 (drf/append-to-path "/home/daniel/anaconda3/bin/")
(use-package elpy
   :init
   (elpy-enable))
   :config
   (setq python-shell-interpreter "jupyter"
       python-shell-interpreter-args "-i --simple-prompt")


 (use-package ein)

 ;; use flycheck not flymake with elpy
 (when (require 'flycheck nil t)
   (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))

   (add-hook 'elpy-mode-hook 'flycheck-mode))

 ;; enable autopep8 formatting on save
 (use-package py-autopep8)

 (add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)

(use-package org
   :pin gnu
  :config
  (set-fontset-font "fontset-default" nil (font-spec :size 20 :name "Symbola"))
  (setq org-ellipsis " F")
;      (setq org-ellipsis " ⬎")
  ;(setq org-agenda-files (list "~/Scouts/Lobitos/plano.org"))
  (setq org-todo-keywords '((sequence "TODO(t)" "STARTED(s!)" "WAITING(w@)" "|" "DONE(d!)")))
  (setq org-todo-keyword-faces
  '(("TODO" . org-warning) ("STARTED" . "yellow") ("WAITING" . "orange")))
  (setq org-src-fontify-natively t)
  (setq org-src-tab-acts-natively t)
  (setq org-src-window-setup 'current-window)
  (setq org-confirm-babel-evaluate nil)
    (add-to-list 'org-structure-template-alist
               '("el" "#+BEGIN_SRC emacs-lisp\n?\n#+END_SRC"))
    (add-to-list 'org-structure-template-alist
             '("py" "#+BEGIN_SRC python\n?\n#+END_SRC")))
 (custom-set-faces '(org-ellipsis ((t (:foreground "gray70" :underline nil)))))
 (use-package org-bullets
  :config
    (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))
 (use-package ox-moderncv
    :load-path "~/.emacs.d/org-cv/"
    :init (require 'ox-moderncv))

(setq org-default-notes-file "~/Desktop/Organizer/TODO_list.org")
(define-key global-map "\C-cc" 'org-capture)

(setq exec-path (append exec-path '("/usr/bin/tex")))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)
   (latex . t)
   (ditaa . t)))

(require 'ox-beamer)

(setq jiralib-url "https://servicedesk.mindstorm.vestas.net")

(global-set-key "\C-ca" 'org-agenda)

(use-package counsel
  :init
  (ivy-mode 1)
  (counsel-mode)
  :config
  (setq ivy-use-virtual-buffers t
        ivy-count-format "(%d/%d) "
        ivy-wrap t
        ivy-extra-directories nil
        ivy-initial-inputs-alist nil
        ivy-format-function 'ivy-format-function-arrow)
  (when window-system
    (setq ivy-height 25))
  (use-package smex)
  :bind
  ("C-x B" . ivy-switch-buffer-other-window)
  ("C-s" . swiper))

(use-package avy
  :bind ("C-r" . avy-goto-word-1))

(use-package company
  :config
  (global-company-mode t)
  (setq company-idle-delay 0.1)
  (setq company-minimum-prefix-length 3)
  (define-key company-active-map (kbd "C-j") 'company-complete-selection)
  (define-key company-active-map (kbd "<tab>") 'company-complete-common-or-cycle)
  (define-key company-active-map (kbd "C-n") 'company-select-next)
  (define-key company-active-map (kbd "C-p") 'company-select-previous))

(define-advice shr-parse-image-data (:around (fn &rest args) my-emacs-25-patch)
  "Hackaround for bug#24111 in Emacs 25."
  (if shr-blocked-images
      (apply fn args)
    (cl-letf (((symbol-function 'libxml-parse-xml-region) #'buffer-substring)
              ((symbol-function 'shr-dom-to-xml)          #'identity))
      (apply fn args))))

(eval-after-load 'comint
  '(progn
     ;; originally on C-c M-r and C-c M-s
     (define-key comint-mode-map (kbd "M-p") #'comint-previous-matching-input-from-input)
     (define-key comint-mode-map (kbd "M-n") #'comint-next-matching-input-from-input)
     ;; originally on M-p and M-n
     (define-key comint-mode-map (kbd "C-c M-r") #'comint-previous-input)
     (define-key comint-mode-map (kbd "C-c M-s") #'comint-next-input)))

(add-hook
 'eshell-mode-hook
 (lambda ()
   (setq pcomplete-cycle-completions nil)))

(find-file "~/Desktop/Organizer/TODO_list.org")
    ;; fullscreen by default
    (defun fullscreen ()
           (interactive)
           (x-send-client-message nil 0 nil "_NET_WM_STATE" 32
                                '(2 "_NET_WM_STATE_FULLSCREEN" 0)))
    (fullscreen)
(setq display-time-format "%k:%M %a %d %b")

(defface egoge-display-time
      '((((type x w32 mac))
      ;; #060525 is the background colour of my default face.
      (:foreground "#56c90e" :inherit bold))
     (((type tty))
      (:foreground "green")))
   "Face used to display the time in the mode line.")

 ;; This causes the current time in the mode line to be displayed in
 ;; `egoge-display-time-face' to make it stand out visually.
 (setq display-time-string-forms
       '((propertize (concat  " " 24-hours ":" minutes " " dayname " " day " " monthname " ")
                    'face 'egoge-display-time)))
 (display-time-mode 1)

(setq )

(use-package minions
  :config
  (setq minions-mode-line-lighter ""
        minions-mode-line-delimiters '("" . ""))
  (minions-mode 1))

(when window-system
  (use-package moody
    :config
    (setq moody-mode-line-height 25
          x-underline-at-descent-line t)
    (moody-replace-mode-line-buffer-identification)
    (moody-replace-vc-mode)))

(when window-system
  (use-package beacon
  :config
  (beacon-mode 1)
  (setq beacon-blink-when-window-scrolls nil)))
