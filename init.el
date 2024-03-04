;; .emacs

(setq gc-cons-threshold 128000000)

(defvar --backup-directory (concat user-emacs-directory "backups"))

;; General configuration
(defun reasonable-settings ()
  (progn
    (global-font-lock-mode 1)
    (menu-bar-mode -1)
    ;; TODO(MP): some of these need to be in a new-frame hook of some kind
    (scroll-bar-mode -1)
    (tool-bar-mode -1)
    (auto-compression-mode 1)
    (setq undo-limit 5000000)
    (setq inhibit-startup-message t)
    (setq mouse-yank-at-point t)
    (setq font-lock-maximum-decoration t)
    (fset 'yes-or-no-p 'y-or-n-p)
    (setq buffer-file-coding-system 'utf-8)
    (prefer-coding-system 'utf-8)
    (setq default-file-name-coding-system 'utf-8)
    (setq default-keyboard-coding-system 'utf-8)
    (setq default-process-coding-system '(utf-8 . utf-8))
    (setq default-sendmail-coding-system 'utf-8)
    (setq default-terminal-coding-system 'utf-8)
    ;; (setq
    ;;  scroll-margin 0                        ;; do smooth scrolling, ...
    ;;  scroll-conservatively 100000           ;; ... the defaults ...
    ;;  scroll-up-aggressively 0.0             ;; ... are very ...
    ;;  scroll-down-aggressively 0.0           ;; ... annoying
    ;;  scroll-preserve-screen-position t)     ;; preserve screen pos with C- v/M-v
    ;; Scrolling.
    (setq scroll-margin 1
          scroll-conservatively 0
          scroll-step 1
          scroll-up-aggressively 0.01
          scroll-down-aggressively 0.01)


    (setq fast-but-imprecise-scrolling t) ; No (less) lag while scrolling lots.
    (setq jit-lock-defer-time 0) ; Just don't even fontify if we're still catching up on user input.
    ;; Good speed and allow scrolling through large images (pixel-scroll).
    ;; Note: Scroll lags when point must be moved but increasing the number
    ;;       of lines that point moves in pixel-scroll.el ruins large image
    ;;       scrolling. So unfortunately I think we'll just have to live with
    ;;       this.
                                        ; (pixel-scroll-mode)
    (setq pixel-dead-time 0) ; Never go back to the old scrolling behaviour.
    (setq pixel-resolution-fine-flag t) ; Scroll by number of pixels instead of lines (t = frame-char-height pixels).
    (setq mouse-wheel-scroll-amount '(1)) ; Distance in pixel-resolution to scroll each mouse wheel event.
    (setq mouse-wheel-progressive-speed nil) ; Progressive speed is too fast for me.
    (setq focus-follows-mouse t)
    (setq set-mark-command-repeat-pop t)

    (put 'downcase-region 'disabled nil)
    (put 'upcase-region 'disabled nil)

    (setq mode-require-final-newline nil)
    (setq indicate-empty-lines t)
    (setq frame-title-format "emacs - %b")
                                        ;(normal-top-level-add-subdirs-to-load-path)

    ;; backup files
    (if (not (file-exists-p --backup-directory))
        (make-directory --backup-directory t))
    (setq backup-directory-alist `(("." . ,--backup-directory)))
    (setq make-backup-files t               ; backup of a file the first time it is saved.
          backup-by-copying t               ; don't clobber symlinks
          version-control t                 ; version numbers for backup files
          delete-old-versions t             ; delete excess backup files silently
          kept-old-versions 6               ; oldest versions to keep when a new numbered backup is made (default: 2)
          kept-new-versions 9               ; newest versions to keep when a new numbered backup is made (default: 2)
          delete-auto-save-files t
          auto-save-default t               ; auto-save every buffer that visits a file
          auto-save-timeout 20              ; number of seconds idle time before auto-save (default: 30)
          auto-save-interval 200            ; number of keystrokes between auto-saves (default: 300)
          )
    ;; (setq backup-directory-alist `((".*" . ,(concat emacs-root "backups/"))))
    (size-indication-mode)
    ;; (desktop-save-mode 1)
    (setq-default indent-tabs-mode nil)
    (defadvice yes-or-no-p (around prevent-dialog activate)
      "Prevent yes-or-no-p from activating a dialog"
      (let ((use-dialog-box nil))
        ad-do-it))
    (defadvice y-or-n-p (around prevent-dialog-yorn activate)
      "Prevent y-or-n-p from activating a dialog"
      (let ((use-dialog-box nil))
        ad-do-it))
    (setq default-frame-alist
          '((frame-title-format . "emacs - %b")
            (menu-bar-mode . -1)
            (scroll-bar-mode . -1)
            (tool-bar-mode . -1)))
    (setq native-comp-async-report-warnings-errors nil)))

(reasonable-settings)

(global-set-key "\C-x\C-m" 'execute-extended-command)
(global-set-key "\C-c\C-m" 'execute-extended-command)
(defalias 'qrr 'query-replace-regexp)
(defalias 'qre 'query-replace-regexp-eval)
(defalias 'rr 'replace-regexp)
(defalias 'rs 'replace-string)
(defalias 'qs 'query-replace)
(defalias 'qr 'query-replace)
(global-set-key "\C-S" 'isearch-forward-regexp)
(global-set-key "\C-R" 'isearch-backward-regexp)
(define-key isearch-mode-map [backspace] 'isearch-delete-char)
;; (global-set-key "\C-i" 'my-tab)

;; where's that confounded backspace?
(global-set-key [(backspace)] 'backward-delete-char-untabify)
(global-set-key [f10]  'start-kbd-macro)
(global-set-key [f11]  'end-kbd-macro)
(global-set-key [f12]  'call-last-kbd-macro)
(global-set-key (kbd "C-c +") 'my-increment-number-decimal)
(global-set-key (kbd "C-c C-k") 'find-last-closed-file)
(global-set-key (kbd "C-c C-r") 'reformat-file)
(global-unset-key "\C-z")
(global-unset-key "\C-x\C-z")

;; Install straight.el
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; Install use-package
(straight-use-package 'use-package)

;; Configure use-package to use straight.el by default
(use-package straight
  :custom (straight-use-package-by-default t))

;;; Simple ergonomic settings and simple packages

(use-package emacs
  :demand t
  :config
  (setq my-font "DejaVu Sans Mono-11:weight=book")
  (add-to-list 'default-frame-alist `(font . ,my-font)))

;; Set up a pleasant theme
(use-package gruvbox-theme
  :demand t
  :config (load-theme 'gruvbox-dark-soft t))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package which-key
  :config (which-key-mode))

(use-package helpful
  :bind
  (("C-h f" . helpful-callable)
   ("C-h v" . helpful-variable)
   ("C-h k" . helpful-key)
   ("C-c C-d" . helpful-at-point)
   ("C-h F" . helpful-function)
   ("C-h C" . helpful-command)))

(use-package whitespace
  :config (setq whitespace-style '(face empty tabs indentation::space lines-tail trailing))
  (global-whitespace-mode t)
  :bind ("C-c w c" . whitespace-cleanup))

(use-package htmlize)

(use-package eldoc
  :config (global-eldoc-mode))

(use-package sml/setup
  :straight smart-mode-line
  :hook (after-init . 'sml/setup)
  :custom (sml/no-confirm-load-theme t)
  :config
  (sml/apply-theme 'dark))

(use-package deadgrep
  :bind ("C-c d" . deadgrep))

(use-package compat)

(use-package with-editor)

(use-package magit
  :ensure t
  :after with-editor
  :bind ("C-c s" . magit-status)
  :config (setq magit-display-buffer-function #'magit-display-buffer-fullframe-status-v1))

(use-package forge
  :after magit
  :config
  (setq auth-sources '("~/.authinfo"))
  :demand t)

(use-package magit-lfs
  :after magit)

(use-package magit-todos
  :after magit
  :config (magit-todos-mode 1))

(use-package direnv
  :config
  (direnv-mode))

;; (use-package elmacro
;;   :config
;;   (elmacro-mode))

(use-package multiple-cursors)
(use-package mc-extras
  :after multiple-cursors
  :bind
  (("C-S-c C-S-c" . #'mc/edit-lines)
   ("C->" . #'mc/mark-next-like-this)
   ("C-<" . #'mc/mark-previous-like-this)
   ("C-c C-<" . #'mc/mark-all-like-this)))

;;; Input, commands, completion etc.

;; (use-package selectrum
;;   ;; TODO(MP) configure this to work more like ido did when looking
;;   ;; for files
;;   :init (selectrum-mode +1)
;;   (setq selectrum-max-window-height 32)
;;   :bind
;;   ;; This pops the minibuffer completion list into its own buffer like
;;   ;; ido does if you hammer TAB enough
;;   (:map minibuffer-local-map
;;         ([meta tab] . switch-to-completions)))

;; (use-package selectrum-prescient
;;   :after selectrum
;;   :config
;;   (selectrum-prescient-mode +1)
;;   (prescient-persist-mode +1))

(use-package vertico
  :straight (:files (:defaults "extensions/*"))
  :init
  (vertico-mode)
  (setq vertico-count 32)
  (setq vertico-resize t))

(use-package prescient
  :init (prescient-persist-mode +1))

(use-package vertico-prescient
  :after (vertico prescient)
  :config (vertico-prescient-mode))

(use-package orderless
  :ensure t
  :custom (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package marginalia
  :hook
  (prog-mode . marginalia-mode)
  :bind (:map minibuffer-local-map
              ;; Turn margin notes on and off
              ([meta A] . marginalia-cycle)))

;; Example configuration for Consult
(use-package consult
  ;; Replace bindings. Lazily loaded due by `use-package'.
  :bind (;; C-c bindings (mode-specific-map)
         ("C-c h" . consult-history)
         ("C-c m" . consult-mode-command)
         ("C-c k" . consult-kmacro)
         ;; C-x bindings (ctl-x-map)
         ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
         ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
         ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
         ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
         ("C-x r b" . consult-bookmark)            ;; orig. bookmark-jump
         ("C-x p b" . consult-project-buffer)      ;; orig. project-switch-to-buffer
         ;; Custom M-# bindings for fast register access
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
         ("C-M-#" . consult-register)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop)                ;; orig. yank-pop
         ("<help> a" . consult-apropos)            ;; orig. apropos-command
         ;; M-g bindings (goto-map)
         ("M-g e" . consult-compile-error)
         ("M-g f" . consult-flymake)               ;; Alternative: consult-flycheck
         ("M-g g" . consult-goto-line)             ;; orig. goto-line
         ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
         ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ;; M-s bindings (search-map)
         ("M-s f" . consult-find)
         ("M-s D" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s m" . consult-multi-occur)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ;; Isearch integration
         ("M-s e" . consult-isearch-history)
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)         ;; orig. isearch-edit-string
         ("M-s e" . consult-isearch-history)       ;; orig. isearch-edit-string
         ("M-s l" . consult-line)                  ;; needed by consult-line to detect isearch
         ("M-s L" . consult-line-multi)            ;; needed by consult-line to detect isearch
         ;; Minibuffer history
         :map minibuffer-local-map
         ("M-s" . consult-history)                 ;; orig. next-matching-history-element
         ("M-r" . consult-history))                ;; orig. previous-matching-history-element

  ;; Enable automatic preview at point in the *Completions* buffer. This is
  ;; relevant when you use the default completion UI.
  :hook (completion-list-mode . consult-preview-at-point-mode)

  ;; The :init configuration is always executed (Not lazy)
  :init

  ;; Optionally configure the register formatting. This improves the register
  ;; preview for `consult-register', `consult-register-load',
  ;; `consult-register-store' and the Emacs built-ins.
  (setq register-preview-delay 0.5
        register-preview-function #'consult-register-format)

  ;; Optionally tweak the register preview window.
  ;; This adds thin lines, sorting and hides the mode line of the window.
  (advice-add #'register-preview :override #'consult-register-window)

  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  ;; Configure other variables and modes in the :config section,
  ;; after lazily loading the package.
  :config

  ;; Optionally configure preview. The default value
  ;; is 'any, such that any key triggers the preview.
  ;; (setq consult-preview-key 'any)
  ;; (setq consult-preview-key (kbd "M-.")
  ;; (setq consult-preview-key (list (kbd "<S-down>") (kbd "<S-up>")))
  ;; For some commands and buffer sources it is useful to configure the
  ;; :preview-key on a per-command basis using the `consult-customize' macro.
  (consult-customize
   consult-theme
   :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file consult-xref
   consult--source-bookmark consult--source-recent-file
   consult--source-project-recent-file
   :preview-key "M-.")

  ;; Optionally configure the narrowing key.
  ;; Both < and C-+ work reasonably well.
  (setq consult-narrow-key "<") ;; (kbd "C-+")

  ;; Optionally make narrowing help available in the minibuffer.
  ;; You may want to use `embark-prefix-help-command' or which-key instead.
  ;; (define-key consult-narrow-map (vconcat consult-narrow-key "?") #'consult-narrow-help)

  ;; By default `consult-project-function' uses `project-root' from project.el.
  ;; Optionally configure a different project root function.
  ;; There are multiple reasonable alternatives to chose from.
  ;;;; 1. project.el (the default)
  ;; (setq consult-project-function #'consult--default-project--function)
  ;;;; 2. projectile.el (projectile-project-root)
  ;; (autoload 'projectile-project-root "projectile")
  ;; (setq consult-project-function (lambda (_) (projectile-project-root)))
  ;;;; 3. vc.el (vc-root-dir)
  ;; (setq consult-project-function (lambda (_) (vc-root-dir)))
  ;;;; 4. locate-dominating-file
  ;; (setq consult-project-function (lambda (_) (locate-dominating-file "." ".git")))
  )

(use-package embark
  :after vertico

  :bind
  (("C-." . embark-act)         ;; pick some comfortable binding
   ("C-;" . embark-dwim)        ;; good alternative: M-.
   ("C-h B" . embark-bindings)) ;; alternative for `describe-bindings'

  :init

  ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command
        ;; This arguably belongs at a higher scope.
        ;;
        ;; This is mainly useful for invoking `embark` commands that
        ;; aren't part of the built-in embark-act menu.  Maybe there's
        ;; a better way, but ironically, great completion and
        ;; marginalia makes it really convenient to learn about
        ;; `embark` this way.
        enable-recursive-minibuffers 't)

  :config

  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

;; Consult users will also want the embark-consult package.
(use-package embark-consult
  :after (embark consult)
  :demand t ; only necessary if you have the hook below
  ;; if you want to have consult previews as you move around an
  ;; auto-updating embark collect buffer
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(use-package company
  :hook
  (after-init . global-company-mode))

(use-package company-prescient
  :after (company prescient)
  :init
  (company-prescient-mode +1))

;;; Snippet stuff

(use-package yasnippet
  ;; Mainly want this to help LSP stop dumping a heap of argument spam
  ;; into the buffer upon tab-complete of function names, and because
  ;; auto-yasnippet looks cool
  :config (yas-global-mode 1))

(use-package auto-yasnippet
  :after yasnippet
  :bind
  ;; As suggested in the README for this package
  (("C-c y w" . aya-create)
   ("C-c y y" . aya-expand)
   ("C-c y i" . aya-open-line)))

(use-package sort-words)

;;; LSP setup

(use-package project)

(use-package flycheck
  :bind (:map flycheck-mode
              ("M-n" . flycheck-next-error)
              ("M-p" . flycheck-previous-error))
  :init
  (set-face-attribute 'flycheck-warning nil
                      :underline "orange" :weight 'bold)
  (set-face-attribute 'flycheck-error nil
                      :underline "red" :weight 'bold))

;; TODO(MP): figure out how to pull C++ query-driver information
(use-package lsp-mode
  :after flycheck
  :hook
  (haskell-mode . lsp)
  (c++-mode . lsp)
  (python-mode . lsp)
  (lsp-mode . lsp-enable-which-key-integration)
  :init
  ;; TODO(@peddie) why is this never applied until after LSP has
  ;; already started up and failed to do anything useful?
  (setq lsp-clients-clangd-args
        '("-j=6"
          "--pch-storage=disk"
          "--header-insertion-decorators=0"
          "--header-insertion=never"
          "--clang-tidy"
          "--malloc-trim"
          "--background-index"
          "--background-index-priority=background"
          "--query-driver=/nix/store/fdc528iwh63zzgss4w328q9dfcnn9b3g-clang-wrapper-16.0.6/bin/clang++"))
  :config
  ;; TODO(@peddie) why is this never applied until after LSP has
  ;; already started up and failed to do anything useful?
  (setq lsp-clients-clangd-args
        '("-j=6"
          "--pch-storage=disk"
          "--header-insertion-decorators=0"
          "--header-insertion=never"
          "--clang-tidy"
          "--malloc-trim"
          "--background-index"
          "--background-index-priority=background"
          "--query-driver=/nix/store/fdc528iwh63zzgss4w328q9dfcnn9b3g-clang-wrapper-16.0.6/bin/clang++"))
  :bind
  (:map lsp-mode-map
        ("C-c l p" . lsp-describe-thing-at-point)
        ("C-c l d" . lsp-find-definition)
        ("C-c l c" . lsp-find-declaration)
        ("C-c l t" . lsp-find-type-definition)
        ("C-c l r" . lsp-find-references)
        ("C-c l i" . lsp-find-implementation)
        ("C-c l e" . flycheck-list-errors))
  :config
  (setq read-process-output-max (* 1024 8192)
        lsp-enable-suggest-server-download nil)
  (lsp-register-custom-settings
   '(;; `mypy` integration seems nice, but a) you need to install a
     ;; lot of type stubs, and even then, many of our libs don't have
     ;; type info available and b) it doesn't seem to ever actually
     ;; identify anything
     ;;
     ;; ("pyls.plugins.pyls_mypy.enabled" t t)
     ;; ("pyls.plugins.pyls_mypy.live_mode" nil t)
     ("pyls.plugins.pyls_black.enabled" t t)
     ("pyls.plugins.pyls_isort.enabled" t t)))
  :commands lsp)

(use-package lsp-ui
  :after lsp-mode
  :commands lsp-ui-mode
  :bind
  ;; These sem to be the main useful things -- but sadly there is no
  ;; toggle functionality.
  (:map lsp-mode-map
        ("C-c l s" . lsp-ui-doc-show)
        ("C-c l a" . lsp-ui-doc-hide))
  :config
  (setq lsp-ui-sideline-diagnostic-max-line-length 100
        lsp-ui-sideline-diagnostic-max-lines 5))

(use-package consult-lsp
  :after lsp-mode
  :bind
  (:map lsp-mode-map
        ("C-c l o d" . consult-lsp-diagnostics)
        ("C-C l o s" . consult-lsp-symbols)))

;; (use-package treemacs)

;; (use-package lsp-treemacs
;;   :after (lsp-mode treemacs)
;;   :config (lsp-treemacs-sync-mode 1)
;;   :bind
;;   (:map lsp-mode-map
;;         ("C-c t r" . lsp-treemacs-references)
;;         ("C-c t i" . lsp-treemacs-implementations)
;;         ("C-c t e" . lsp-treemacs-errors-list)
;;         ("C-c t t" . lsp-treemacs-type-hierarchy)
;;         ("C-c t h" . lsp-treemacs-call-hierarchy)))

(use-package company-lsp)

;; nil setup
(use-package lsp-nix
  :ensure lsp-mode
  ;; Not a separate package.
  :straight f
  :after (lsp-mode)
  :demand t
  :custom
  (lsp-nix-nil-formatter ["nixpkgs-fmt"]))

;;; Programming language modes

(use-package tree-sitter)
(use-package tree-sitter-langs
  :init (global-tree-sitter-mode)
  :hook (tree-sitter-hl-mode tree-sitter-after-on-hook))

(use-package haskell-mode)

(use-package rust-mode)

(use-package ess
  :config (ess-toggle-underscore nil)
  :hook (inferior-ess-mode . (lambda ()
                               (setq-local ansi-color-for-comint-mode 'filter))))

;; (use-package ess-smart-underscore
;;   :after ess)
(use-package poly-R
  :after ess)

(use-package yaml-mode)
(use-package bazel)
(use-package nix-mode
  :bind
  (:map nix-mode-map
        ("C-c \\" . nix-format-buffer))
  :hook (nix-mode . lsp-deferred)
  :ensure t)
(use-package markdown-mode)
(use-package cmake-mode)
(use-package stan-mode)
(use-package protobuf-mode)
(use-package jenkinsfile-mode)
(use-package dockerfile-mode)

(use-package elpy
  :bind
  (:map elpy-mode-map
        ("M-n" . elpy-flymake-next-error)
        ("M-p" . elpy-flymake-previous-error)
        ("C-c \\" . elpy-black-fix-code)))

;;; Org-mode
(use-package org
  :config
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (ditaa . t)
     (haskell . t)
     (stan . t)
     ; (jupyter . t)
     (python . t)))
  :custom
  (org-confirm-babel-evaluate nil)
  :init
  ;; Not sure how to make this happen using the :hook keyword
  (add-hook 'org-babel-after-execute-hook 'org-display-inline-images 'append))

(use-package kubernetes)

(use-package emacs-gc-stats
  :init (emacs-gc-stats-mode +1)
  :config (setq emacs-gs-stats-gc-defaults 'emacs-defaults))

(use-package realgud)

;; Crashes on use
;;
;; (use-package s3ed
;;   :init
;;   (s3ed-mode))

;; (require 're-builder)
    ;; (setq reb-re-syntax 'string)

(defun my-c++-setup ()
   (c-set-offset 'innamespace [0]))
(add-hook 'c++-mode-hook 'my-c++-setup)

(defun unfill-paragraph ()
  (interactive)
  (let ((fill-column (point-max)))
    (fill-paragraph nil)))

(defun my-tab
    (&optional pre-arg)
  "If preceeding character is part of a word then dabbrev-expand,
else if right of non whitespace on line then tab-to-tab-stop or
indent-relative, else if last command was a tab or return then dedent
one step, else indent 'correctly'"
  (interactive "*P")
  (cond ((= (char-syntax (preceding-char)) ?w)
         (let ((case-fold-search t)) (dabbrev-expand pre-arg)))
        ((> (current-column) (current-indentation))
         (indent-relative))
        (t (indent-according-to-mode)))
  (setq this-command 'my-tab))

(defadvice kill-ring-save
    (before slick-copy activate compile)
  "When called interactively with no active region, copy a single line instead."
  (interactive (if mark-active (list (region-beginning) (region-end))
                 (message "Copied line")
                 (list
                  (line-beginning-position)
                  (line-beginning-position 2)))))

(defadvice kill-region (before slick-cut activate compile)
  "When called interactively with no active region, kill a single line instead."
  (interactive
   (if mark-active (list (region-beginning) (region-end))
     (list (line-beginning-position)
           (line-beginning-position 2)))))

;;; https://anirudhsasikumar.net/blog/2005.01.21.html
(define-minor-mode sensitive-mode
  "For sensitive files like password lists.
It disables backup creation and auto saving.

With no argument, this command toggles the mode.
Non-null prefix argument turns on the mode.
Null prefix argument turns off the mode."
  ;; The initial value.
  nil
  ;; The indicator for the mode line.
  " Sensitive"
  ;; The minor mode bindings.
  nil
  (if (symbol-value sensitive-mode)
      (progn
        ;; disable backups
        (set (make-local-variable 'backup-inhibited) t)
        ;; disable auto-save
        (if auto-save-default
            (auto-save-mode -1)))
    ;resort to default value of backup-inhibited
    (kill-local-variable 'backup-inhibited)
    ;resort to default auto save setting
    (if auto-save-default
        (auto-save-mode 1))))

(setq auto-mode-alist
      (append '(("\\.gpg$" . sensitive-mode)
                (".authinfo$" . sensitive-mode))
               auto-mode-alist))

(garbage-collect)
;; 64 MB should be enough for anybody
(setq gc-cons-threshold (* 1024 1024 64))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auth-source-save-behavior nil)
 '(warning-suppress-log-types '((emacs))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
