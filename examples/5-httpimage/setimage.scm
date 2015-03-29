
;; *** variables that appear often.

;; This URL is a webcam that looks east at downtown Miami, Florida.
;; It updates every 15 min.
(define urls "http://wwc.instacam.com/instacamimg/MMBDC/MMBDC_l.jpg")

(define act::android.app.Activity *activity*)
(define fdir ((act:getFilesDir):getAbsolutePath))
(define fn::String (string-append fdir "/webcam.jpg"))

;; macro to run things on Ui thread.
(define-syntax rout
  (syntax-rules ()
    ((rout e)
     (let ((act::android.app.Activity *activity*))
       (act:runOnUiThread
        (runnable
         (lambda () e)))))))

;;removes whatever contentview is there.
(define clearview
  (lambda ()
    (let* ((act::android.app.Activity *activity*)
           (vg::android.view.ViewGroup
            (act:findViewById android.R$id:content)))
      (rout (vg:removeAllViews))
      )))

;; take a full path to an image as a string and show it.
(define showimage
  (lambda (fn)
    (let* ((act::android.app.Activity *activity*)
           (iv::android.widget.ImageView 
            (android.widget.ImageView act)))
      (iv:setImageBitmap 
       (android.graphics.BitmapFactory:decodeFile fn))
      (rout (act:setContentView iv))
    )))

;; show a status textbox, usable by the (msg ...) function.
(define showstatus
  (lambda ()
    (let* ((act::android.app.Activity *activity*)
           (tv::android.widget.TextView
            (android.widget.TextView act)))
      ;; This Id is used by (msg ...) for output.
      (tv:setId 1)
      (tv:setText "Retrieving fresh image ... \n")
      (rout (act:setContentView tv))
      )))

;; actually do things.
;; This is the whole app.
(let* ((fo (java.io.File fn))
       (now (java.util.Date))
       ;;if file exists and is less than 15 mins old.
       (fileokay (and (fo:exists) 
                      (< (/ (- (now:getTime)
                               (fo:lastModified)) 60000) 
                         15))))
  ;; do everything in a separate thread.
  (future 
   (begin
     (clearview)
     (if (not fileokay)
         (begin
           (showstatus)
           ;; getfile uses msg to report status.
           (getfile urls fn)
           ;; give the user 2 seconds to read the download result.
           (sleep 2)
           (clearview)))
     ;; set view to image. 
     (showimage fn)
     )))
