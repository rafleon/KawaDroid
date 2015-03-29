
;; Read licenses and legal terms out of asset files
;; and display them in a scrolling textview.

;; By putting the licenses in assets, 
;; they are bundled into the apk as read-only files.

(define TextView android.widget.TextView)
(define ScrollView android.widget.ScrollView)

(define asset->string
  (lambda (fn)
    (let* ((act::android.app.Activity *activity*)
           (instr ((act:getAssets):open fn))
           (size (instr:available))
           (buf (byte[] length: size))
           )
      (instr:read buf) 
      (java.lang.String buf "UTF-8")
      )))

(let* ((act::android.app.Activity *activity*)
       (sv::ScrollView (ScrollView act))
       (tv::TextView (TextView act))
       )
  ;; dynamically build the layout
  (tv:append (asset->string "NOTICE.txt"))
  (tv:append (asset->string "MITLicense.txt"))
  (tv:append (asset->string "LICENSE-2.0.txt"))
  (sv:addView tv)
  (act:runOnUiThread
   (runnable
    (lambda ()
      (act:setContentView sv))))
  )
