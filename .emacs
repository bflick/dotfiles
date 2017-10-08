(require 'package)
(add-to-list 'load-path ".config/.editor.d")
(add-to-list 'load-path ".")

(require 'package)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")))

;; @todo keybindings
;;(require 'custom)
(setq  package-list '(php-auto-yasnippets auto-yasnippet company-php deep-thought-theme
                      desktop+ geben git-commit ivy jedi-core json-reformat php-mode
                      key-chord magit multiple-cursors neotree paredit-everywhere
                      python-mode tide undo-tree web-mode fill-column-indicator
                      browse-kill-ring python-mode))

(package-initialize)

; fetch the list of packages available 
(unless package-archive-contents
  (package-refresh-contents))


; install the missing packages
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))

(setq tramp-default-method "ssh")

(setq abbrev-file-name             ;; tell emacs where to read abbrev
      "~/.emacs.d/abbrev_defs")    ;; definitions from...

(defun my/python-mode ()
  (add-to-list 'company-backends 'company-jedi))
(add-hook 'python-mode-hook 'my/python-mode)

;; aligns annotation to the right hand side
(setq company-tooltip-align-annotations t)

;; Formats the buffer before saving
(add-hook 'before-save-hook 'tide-format-before-save)

(add-hook 'typescript-mode-hook #'setup-tide-mode)
;; (add-to-list 'auto-mode-alist '("\\.go\\'" . prog-mode))

(add-to-list 'auto-mode-alist '("\\.php\\'" . php-mode))
;; (add-to-list 'auto-mode-alist '("\\.go\\'" . go-mode))
;; (add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))

(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.ts\\'" . web-mode))
(add-hook 'web-mode-hook
          (lambda ()
            (when (string-equal "ts" (file-name-extension buffer-file-name))
              (setup-tide-mode))))
;; format options
(setq tide-format-options '(:insertSpaceAfterFunctionKeywordForAnonymousFunctions t :placeOpenBraceOnNewLineForFunctions nil))

;; Manual folding function incomplete
;; (defun toggle-selective-display (column)
;;       (interactive "P")
;;       (set-selective-display
;;        (or column
;;            (unless selective-display
;;              (1+ (current-column))))))

(prefer-coding-system 'utf-8)


(require 'auto-yasnippet)
;; (require 'undo-tree)

(require 'key-chord)
(key-chord-mode 1)

;; (add-hook 'org-mode-hook 'turn-on-font-lock)

(add-hook 'php-mode-hook
         '(lambda ()
            (require 'company-php)
            (company-mode t)
            (add-to-list 'company-backends 'company-ac-php-backend )))

(add-hook 'go-mode-hook #'hs-minor-mode)
(add-hook 'prog-mode-hook #'undo-tree-mode)
(add-hook 'prog-mode-hook (lambda () (local-set-key (kbd "C-xu") (quote undo-tree-undo))))
(add-hook 'prog-mode-hook (lambda ()(local-set-key (kbd "C-xU") (quote undo-tree-redo))))

;; Define some hot keys
(key-chord-define-global "~~" 'ansi-term)
(key-chord-define-global "aa" 'hs-show-all)
(key-chord-define-global "zz" 'hs-hide-all)
(key-chord-define-global "az" 'hs-toggle-hiding)
(key-chord-define-global "pz" 'hs-hide-level)
(key-chord-define-global "bq" 'ivy-switch-buffer)
(key-chord-define-global "qs" 'swiper)
(key-chord-define-global "qq" 'counsel-ag)

;; Config
(global-set-key (kbd "<f8>") #'neo-tree-toggle)
(global-set-key (kbd "M-n") #'aya-create)
(global-set-key (kbd "M-y") #'aya-expand)
(global-set-key (kbd "M-p") 'ace-window)
(global-set-key (kbd "M-t") 'neotree-toggle)
(global-set-key (kbd "M-s") 'magit-status)
(global-set-key (kbd "C-c C-c") 'comment-region)
(global-set-key (kbd "C-c C-u") 'uncomment-region)

(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c b") 'org-iswitchb)

(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("246a51f19b632c27d7071877ea99805d4f8131b0ff7acb8a607d4fd1c101e163" default)))
 '(package-selected-packages
   (quote
    (php-cs-fixer ## deep-thought-theme magit geben company-php python-mode jedi-core json-reformat company-go web-mode undo-tree tide paredit-everywhere neotree multiple-cursors key-chord ivy git-commit desktop+ company-jedi company-emacs-eclim auto-yasnippet)))
 '(scroll-bar-mode (quote right)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


(setq inhibit-startup-screen t)
(setq inhibit-startup-echo-area-message t)
(setq inhibit-startup-buffer-menu t)

(setq initial-scratch-message "SCRATCH BUFFER...")
(delete-selection-mode t)
(setq backup-inhibited t)
(setq auto-save-default nil)
(fset 'yes-or-no-p 'y-or-n-p)
(column-number-mode t)
(show-paren-mode t)
;;(tool-bar-mode 0)
(menu-bar-mode 0)
;;(tooltip-mode nil)
(visual-line-mode)
(blink-cursor-mode 0)
(set-clipboard-coding-system 'ctext)
(set-fill-column 100)
(auto-compression-mode 1)

(icomplete-mode t)
(ido-mode)

;; symlink
(setq vc-follow-symlinks t)

;; frame title
(setq frame-title-format
      (list
       "%b - "(user-login-name)"@"(system-name)))

;; tab
(setq tab-width 4)
(setq tab-stop-list (number-sequence 4 200 4))
(setq-default indent-tabs-mode nil)

;; scroll
(menu-bar-right-scroll-bar)
(setq scroll-step 3)
(setq mouse-wheel-scroll-amount '(3))
(setq mouse-wheel-progressive-speed nil)
(setq mouse-wheel-follow-mouse 't)

;; column indicator
(require 'fill-column-indicator)
(setq fci-rule-column 80)

;; browse kill ring
(require 'browse-kill-ring)
(browse-kill-ring-default-keybindings)

;; display time
(display-time-mode t)
(setq display-time-format "%a %m-%d %H:%M")
(setq display-time-interval 30)

;; enc,eol
(set-language-environment "UTF-8")
(set-selection-coding-system 'utf-8)

;; font
;; (set-default-font "DejaVu Sans Mono-12")
;; (when window-system
;;   (set-fontset-font (frame-parameter nil 'font)
;;                     'han '("WenQuanYi Zen Hei Mono" . "unicode-bmp"))
;;   (set-fontset-font (frame-parameter nil 'font)
;;                     'cjk-misc '("WenQuanYi Zen Hei Mono" . "unicode-bmp"))
;;   (set-fontset-font (frame-parameter nil 'font)
;;                     'bopomofo '("WenQuanYi Zen Hei Mono" . "unicode-bmp"))
;;   (set-fontset-font (frame-parameter nil 'font)
;;                     'gb18030 '("WenQuanYi Zen Hei Mono" . "unicode-bmp"))
;;   (add-to-list 'default-frame-alist
;;                '(font . "DejaVu Sans Mono-12")))

;; browser
(when window-system
  (setq gnus-button-url 'browse-url-generic
        browse-url-generic-program "firefox"
        browse-url-browser-function gnus-button-url))

;; calendar, 75.9780° W
(setq calendar-latitude 36.8529)
(setq calendar-longitude -75.9780)
(setq calendar-location-name "Virginia Beach, VA")

(exit-splash-screen)


(load-theme 'deep-thought)
(autoload 'geben "geben" "DBGp protocol frontend, a script debugger" t)
(require 'key-chord)
(key-chord-mode 1)

(require 'php-mode) ;; excutable define
(require 'php-auto-yasnippets)
(setq php-auto-yasnippet-php-program "~/.emacs.d/elpa/php-autoyasnippets-2.3.1/Create-PHP-YASnippet.php")
(define-key php-mode-map (kbd "C-c C-y") 'yas/create-php-snippet)

(add-hook 'php-mode-hook
          '(lambda ()
             (require 'company-php)
             (company-mode t)
             (ac-php-core-eldoc-setup) ;; enable eldoc
             (make-local-variable 'company-backends)
             (add-to-list 'company-backends 'company-ac-php-backend)))



;; (key-chord-define-global "")
