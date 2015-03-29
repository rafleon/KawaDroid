
(define TextView android.widget.TextView)
(define Button android.widget.Button)
(define LinearLayout android.widget.LinearLayout)

(let* ((act::android.app.Activity *activity*)
       (ll::LinearLayout (LinearLayout act))
       (but::Button 
        (Button act text: "Click here!"))
       (tv::TextView 
        (TextView act text: "Not clicked yet.\n"))
       (counter 0)
       )
  ;; set some settings.
  (ll:setOrientation ll:VERTICAL)
  ;; dynamically build the layout
  (ll:addView but)
  (ll:addView tv)
  ;; kawa does a neat trick called "SAM-conversion" which allows 
  ;; passing lambdas as callbacks.
  ;; Details here: http://www.gnu.org/software/kawa/Anonymous-classes.html
  (but:setOnClickListener 
   (lambda(v) 
     (set! counter (+ counter 1))
     (tv:setText
      (format "Clicked ~d times." counter))
       ))
  (act:runOnUiThread
   (runnable
    (lambda ()
      (act:setContentView ll))))
)
