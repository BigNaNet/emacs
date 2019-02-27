
(version)

(org-version)

(setq user-full-name "Daniel Ferreira"
      user-mail-address "ferreira.d4.r@gmail.com")

(use-package diminish)

(add-hook 'before-save-hook 'delete-trailing-whitespace)
(add-hook 'prog-mode-hook 'subword-mode)
(delete-selection-mode t)
(setq require-final-newline t)
(setq-default fill-column 80)
;;(add-hook 'text-mode-hook 'turn-on-auto-fill)

(setq inhibit-startup-message t)
(setq initial-scratch-message nil)
(tool-bar-mode -1)
;; (menu-bar-mode -1)
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
(windmove-default-keybindings)
(setq windmove-wrap-around t)

(defun reset-text-size ()
  (interactive)
  (text-scale-set 0))

(define-key global-map (kbd "C-0") 'reset-text-size)
(define-key global-map (kbd "C-+") 'text-scale-increase)
(define-key global-map (kbd "C--") 'text-scale-decrease)

(define-key global-map (kbd "M-g") 'goto-line)

(global-set-key (kbd "C-x C-b") 'ibuffer)
(global-set-key (kbd "M-SPC") 'other-frame)

(setq backup-directory-alist
        `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
        `((".*" ,temporary-file-directory t)))

(eval-after-load "linum"
  '(set-face-attribute 'linum nil :height 125))

(defun drf/append-to-path (path)
  "Add a path both to the $PATH variable and to Emacs' exec-path."
  (setenv "PATH" (concat (getenv "PATH") ":" path))
  (add-to-list 'exec-path path))

(defun drf/init-file(filepath)
  (find-file filepath))

; (use-package nord-theme
 ;  :ensure t
 ;  :config (load-theme 'nord t)
;;           (setq nord-comment-brightness 20))

(use-package zenburn-theme
  :config (load-theme 'zenburn t))

(use-package flycheck
  :init
  (global-flycheck-mode t))

(use-package pdf-tools
  :config (pdf-tools-install)
  (add-hook 'pdf-tools-enabled-hook 'pdf-view-midnight-minor-mode)
  (setq pdf-view-midnight-colors (quote ("#FFFFFF" . "#1C1C1C")))
)

(use-package smartparens
  :diminish smartparens-mode
  :config
  (smartparens-global-mode)
  (sp-pair "'" nil :unless '(sp-point-after-word-p)))

(use-package magit
   :init
   (drf/append-to-path "/ifs/opt/app/git/2.8.1-gcc/bin"))

(use-package python-mode)
(drf/append-to-path "~/.local/bin")
(add-hook 'python-mode-hook'(lambda () (auto-complete-mode -1)))
(add-hook 'python-mode-hook'(lambda () (jedi-mode -1)))
(use-package elpy
  :config (elpy-enable))

;(use-package company-jedi)
;(add-to-list 'company-backends 'company-jedi)

;(add-hook 'python-mode-hook 'jedi:setup)

(use-package jedi
  :init
  (add-hook 'python-mode-hook 'jedi:setup)
  (add-hook 'python-mode-hook 'jedi:ac-setup))
  (setq jedi:complete-on-dot t)

(use-package ein)
(add-hook 'ein:connect-mode-hook 'ein:jedi-setup)

(setq python-shell-interpreter "jupyter"
      python-shell-interpreter-args "console --simple-prompt"
      python-shell-prompt-detect-failure-warning nil)
(add-to-list 'python-shell-completion-native-disabled-interpreters
             "jupyter")

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
  (setq org-ellipsis " ⬎")

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

(use-package org-bullets
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

(setq exec-path (append exec-path '("/usr/bin/tex")))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)
   (latex . t)))

(require 'ox-beamer)

(use-package ivy
  :diminish ivy-mode
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq ivy-count-format "(%d/%d) ")
  (setq ivy-extra-directories ()))

(use-package swiper
  :bind
  ("C-s" . swiper)
  ("C-r" . swiper))

(use-package company
  :config (global-company-mode t)
  (setq company-idle-delay 0)
  (setq company-minimum-prefix-length 3)
  (define-key company-active-map (kbd "<tab>") 'company-complete)
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

(find-file "~/Desktop/Jira_Tasks/what_to_do.org")
    ;; fullscreen by default
    (defun fullscreen ()
           (interactive)
           (x-send-client-message nil 0 nil "_NET_WM_STATE" 32
                                '(2 "_NET_WM_STATE_FULLSCREEN" 0)))
    (fullscreen)
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
       '((propertize (concat " " 24-hours ":" minutes " ")
                    'face 'egoge-display-time)))
 (display-time-mode 1)

(setq )
