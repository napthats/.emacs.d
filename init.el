;;クリップボード共有
(setq x-select-enable-clipboard t)

;;elisp用load-path
(setq load-path (cons "~/.emacs.d/elisp/" load-path))

;;cperlモード
(defalias 'perl-mode 'cperl-mode)
(setq cperl-indent-level 4)
(setq cperl-continued-statement-offset 4)
;;(setq cperl-comment-column 40)
(setq indent-tabs-mode nil);
(setq cperl-close-paren-offset -4)
(global-set-key "\M-p" 'cperl-perldoc)
;;(setq cperl-indent-parens-as-block t)
(add-hook 'cperl-mode-hook
          '(lambda ()
             (progn
                (setq indent-tabs-mode nil)
                (setq tab-width nil))))
(defadvice cperl-indent-command
  (around cperl-indent-or-complete)
  "Changes \\[cperl-indent-commnd] so it autocompletes when at the end of a word."
  (if (looking-at "\\>")
      (dabbrev-expand nil)
  ad-do-it))
  (eval-after-load "cperl-mode"
    '(progn (require 'dabbrev) (ad-activate 'cperl-indent-command)))

;;リージョン内のperlコード実行
(defun perl-eval (beg end)
  "Run selected region as Perl code"
  (interactive "r")
  (shell-command-on-region beg end "perl"))
(global-set-key "\C-cr" 'perl-eval)

;;perldbとかコンパイルとか
(defun my-perl-run ()
  (interactive)
  (let ((file-name (buffer-file-name (current-buffer))))
    (setq compile-command (concat "perl \"" file-name "\""))
    (call-interactively 'compile)))

(defun my-perl-check-syntax ()
  (interactive)
  (let ((file-name (buffer-file-name (current-buffer))))
    (setq compile-command (concat "perl -wc \"" file-name "\""))
    (call-interactively 'compile)))

(defun my-perldb ()
  (interactive)
  (require 'gud)
  (add-to-list 'gud-perldb-history
               (format "perl -d %s"
					   (file-name-nondirectory
						(buffer-file-name (current-buffer)))))
  (call-interactively 'cperl-db))

(add-hook 'cperl-mode-hook
          '(lambda()
             (progn
               (define-key cperl-mode-map "\C-c\C-c" 'my-perl-run)
               (define-key cperl-mode-map "\C-cs" 'my-perl-check-syntax)
               (define-key cperl-mode-map "\C-cd" 'my-perldb))))

;;Ctrl+hでバックスペース
(global-set-key "\C-h" 'delete-backward-char)
(define-key isearch-mode-map "\C-h" 'isearch-delete-char)

;;ツールバー非表示
;;(custom-set-variables
;;'(tool-bar-mode nil nil (tool-bar)))
(tool-bar-mode -1)
(menu-bar-mode -1)


(require 'ibus)
(add-hook 'after-init-hook 'ibus-mode-on)

;; C-SPC は Set Mark に使う
;;(ibus-define-common-key ?\C-\s nil)
;; C-/ は Undo に使う
(ibus-define-common-key ?\C-/ nil)
;; C-\も奪われたくない
(ibus-define-common-key ?\C-. t)
(ibus-define-common-key ?\C-, t)
;; IBusの状態によってカーソル色を変化させる
;;(setq ibus-cursor-color '("red" "blue" "limegreen"))
;; C-j で半角英数モードをトグルする
;;(ibus-define-common-key ?\C-j t)


