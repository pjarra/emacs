;;; -*- no-byte-compile: t -*-

;; This is your user signals file, here you configure how certain signals are
;; handled in specific modes.

;; In this Corgi sample config we've included `js-comint' to demonstrate how
;; that works. This package allows evaluating JavaScript directly from a buffer.
;; Evaluating the expression before the cursor is done in Corgi with `, RET' (or
;; `, e e'), by telling Corgi that in JS buffers this means `js-send-last-sexp'
;; we get the same bindings there.
;;
;; If you prefer some other key binding for "eval", then you can do that in
;; `user-keys.el', and your new binding will do the right thing regardless of
;; the language/mode you are in.

((default (
           :kill-to-eol kill-line
           :toggle-truncate-mode toggle-truncate-lines
           :reload-init-file reload-emacs-init
           :set-theme set-theme))
 (clojure-mode (
                :sexp/slurp-backward sp-backward-slurp-sexp
                :sexp/barf-backward sp-backward-barf-sexp
                :kill-to-eol paredit-kill
                :cider-format-region cider-format-region
                :cider-format-defun cider-format-defun
                :search-in-project rg-dwim-project-dir
                :wrap/unwrap sp-splice-sexp
                :wrap/wrap-round paredit-wrap-round
                :wrap/wrap-square paredit-wrap-square
                :wrap/wrap-angled paredit-wrap-angled
                :wrap/wrap-curly paredit-wrap-curly
                :eval/defun-at-point cider-eval-defun-at-point))
 (clojurescript-mode (
                      :repl/set-ns cider-change-ns-to-current))
 (cider-repl-mode (:kill-to-eol paredit-kill))
 (js-mode (
           :eval/last-sexp js-send-last-sexp
           :eval/buffer js-send-buffer
           :eval/region js-send-region
           :repl/toggle js-comint-start-or-switch-to-repl)))
