(require 'deft)
(setq deft-extension "org")
(setq deft-directory "~/Dropbox/deft-nodes")
(setq deft-text-mode 'org-mode)
(setq deft-use-filename-as-title t)
(global-set-key (kbd "<f6>") 'deft)

(provide 'init-deft)