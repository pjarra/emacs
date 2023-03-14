;; Variables needed
(setq font-size
      (cond
       ((equal system-name "PK-L15") 11)
       (14)))

;; This is your Emacs init file, it's where all initialization happens. You can
;; open it any time with `SPC f e i' (file-emacs-init)

;; `bootstrap.el' contains boilerplate code related to package management. You
;; can follow the same pattern if you want to split out other bits of config.
(load-file (expand-file-name "bootstrap.el" user-emacs-directory))

;; What follows is *your* config. You own it, don't be afraid to customize it to
;; your needs. Corgi is just a set of packages. Comment out the next section and
;; you get a vanilla Emacs setup. You can use `M-x find-library' to look at the
;; package contents of each. If you want to tweak things in there then just copy
;; the code over to your `user-emacs-directory', load it with `load-file', and
;; edit it to your heart's content.

(let ((straight-current-profile 'corgi))
  (use-package exec-path-from-shell :straight t
    :config
    (when (memq window-system '(mac ns x))
      (exec-path-from-shell-initialize)))

  ;; Change a bunch of Emacs defaults, from disabling the menubar and toolbar,
  ;; to fixing modifier keys on Mac and disabling the system bell.
  (use-package corgi-defaults)

  ;; UI configuration for that Corgi-feel. This sets up a bunch of packages like
  ;; Evil, Smartparens, Ivy (minibuffer completion), Swiper (fuzzy search),
  ;; Projectile (project-aware commands), Aggressive indent, Company
  ;; (completion).
  (use-package corgi-editor)

  ;; The few custom commands that we ship with. This includes a few things we
  ;; emulate from Spacemacs, and commands for jumping to the user's init.el
  ;; (this file, with `SPC f e i'), or opening the user's key binding or signals
  ;; file.
  (use-package corgi-commands)

  ;; Extensive setup for a good Clojure experience, including clojure-mode,
  ;; CIDER, and a modeline indicator that shows which REPLs your evaluations go
  ;; to.
  ;; Also contains `corgi/cider-pprint-eval-register', bound to `,,', see
  ;; `set-register' calls below.
  (use-package corgi-clojure)

  ;; https://github.com/clojure-emacs/clj-refactor.el
  ;; https://cheatography.com/bilus/cheat-sheets/clj-refactor/pdf/
  (use-package clj-refactor)
  ;; Requires clj-kondo in PATH (https://github.com/clj-kondo/clj-kondo/releases)
  (use-package flycheck-clj-kondo)

  ;; Emacs Lisp config, mainly to have a development experience that feels
  ;; similar to using CIDER and Clojure. (show results in overlay, threading
  ;; refactorings)
  (use-package corgi-emacs-lisp)

  ;; Change the color of the modeline based on the Evil state (e.g. green when
  ;; in insert state)
  (use-package corgi-stateline
    :config
    (global-corgi-stateline-mode))

  ;; Package which provides corgi-keys and corgi-signals, the two files that
  ;; define all Corgi bindings, and the default files that Corkey will look for.
  (use-package corgi-bindings)

  ;; Corgi's keybinding system, which builds on top of Evil. See the manual, or
  ;; visit the key binding and signal files (with `SPC f e k', `SPC f e K', `SPC
  ;; f e s' `SPC f e S')
  ;; Put this last here, otherwise keybindings for commands that aren't loaded
  ;; yet won't be active.
  (use-package corkey
    :config
    (corkey-mode 1)
    ;; Automatically pick up keybinding changes
    (corkey/load-and-watch)))

;; Load other useful packages you might like to use

;; Powerful Git integration. Corgi already ships with a single keybinding for
;; Magit, which will be enabled if it's installed (`SPC g s' or `magit-status').
(use-package magit)

;; Language-specific packages
(use-package org)
(use-package markdown-mode)
(use-package yaml-mode)
(use-package typescript-mode)

;; Some other examples of things you could include. There's a package for
;; everything in Emacs, so if you're missing a specific feature, see if you
;; can't find a good package that provides it.

;; Color hex color codes so you can see the actual color.
(use-package rainbow-mode)

;; A hierarchical file browser, included here as an example of how to set up
;; custom keys, see `user-keys.el' (visit it with `SPC f e k').
(use-package treemacs
  :config
  (setq treemacs-follow-after-init t)
  (treemacs-project-follow-mode)
  (treemacs-git-mode 'simple))

(use-package treemacs-evil)
(use-package treemacs-projectile)

;; REPL-driven development for JavaScript, included as an example of how to
;; configure signals, see `user-signal.el' (visit it with `SPC f e s')
(use-package js-comint)

;; Start the emacs-server, so you can open files from the command line with
;; `emacsclient -n <file>' (we like to put `alias en="emacsclient -n"' in our
;; shell config).
;;(server-start)

;; Emacs has "registers", places to keep small snippets of text. We make it easy
;; to run a snippet of Clojure code in such a register, just press comma twice
;; followed by the letter that designates the register (while in a Clojure
;; buffer with a connected REPL). The code will be evaluated, and the result
;; pretty-printed to a separate buffer.

;; By starting a snippet with `#_clj' or `#_cljs' you can control which type of
;; REPL it will go to, in case you have both a CLJ and a CLJS REPL connected.
(set-register ?k "#_clj (do (require 'kaocha.repl) (kaocha.repl/run))")
(set-register ?K "#_clj (do (require 'kaocha.repl) (kaocha.repl/run-all))")
(set-register ?r "#_clj (do (require 'user :reload) (user/reset))")
(set-register ?g "#_clj (user/go)")
(set-register ?b "#_clj (user/browse)")

;; Maybe set a nice font to go with it
(set-frame-font (format "Iosevka Fixed Extended %s" font-size))

;; Enable our "connection indicator" for CIDER. This will add a colored marker
;; to the modeline for every REPL the current buffer is connected to, color
;; coded by type.
(corgi/enable-cider-connection-indicator)

;; Create a *scratch-clj* buffer for evaluating ad-hoc Clojure expressions. If
;; you make sure there's always a babashka REPL connection then this is a cheap
;; way to always have a place to type in some quick Clojure expression evals.
(with-current-buffer (get-buffer-create "*scratch-clj*")
  (clojure-mode))

;; Connect to Babashka if we can find it. This is a nice way to always have a
;; valid REPL to fall back to. You'll notice that with this all Clojure buffers
;; get a green "bb" indicator, unless there's a more specific clj/cljs REPL
;; available.
(when (executable-find "bb")
  (corgi/cider-jack-in-babashka))

;; Not a fan of trailing whitespace in source files, strip it out when saving.
(add-hook 'before-save-hook
          (lambda ()
            (when (derived-mode-p 'prog-mode)
              (delete-trailing-whitespace))))

(add-hook 'clojure-mode-hook #'(lambda ()
                                 (clj-refactor-mode)
                                 ;; yas used by clj-refactor
                                 (yas-minor-mode 1)
                                 (cljr-add-keybindings-with-prefix "C-c r")))
(add-hook 'clojure-mode-hook #'rainbow-delimiters-mode)
(add-hook 'clojure-mode-hook #'paredit-mode)
(add-hook 'clojure-mode-hook #'flycheck-mode)

;; Enabling desktop-save-mode will save and restore all buffers between sessions
(setq desktop-restore-frames nil
      desktop-restore-eager 10)
(desktop-save-mode 1)
;;(add-to-list 'desktop-modes-not-to-save 'clojure-mode)
;;(add-to-list 'desktop-modes-not-to-save 'clojure-script-mode)

;; end of corgi defaults
;; begin of customized things

(use-package color-theme-sanityinc-tomorrow
  :config
  (load-theme 'sanityinc-tomorrow-bright))

(use-package humanoid-themes)

(defun disable-other-themes ()
  "Disables all but the most current theme."
  (interactive)
  (mapc 'disable-theme (cdr custom-enabled-themes)))

(defun set-theme ()
  "Load a theme and disable all others.
  `load-theme' stacks themes, i.e. settings from other themes
  are not disabled, unless overwritten by the new one. Most often,
  this is not what I want and leads to incompatible colors.
  All activated themes are stored in `custom-enabled-themes'.
  `set-theme' calls `load-theme' and then `disable-other-themes'."
  (interactive)
  (call-interactively 'load-theme)
  (disable-other-themes))

(defun reload-emacs-init ()
  (interactive)
  (load-file "~/.emacs.d/init.el"))

(use-package exec-path-from-shell :straight t
  :config
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)))

(when (not (eq system-type 'windows-nt))
(use-package fzf :straight t
:config
(setq fzf/args "-x --color bw --print-query --margin=1,0 --no-hscroll"
      fzf/executable "fzf"
      fzf/git-grep-args "-i --line-number %s"
        ;;;; command used for `fzf-grep-*` functions
        ;;;; example usage for ripgrep:
      fzf/grep-command "rg --no-heading -nH"
        ;;;; fzf/grep-command "grep -nrH"
        ;;;; If nil, the fzf buffer will appear at the top of the window
      fzf/position-bottom t
      fzf/window-height 15)))

(use-package rg :straight t)

(defun save-without-save-hooks ()
  "Save current buffer without executing before-save-hooks,
   or more generally, without making any changes to its current state."
  (interactive)
  (if buffer-read-only
      (save-buffer)
    (progn
      (read-only-mode 1)
      (save-buffer)
      (read-only-mode 0))))

(evil-ex-define-cmd "S[ave]" 'save-without-save-hooks)
(evil-define-command "!" nil)

;; - end -

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(beacon-color "#d54e53")
 '(custom-safe-themes
   '("191a1493fc7c3252ae949cc42cecc454900e3d4d1feb96f480cf9d1c40c093ee" "537eeec63a0fb65fb2d26e97e399692047b32e001c627665afb02b1f99d756b1" "1b8d67b43ff1723960eb5e0cba512a2c7a2ad544ddb2533a90101fd1852b426e" "06f0b439b62164c6f8f84fdda32b62fb50b6d00e8b01c2208e55543a6337433a" default))
 '(fci-rule-color "#424242")
 '(flycheck-color-mode-line-face-to-color 'mode-line-buffer-id)
 '(frame-background-mode 'dark)
 '(safe-local-variable-values
   '((elisp-lint-indent-specs
      (if-let* . 2)
      (when-let* . 1)
      (let* . defun)
      (nrepl-dbind-response . 2)
      (cider-save-marker . 1)
      (cider-propertize-region . 1)
      (cider-map-repls . 1)
      (cider--jack-in . 1)
      (cider--make-result-overlay . 1)
      (insert-label . defun)
      (insert-align-label . defun)
      (insert-rect . defun)
      (cl-defun . 2)
      (with-parsed-tramp-file-name . 2)
      (thread-first . 0)
      (thread-last . 0))
     (checkdoc-package-keywords-flag)))
 '(vc-annotate-background nil)
 '(vc-annotate-color-map
   '((20 . "#d54e53")
     (40 . "#e78c45")
     (60 . "#e7c547")
     (80 . "#b9ca4a")
     (100 . "#70c0b1")
     (120 . "#7aa6da")
     (140 . "#c397d8")
     (160 . "#d54e53")
     (180 . "#e78c45")
     (200 . "#e7c547")
     (220 . "#b9ca4a")
     (240 . "#70c0b1")
     (260 . "#7aa6da")
     (280 . "#c397d8")
     (300 . "#d54e53")
     (320 . "#e78c45")
     (340 . "#e7c547")
     (360 . "#b9ca4a")))
 '(vc-annotate-very-old-color nil)
 '(window-divider-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
