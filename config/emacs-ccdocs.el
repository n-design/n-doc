(require 'reftex)
(autoload 'turn-on-bib-cite "bib-cite")
(add-hook 'LaTeX-mode-hook 'turn-on-bib-cite)
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)   ; with AUCTeX LaTeX mode
(add-hook 'LaTeX-mode-hook 'reftex-mode)

(setq set-fill-column 80)
(setq-default fill-column 80)

(require 'multiple-cursors)
(global-set-key (kbd "C-s-c C-s-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

(setq-default TeX-master nil)
(setq TeX-parse-self t)
(setq TeX-auto-save t)
(setq TeX-auto-regexp-list 'TeX-auto-full-regexp-list)
(setq TeX-auto-parse-length '999999)
(setq reftex-plug-into-AUCTeX t)
(setq reftex-save-parse-info t)

(require 'auctex-latexmk)
(auctex-latexmk-setup)


;; Show the full path file name in the minibuffer.
(defun show-file-name ()
  "Show the full path file name in the minibuffer."
  (interactive)
  (message (buffer-file-name)))

(defun copy-file-name ()
  "Copy the full path file name and show it in the minibuffer."
  (interactive)
  (message (buffer-file-name))
  (kill-new (buffer-file-name)))


(global-set-key [C-f1] 'show-file-name)
(global-set-key [C-f2] 'copy-file-name)
(global-set-key (kbd "C-x f") 'find-file-at-point)

(defun TeX-remove-macro ()
  "Remove current macro and return `t'.  If no macro at point,
return `nil'."
  (interactive)
  (when (TeX-current-macro)
    (let ((bounds (TeX-find-macro-boundaries))
          (brace  (save-excursion
                    (goto-char (1- (TeX-find-macro-end)))
                    (TeX-find-opening-brace))))
      (delete-region (1- (cdr bounds)) (cdr bounds))
      (delete-region (car bounds) (1+ brace)))
    t))

(global-set-key [C-x \d]  'TeX-remove-macro)


(setq reftex-section-levels
            (cons '("hrefchapter" . 1) reftex-section-levels))
(setq reftex-section-levels
            (cons '("hrefsection" . 2) reftex-section-levels))
(setq reftex-section-levels
            (cons '("tcsection" . 2) reftex-section-levels))
(setq reftex-section-levels
            (cons '("wbtsection" . 2) reftex-section-levels))
(setq reftex-section-levels
            (cons '("subsystemkapitel" . 2) reftex-section-levels))
(setq reftex-section-levels
            (cons '("modulefuersubsystemkapitel" . 2) reftex-section-levels))
(setq reftex-section-levels
            (cons '("hrefsubsection" . 3) reftex-section-levels))
(setq reftex-section-levels
            (cons '("arcsfrsubsection" . 3) reftex-section-levels))
(setq reftex-section-levels
            (cons '("tcsubsection" . 3) reftex-section-levels))
(setq reftex-section-levels
            (cons '("wbtsubsection" . 3) reftex-section-levels))
(setq reftex-section-levels
            (cons '("subsystembeschreibung" . 3) reftex-section-levels))
(setq reftex-section-levels
            (cons '("subsystemsfr" . 3) reftex-section-levels))
(setq reftex-section-levels
            (cons '("subsysteminteract" . 3) reftex-section-levels))
(setq reftex-section-levels
            (cons '("moduleKapitel" . 3) reftex-section-levels))
(setq reftex-section-levels
            (cons '("hrefsubsubsection" . 4) reftex-section-levels))
(setq reftex-section-levels
            (cons '("moduleBeschreibung" . 4) reftex-section-levels))
(setq reftex-section-levels
            (cons '("moduleAblaeufe" . 4) reftex-section-levels))
(setq reftex-section-levels
            (cons '("moduleSchnittstellen" . 4) reftex-section-levels))
(setq reftex-section-levels
            (cons '("modulAblauf" . 5) reftex-section-levels))
(setq reftex-section-levels
            (cons '("modulSchnittstelleProvided" . 5) reftex-section-levels))
(setq reftex-section-levels
            (cons '("modulSchnittstelleRequired" . 5) reftex-section-levels))

(setq enable-recursive-minibuffers 't)
(defun ccdoc-get-tex-master (key pp) "" (interactive "MCC Document (afst): \nMPP (78): ")
       (setq ccdocs '(("t" . "adv_tds") ("s" . "ase_st") ("f" . "adv_fsp") ("a" . "adv_arc")))
       (setq doc (cdr (assoc key ccdocs)))
       (setq pp (concat "_pp9" pp))
       (setq docdir (concat doc pp))
       (setq cc-docs-dir (or (getenv "CC_DOCS_DIR") (concat (getenv "HOME") "/Documents/cc-ors1")))
       (setq master-file (concat cc-docs-dir "/" docdir "/" docdir ".tex"))
       (beginning-of-line)
       (kill-whole-line)
       (insert master-file)
       )

(global-set-key (kbd "M-g m") 'ccdoc-get-tex-master)



(defun german-quotes () "Insert a pair of german quotes U201E / U201C at point" (interactive)
       (insert "„“"))
(global-set-key (kbd "M-g q") 'german-quotes)

(defun tag-word-or-region (text-begin text-end)
  "Surround current word or region with given text."
  (interactive "sStart tag: \nsEnd tag: ")
  (let (pos1 pos2 bds)
    (if (and transient-mark-mode mark-active)
        (progn
          (goto-char (region-end))
          (insert text-end)
          (goto-char (region-beginning))
          (insert text-begin))
      (progn
        (setq bds (bounds-of-thing-at-point 'symbol))
        (goto-char (cdr bds))
        (insert text-end)
        (goto-char (car bds))
        (insert text-begin)))))

(defun quote-region () "Insert opening quotes before and closing quotes after region"
  (interactive)
  (tag-word-or-region "„" "“"))

(global-set-key (kbd "M-g r") 'quote-region)

(defun keyword-region () "Mark region as keyword"
       (interactive)
  (let (inputStr outputStr))
  (setq inputStr (buffer-substring-no-properties (region-beginning) (region-end)))
  (setq outputStr (replace-regexp-in-string "_" "\\\\_" inputStr)  )
  (save-excursion
    (delete-region (region-beginning) (region-end))
    (goto-char (region-beginning))
    (insert "\\keyword{")
    (insert outputStr)
    (insert "}")
    )  )

(global-set-key (kbd "M-g k") 'keyword-region)

(defun java-region () "Mark region as java"
       (interactive)
       (setq case-fold-search 'nil)
       (let (inputStr packageStr outputStr))
       (setq inputStr (buffer-substring-no-properties (region-beginning) (region-end)))
       (setq packageStr (replace-regexp-in-string "\\([[:lower:]\\.]*\\)\\([A-Z].*\\)" "[\\1]{\\2}" inputStr))
       (save-excursion
	 (delete-region (region-beginning) (region-end))
	 (goto-char (region-beginning))
	 (insert "\\java")
	 (insert (replace-regexp-in-string "\\." ".\\\\-" packageStr))
	 )  )

(global-set-key (kbd "M-g j") 'java-region)

