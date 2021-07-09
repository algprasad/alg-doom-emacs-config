;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "ALG Prasad"
      user-mail-address "lanterve@asu.edu")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")
(setq projectile-project-search-path '("/home/alg/bad_slam/badslam/applications/badslam/src/badslam/"))

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;;; change `org-directory'. It must be set before org loads!
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
(require 'company)
(setq company-idle-delay 0.2
      company-minimum-prefix-length 3)

;; not sure if its supposed to be here
(use-package lsp-mode :commands lsp)
(use-package lsp-ui :commands lsp-ui-mode)
(use-package company-lsp :commands company-lsp)

(use-package ccls
  :hook ((c-mode c++-mode objc-mode cuda-mode) .
         (lambda () (require 'ccls) (lsp))))
;;(setq ccls-executable "/home/alg/ccls/Release/ccls")
(setq ccls-initialization-options '(:index (:comments 2) :completion (:detailedLabel t)))
;; direct callers
;;(lsp-find-custom "$ccls/call")
;; callers up to 2 levels
;;(lsp-find-custom "$ccls/call" '(:levels 2))
;; direct callees
;;(;;lsp-find-custom "$ccls/call" '(:callee t))

;;(lsp-find-custom "$ccls/vars")
;; Use lsp-goto-implementation or lsp-ui-peek-find-implementation (textDocument/implementation) for derived types/functions
;; $ccls/inheritance is more general

;; Alternatively, use lsp-ui-peek interface
;;(lsp-ui-peek-find-custom "$ccls/call")
;;(lsp-ui-peek-find-custom "$ccls/call" '(:callee t))

(defun ccls/callee () (interactive) (lsp-ui-peek-find-custom "$ccls/call" '(:callee t)))
(defun ccls/caller () (interactive) (lsp-ui-peek-find-custom "$ccls/call"))
(defun ccls/vars (kind) (lsp-ui-peek-find-custom "$ccls/vars" `(:kind ,kind)))
(defun ccls/base (levels) (lsp-ui-peek-find-custom "$ccls/inheritance" `(:levels ,levels)))
(defun ccls/derived (levels) (lsp-ui-peek-find-custom "$ccls/inheritance" `(:levels ,levels :derived t)))
(defun ccls/member (kind) (interactive) (lsp-ui-peek-find-custom "$ccls/member" `(:kind ,kind)))

;; References w/ Role::Role
(defun ccls/references-read () (interactive)
  (lsp-ui-peek-find-custom "textDocument/references"
    (plist-put (lsp--text-document-position-params) :role 8)))

;; References w/ Role::Write
(defun ccls/references-write ()
  (interactive)
  (lsp-ui-peek-find-custom "textDocument/references"
   (plist-put (lsp--text-document-position-params) :role 16)))

;; References w/ Role::Dynamic bit (macro expansions)
(defun ccls/references-macro () (interactive)
  (lsp-ui-peek-find-custom "textDocument/references"
   (plist-put (lsp--text-document-position-params) :role 64)))

;; References w/o Role::Call bit (e.g. where functions are taken addresses)
(defun ccls/references-not-call () (interactive)
  (lsp-ui-peek-find-custom "textDocument/references"
   (plist-put (lsp--text-document-position-params) :excludeRole 32)))

;; ccls/vars ccls/base ccls/derived ccls/members have a parameter while others are interactive.
;; (ccls/base 1) direct bases
;; (ccls/derived 1) direct derived
;; (ccls/member 2) => 2 (Type) => nested classes / types in a namespace
;; (ccls/member 3) => 3 (Func) => member functions / functions in a namespace
;; (ccls/member 0) => member variables / variables in a namespace
;; (ccls/vars 1) => field
;; (ccls/vars 2) => local variable
;; (ccls/vars 3) => field or local variable. 3 = 1 | 2
;; (ccls/vars 4) => parameter

;; References whose filenames are under this project
;;(lsp-ui-peek-find-references nil (list :folders (vector (projectile-project-root))))
;;    (setq lsp-ui-doc-include-signature nil)  ; don't include type signature in the child frame
;;    (setq lsp-ui-sideline-show-symbol nil)  ; don't show symbol on the right of info
;;(setq company-transformers nil company-lsp-async t company-lsp-cache-candidates nil)
;;(setq ccls-sem-highlight-method 'font-lock)
;; alternatively, (setq ccls-sem-highlight-method 'overlay)

;; For rainbow semantic highlighting
(ccls-use-default-rainbow-sem-highlight)
ccls-sem-function-colors
ccls-sem-macro-colors
;; ...
;;ccls-sem-member-face  ;; defaults to t :slant italic

;; To customize faces used
;;(face-spec-set 'ccls-sem-member-face
;;               '((t :slant "normal"))
;;               'face-defface-spec)
;;(ccls-call-hierarchy nil) ; caller hierarchy
;;(ccls-call-hierarchy t) ; callee hierarchy
;;(ccls-inheritance-hierarchy nil) ; base hierarchy
;;(ccls-inheritance-hierarchy t) ; derived hierarchy
;;(ccls-navigate "D") ;; roughly sp-down-sexp
;;(ccls-navigate "L")
;;(ccls-navigate "R")
;;(ccls-navigate "U")
