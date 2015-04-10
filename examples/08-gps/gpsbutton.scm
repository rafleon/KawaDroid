
;; define some useful things.
;; These all use view Id's which are set below.

(define scrolldown
  (lambda ()
   (let* ((act::android.app.Activity *activity*)
          (sv::ScrollView (act:findViewById 0)))
     ;; This sleep is needed for it to stop appending before we scroll.
     (sleep 0.1)
     (rout (sv:fullScroll android.view.View:FOCUS_DOWN))
     )))

(define disablebutton
  (lambda ()
   (let* ((act::android.app.Activity *activity*)
          (b::Button (act:findViewById 2)))
     (rout (b:setEnabled #f))
     )))

(define enablebutton
  (lambda ()
   (let* ((act::android.app.Activity *activity*)
          (b::Button (act:findViewById 2)))
     (rout (b:setEnabled #t))
     )))

;; this is the app.
(let* ((act::android.app.Activity *activity*)
       (ll::LinearLayout (LinearLayout act))
       (but::Button 
        (Button act text: "Click here!"))
       (tv::TextView 
        (TextView act text: "Not clicked yet.\n"))
       (sv::ScrollView (ScrollView act))
       )
  ;; set some settings.
  (ll:setOrientation ll:VERTICAL)
  (sv:setId 0)
  (tv:setId 1)
  (but:setId 2)
  ;; dynamically build the layout
  (ll:addView but)
  (sv:addView tv)
  (ll:addView sv)
  (but:setOnClickListener 
   (lambda(v)
     (future
      (begin
        (disablebutton)
        (let ((latlon (getloc)))
          (msg (format "Current latitude is: ~f\n" (car latlon)))
          (msg (format "Current longitude is: ~f\n" (cadr latlon))))
        (enablebutton)
        (scrolldown)
       ))))
  (rout (act:setContentView ll))
)
