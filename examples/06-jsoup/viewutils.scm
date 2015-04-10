
;; macro to run things on Ui thread.
(define-syntax rout
  (syntax-rules ()
    ((rout e)
     (let ((act::android.app.Activity *activity*))
       (act:runOnUiThread
        (runnable
         (lambda () e)))))))

(define TextView android.widget.TextView)
(define ScrollView android.widget.ScrollView)

;; This expects that a TextView with Id 1 already exists.
;; This takes arbitrary scheme objects and displays them.
;; Strings work, so do lists and other things.
;; This is incredibly useful.
(define msg
  (lambda (o)
    (let* ((act::android.app.Activity *activity*)
           (tv::android.widget.TextView (act:findViewById 1)))
      (rout (tv:append
             (let ((s (open-output-string)))
               (display o s)
               (get-output-string s)))
            ))))

;; for regular logging, use this instead:
;(define msg
;  (lambda (message)
;    (android.util.Log:i "kawa" message)))
