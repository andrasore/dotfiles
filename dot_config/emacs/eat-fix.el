;; Fix for eat terminal
;; https://codeberg.org/akib/emacs-eat/pulls/228

(defun function-lisp (function)
    (let ((raw (indirect-function function)))
        (while (advice--p raw)
            (setq raw (advice--cdr raw)))
        (when (or (subr-native-elisp-p raw)
                  (byte-code-function-p raw)
                  (autoloadp raw))
            (when-let* ((source (find-function-library function))
                        (file (cdr source)))
                  (function-lisp--read-from-source (car source) file)))))

(autoload 'find-function-library "find-func")

(defun function-lisp--read-from-source (name file)
    (let* ((buffers (buffer-list))
           (found (find-function-search-for-symbol name nil file))
           (buffer   (car found))
           (position (cdr found))
           (was-already-open (memq buffer buffers)))
        (prog1
            (read (set-marker (make-marker) position buffer))
            (unless was-already-open
                (kill-buffer buffer)))))

(defun form-replace (from-forms to-forms in-forms)
    (when in-forms
        (let ((unmatched-in-forms in-forms)
              (unmatched-from-forms from-forms))
            (while (and unmatched-in-forms
                        unmatched-from-forms
                        (equal (car unmatched-in-forms)
                               (car unmatched-from-forms)))
                (pop unmatched-in-forms)
                (pop unmatched-from-forms))
            (if unmatched-from-forms
                (nconc
                    (form-replace--car from-forms to-forms (car in-forms))
                    (form-replace      from-forms to-forms (cdr in-forms)))
                (nconc
                    (copy-sequence to-forms)
                    (form-replace from-forms to-forms unmatched-in-forms))))))

(defun form-replace--car (from-forms to-forms nested-form)
    (if (consp nested-form)
        (list (form-replace from-forms to-forms nested-form))
        (if (and (equal nested-form (car from-forms))
                 (not (cdr from-forms)))
            (copy-sequence to-forms)
          (list nested-form))))

;; Define `fixed-eat--t-write` as `eat--t-write` patched with
;; the fix from https://codeberg.org/akib/emacs-eat/pulls/228
(eval
    (form-replace
        '(defun eat--t-write)
        '(defun fixed-eat--t-write)
        (form-replace
            '((+ written wrote))
            '((+ written max))
            (form-replace
                '((- end e))
                '((- max wrote))
                (function-lisp 'eat--t-write))))
    t)
    ;; The original is compiled, and this function is part of
    ;; a hot loop in Eat, so compile the patched function too:
    (if (native-comp-available-p)
        (native-compile 'fixed-eat--t-write)
        (byte-compile 'fixed-eat--t-write))
;; Override the original (advice is reversible and introspectable):
(advice-add 'eat--t-write :override 'fixed-eat--t-write)
