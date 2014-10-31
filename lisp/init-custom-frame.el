(defun set-default-frame-size ()
  (interactive)
  (progn
    (if (>= (x-display-pixel-width) 1280)
        (add-to-list 'default-frame-alist (cons 'width 140))
      (add-to-list 'default-frame-alist (cons 'width 80)))
    (add-to-list 'default-frame-alist (cons 'height (/ (- (x-display-pixel-height) 200) (frame-char-height))))
    (set-frame-width (selected-frame) 140)
    (message "setup frame width finish!")))

;;(set-default-frame-size)
(add-to-list 'default-frame-alist '(font . "Ubuntu Mono-14"))
(set-face-attribute 'default t :font  "Ubuntu Mono-14")

(provide 'init-custom-frame)