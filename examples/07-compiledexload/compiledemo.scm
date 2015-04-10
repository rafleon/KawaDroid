
;; Using a short file, this measures how long it takes to:

;; read a scheme text file containing a class definition. 
;; compile it.
;; dex it.
;; load it into a running app.

;; On my device, it takes 3/1000 of a second.

;; Larger source files take more time.

(define myfile (sa mydir "/mysimpleclass.scm"))

(define Date java.util.Date)

(define before::Date (Date))
(define myclass::java.lang.Class (compiledexload "myclass" myfile))
(define after::Date (Date))

(define TextView android.widget.TextView)

(let* ((act::android.app.Activity *activity*)
       (tv::TextView (TextView act)))
  (tv:setTextSize 20)
  (tv:setText 
   (format "Compiling, Dexing, Loading took:\n\n ~5f seconds. \n\n"
           (/ (- (after:getTime)
                 (before:getTime)
                 ) 60000)))
  (tv:append "But does it work?\n")
  (tv:append "Let's test it: \n\n")
  (tv:append "One plus one is: ")
  (tv:append (format "~d\n" (myclass:plusone 1)))
  (act:runOnUiThread
   (runnable
    (lambda () 
      (act:setContentView tv))))
)
