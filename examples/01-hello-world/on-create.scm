
(let* ((act::android.app.Activity *activity*)
       (t::android.widget.TextView 
        (android.widget.TextView act))
       )
  (t:set-text "Hello World!")
  (act:setContentView t)
  )
