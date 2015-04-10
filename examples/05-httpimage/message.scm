
;; This expects that a TextView with Id 1 already exists.
;; This takes arbitrary scheme objects and displays them.
;; Strings work, so do lists and other things.
;; This is very useful.
(define msg
  (lambda (o)
    (let* ((act::android.app.Activity *activity*)
           (tv::android.widget.TextView (act:findViewById 1)))
      (act:runOnUiThread
       (runnable
        (lambda ()
          (tv:append
           (let ((s (open-output-string)))
             (display o s)
             (get-output-string s)))
          ))))))

;; for regular android string logging, use this instead:
;;(define msg
;;  (lambda (message)
;;    (android.util.Log:i "kawa" message)))
