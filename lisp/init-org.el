(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)

;; {{ export org-mode in Chinese into PDF
;; @see http://freizl.github.io/posts/tech/2012-04-06-export-orgmode-file-in-Chinese.html
;; and you need install texlive-xetex on different platforms
;; To install texlive-xetex:
;;    `sudo USE="cjk" emerge texlive-xetex` on Gentoo Linux
(setq org-latex-pdf-process
      '("xelatex -interaction nonstopmode -output-directory %o %f"
        "xelatex -interaction nonstopmode -output-directory %o %f"
        "xelatex -interaction nonstopmode -output-directory %o %f"))
;; }}

(if (and *is-a-mac* (file-exists-p "/Users/tangcheng/Applications/LibreOffice.app/Contents/MacOS/soffice"))
    (setq org-export-odt-convert-processes '(("LibreOffice" "/Users/tangcheng/Applications/LibreOffice.app/Contents/MacOS/soffice --headless --convert-to %f%x --outdir %d %i"))))

;; @see https://gist.github.com/mwfogleman/95cc60c87a9323876c6c
(defun narrow-or-widen-dwim ()
  "If the buffer is narrowed, it widens. Otherwise, it narrows to region, or Org subtree."
  (interactive)
  (cond ((buffer-narrowed-p) (widen))
        ((region-active-p) (narrow-to-region (region-beginning) (region-end)))
        ((equal major-mode 'org-mode) (org-narrow-to-subtree))
        (t (error "Please select a region to narrow to"))))

;; Various preferences
(setq org-log-done t
      org-completion-use-ido t
      org-edit-src-content-indentation 0
      org-edit-timestamp-down-means-later t
      org-agenda-start-on-weekday nil
      org-agenda-span 14
      org-agenda-include-diary t
      org-agenda-window-setup 'current-window
      org-fast-tag-selection-single-key 'expert
      org-export-kill-product-buffer-when-displayed t
      org-export-odt-preferred-output-format "doc"
      org-tags-column 80
      org-enforce-todo-dependencies t
                                        ;org-startup-indented t
      )

(setq org-log-done 'note)


(setq org-agenda-files (quote ("~/Dropbox/deft-nodes/home-scheduler.org"
                               "~/Dropbox/deft-nodes/quarter_work.org"
                               "~/Dropbox/deft-nodes/work-scheduler.org")))
                                        ; Refile targets include this file and any file contributing to the agenda - up to 5 levels deep
(setq org-refile-targets (quote ((nil :maxlevel . 5) (org-agenda-files :maxlevel . 5))))
                                        ; Targets start with the file name - allows creating level 1 tasks
(setq org-refile-use-outline-path (quote file))
                                        ; Targets complete in steps so we start with filename, TAB shows the next level of targets etc
(setq org-outline-path-complete-in-steps t)


(setq org-todo-keywords
      (quote ((sequence "TODO(t)" "STARTED(s)" "|" "DONE(d!/!)")
              (sequence "WAITING(w@/!)" "SOMEDAY(S)" "PROJECT(P@)" "|" "CANCELLED(c@/!)"))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Org clock
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq org-html-table-default-attributes '(:border "2" :rules "all" :frame "border"))
(setq org-indent-mode t)
;; Change task state to STARTED when clocking in
(setq org-clock-in-switch-to-state "STARTED")
;; Save clock data and notes in the LOGBOOK drawer
(setq org-clock-into-drawer t)
;; Removes clocked tasks with 0:00 duration
(setq org-clock-out-remove-zero-time-clocks t)

;; Show the clocked-in task - if any - in the header line
(defun sanityinc/show-org-clock-in-header-line ()
  (setq-default header-line-format '((" " org-mode-line-string " "))))

(defun sanityinc/hide-org-clock-from-header-line ()
  (setq-default header-line-format nil))

(add-hook 'org-clock-in-hook 'sanityinc/show-org-clock-in-header-line)
(add-hook 'org-clock-out-hook 'sanityinc/hide-org-clock-from-header-line)
(add-hook 'org-clock-cancel-hook 'sanityinc/hide-org-clock-from-header-line)

(eval-after-load 'org-clock
  '(progn
     (define-key org-clock-mode-line-map [header-line mouse-2] 'org-clock-goto)
     (define-key org-clock-mode-line-map [header-line mouse-1] 'org-clock-menu)))

(eval-after-load 'org
  '(progn
     (require 'org-clock)
                                        ; @see http://irreal.org/blog/?p=671
     (setq org-src-fontify-natively t)
     (require 'org-fstree)
     (defun soft-wrap-lines ()
       "Make lines wrap at window edge and on word boundary,
        in current buffer."
       (interactive)
       (setq truncate-lines nil)
       (setq word-wrap t)
       )
     (add-hook 'org-mode-hook '(lambda ()
                                 (setq evil-auto-indent nil)
                                 (soft-wrap-lines)
                                 ))))

(defadvice org-open-at-point (around org-open-at-point-choose-browser activate)
  (let ((browse-url-browser-function
         (cond ((equal (ad-get-arg 0) '(4))
                'browse-url-generic)
               ((equal (ad-get-arg 0) '(16))
                'choose-browser)
               (t
                (lambda (url &optional new)
                  (w3m-browse-url url t))))))
    ad-do-it))

;; {{ org2nikola set up
(setq org2nikola-output-root-directory "~/Dropbox/proj.tc.org")
(setq org2nikola-use-google-code-prettify t)
(setq org2nikola-prettify-unsupported-language
      '(elisp "lisp"
              emacs-lisp "lisp"))
;; }}

(setq org-latex-default-class "latex")
(unless (boundp 'org-latex-classes)
  (setq org-latex-classes '()))

(add-to-list 'org-latex-classes
             '("ctexart"
               "\\documentclass[fancyhdr,fntef,nofonts,UTF8,a4paper,cs4size]{ctexart}"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))
(add-to-list 'org-latex-classes
             '("ctexrep"
               "\\documentclass[fancyhdr,fntef,nofonts,UTF8,a4paper,cs4size]{ctexrep}"
               ("\\part{%s}" . "\\part*{%s}")
               ("\\chapter{%s}" . "\\chapter*{%s}")
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")))
(add-to-list 'org-latex-classes
             '("ctexbook"
               "\\documentclass[fancyhdr,fntef,nofonts,UTF8,a4paper,cs4size]{ctexbook}"
               ("\\part{%s}" . "\\part*{%s}")
               ("\\chapter{%s}" . "\\chapter*{%s}")
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")))
(add-to-list 'org-latex-classes
             '("beamer"
               "\\documentclass{beamer}
	       \\usepackage[fntef,nofonts,fancyhdr]{ctex}"
               org-beamer-sectioning))

(add-to-list 'org-latex-classes
             '("hbuuthesis"
               "\\documentclass[unicode]{hbuuthesis}
 [DEFAULT-PACKAGES]
 [NO-PACKAGES]
 [EXTRA]"
               ("\\chapter{%s}" . "\\chapter*{%s}")
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")))

;; (add-to-list 'org-latex-classes
;;              '("org-latex-cn"
;;                "\\documentclass[11pt]{article}
;; \\usepackage[unicode,dvipdfm]{hyperref}
;; \\usepackage{graphicx}
;; \\usepackage{xeCJK,fontspec}
;; \\setmainfont{Arial}
;; \\setsansfont{Helvetica}
;; \\setmonofont{Courier New}
;; \\setCJKmainfont[BoldFont = Hiragino Sans GB W6]{Hiragino Sans GB W3}
;; \\setCJKsansfont{宋体}
;; \\setCJKmonofont{WenQuanYi Zen Hei Mono}
;; [NO-DEFAULT-PACKAGES]
;; [NO-PACKAGES]"
;;                ("\\section{%s}" . "\\section*{%s}")
;;                ("\\subsection{%s}" . "\\subsection*{%s}")
;;                ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
;;                ("\\paragraph{%s}" . "\\paragraph*{%s}")
;;                ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

;; (add-to-list 'org-latex-classes
;;              '("org-latex-cn"
;;                "\\documentclass[10pt,a4paper]{article}
;; \\usepackage{graphicx}
;; \\usepackage{xcolor}
;; \\usepackage{xeCJK}
;; \\usepackage{lmodern}
;; \\usepackage{verbatim}
;; \\usepackage{fixltx2e}
;; \\usepackage{longtable}
;; \\usepackage{float}
;; \\usepackage{tikz}
;; \\usepackage{wrapfig}
;; \\usepackage{soul}
;; \\usepackage{textcomp}
;; \\usepackage{listings}
;; \\usepackage{geometry}
;; \\usepackage{algorithm}
;; \\usepackage{algorithmic}
;; \\usepackage{marvosym}
;; \\usepackage{wasysym}
;; \\usepackage{latexsym}
;; \\usepackage{natbib}
;; \\usepackage{fancyhdr}
;; \\usepackage[xetex,colorlinks=true,CJKbookmarks=true,linkcolor=blue,urlcolor=blue,menucolor=blue]{hyperref}
;; \\usepackage{fontspec,xunicode,xltxtra}
;; \\setmainfont[BoldFont=Adobe Heiti Std]{Adobe Song Std}
;; \\setsansfont{Helvetica}
;; \\setmonofont{Courier New}
;; \\newcommand\\fontnamemono{AR PL UKai CN}%等宽字体
;; \\newfontinstance\\MONO{\\fontnamemono}
;; \\newcommand{\\mono}[1]{{\\MONO #1}}
;; \\setCJKmainfont[Scale=0.9]{Adobe Heiti Std}%中文字体
;; \\setCJKmonofont[Scale=0.9]{Adobe Heiti Std}
;; \\hypersetup{unicode=true}
;; \\geometry{a4paper, textwidth=6.5in, textheight=10in,marginparsep=7pt, marginparwidth=.6in}
;; \\definecolor{foreground}{RGB}{220,220,204}%浅灰
;; \\definecolor{background}{RGB}{62,62,62}%浅黑
;; \\definecolor{preprocess}{RGB}{250,187,249}%浅紫
;; \\definecolor{var}{RGB}{239,224,174}%浅肉色
;; \\definecolor{string}{RGB}{154,150,230}%浅紫色
;; \\definecolor{type}{RGB}{225,225,116}%浅黄
;; \\definecolor{function}{RGB}{140,206,211}%浅天蓝
;; \\definecolor{keyword}{RGB}{239,224,174}%浅肉色
;; \\definecolor{comment}{RGB}{180,98,4}%深褐色
;; \\definecolor{doc}{RGB}{175,215,175}%浅铅绿
;; \\definecolor{comdil}{RGB}{111,128,111}%深灰
;; \\definecolor{constant}{RGB}{220,162,170}%粉红
;; \\definecolor{buildin}{RGB}{127,159,127}%深铅绿
;; \\punctstyle{kaiming}
;; \\title{}
;; \\fancyfoot[C]{\\bfseries\\thepage}
;; \\chead{\\MakeUppercase\\sectionmark}
;; \\pagestyle{fancy}
;; \\tolerance=1000
;; [NO-DEFAULT-PACKAGES]
;; [NO-PACKAGES]"
;; ("\\section{%s}" . "\\section*{%s}")
;; ("\\subsection{%s}" . "\\subsection*{%s}")
;; ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
;; ("\\paragraph{%s}" . "\\paragraph*{%s}")
;; ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

(add-to-list 'org-latex-classes
             '("org-latex-class"
               "\\documentclass[11pt,a4paper]{article}
\\XeTeXlinebreaklocale "zh"
\\XeTeXlinebreakskip = 0pt plus 1pt minus 0.1pt
\\usepackage[top=1in,bottom=1in,left=1.25in,right=1.25in]{geometry}
\\usepackage{float}
\\usepackage{fontspec}
\\newfontfamily\\zhfont[BoldFont=Adobe Heiti Std]{Adobe Song Std}
\\newfontfamily\\zhpunctfont{Adobe Song Std}
\\setmainfont{Times New Roman}
\\usepackage{indentfirst}
\\usepackage{zhspacing}
\\zhspacing
[NO-DEFAULT-PACKAGES]
[NO-PACKAGES]"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

;; Set to the location of your Org files on your local system
(setq org-directory "~/Dropbox/deft-nodes")
;; Set to the name of the file where new notes will be stored
(setq org-mobile-inbox-for-pull "~/Dropbox/deft-nodes/flagged.org")
;; Set to <your Dropbox root directory>/MobileOrg.
(setq org-mobile-directory "~/Dropbox/应用/MobileOrg")


(org-babel-do-load-languages
  'org-babel-load-languages
  '(;; other Babel languages
    (ditaa . t)
    (dot . t)
    ))

(setq org-ditaa-jar-path (expand-file-name "/usr/local/Cellar/ditaa/0.9/libexec/ditaa0_9.jar"))

;; (require 'remember)
;; (setq remember-annotation-functions '(org-remember-annotation))
;; (setq remmeber-handler-functions '(org-remember-hanlder))
;; (add-hook 'remember-mode-hook 'org-remember-apply-template)
;; (define-key global-map [(control meta ?r)] 'remember)
;; (add-hook 'remember-mode-hook 'org-remember-apply-template)
(setq org-export-with-sub-superscripts nil)

;;; org-export-blocks-format-plantuml.el Export UML using plantuml
;;
;; OBSOLETED, use ob-plantuml.el bundled in org instead.
;;
;; Copy from org-export-blocks-format-ditaa
;;
;; E.g.
;; #+BEGIN_UML
;;   Alice -> Bob: Authentication Request
;;   Bob --> Alice: Authentication Response
;; #+END_UML

(eval-after-load "org-exp-blocks"
  '(progn
    (add-to-list 'org-export-blocks '(uml iy/org-export-blocks-format-plantuml nil))
    (add-to-list 'org-protecting-blocks "uml")))

(defvar iy/org-plantuml-jar-path (expand-file-name "/usr/local/Cellar/plantuml/8015/plantuml.8015.jar")
  "Path to the plantuml jar executable.")

(defun iy/org-export-blocks-format-plantuml (body &rest headers)
  "Pass block BODY to the plantuml utility creating an image.
  Specify the path at which the image should be saved as the first
  element of headers, any additional elements of headers will be
  passed to the plantuml utility as command line arguments."
  (message "plantuml-formatting...")
  (let* ((args (if (cdr headers) (mapconcat 'identity (cdr headers) " ")))
         (data-file (make-temp-file "org-plantuml"))
         (hash (progn
                 (set-text-properties 0 (length body) nil body)
                 (sha1 (prin1-to-string (list body args)))))
         (raw-out-file (if headers (car headers)))
         (out-file-parts (if (string-match "\\(.+\\)\\.\\([^\\.]+\\)$" raw-out-file)
                             (cons (match-string 1 raw-out-file)
                                   (match-string 2 raw-out-file))
                           (cons raw-out-file "png")))
         (out-file (concat (car out-file-parts) "_" hash "." (cdr out-file-parts))))
    (unless (file-exists-p iy/org-plantuml-jar-path)
      (error (format "Could not find plantuml.jar at %s" iy/org-plantuml-jar-path)))
    (setq body (if (string-match "^\\([^:\\|:[^ ]\\)" body)
                   body
                 (mapconcat (lambda (x) (substring x (if (> (length x) 1) 2 1)))
                            (org-split-string body "\n")
                            "\n")))
    (cond
     ((or htmlp latexp docbookp)
      (unless (file-exists-p out-file)
        (mapc ;; remove old hashed versions of this file
         (lambda (file)
           (when (and (string-match (concat (regexp-quote (car out-file-parts))
                                            "_\\([[:alnum:]]+\\)\\."
                                            (regexp-quote (cdr out-file-parts)))
                                    file)
                      (= (length (match-string 1 out-file)) 40))
             (delete-file (expand-file-name file
                                            (file-name-directory out-file)))))
         (directory-files (or (file-name-directory out-file)
                              default-directory)))
        (with-temp-file data-file (insert (concat "@startuml\n" body "\n@enduml")))
        (message (concat "java -jar " iy/org-plantuml-jar-path " -pipe " args))
        (with-temp-buffer
          (call-process-shell-command
           (concat "java -jar " iy/org-plantuml-jar-path " -pipe " args)
           data-file
           '(t nil))
          (write-region nil nil out-file)))
      (format "\n[[file:%s]]\n" out-file))
     (t (concat
         "\n#+BEGIN_EXAMPLE\n"
         body (if (string-match "\n$" body) "" "\n")
         "#+END_EXAMPLE\n")))))

;; (require 'ox-latex)
;; (add-to-list 'org-latex-packages-alist '("" "minted"))
;; (setq org-latex-listings 'minted)
(provide 'init-org)
