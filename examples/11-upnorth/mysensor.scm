
(require 'srfi-1)

(define act::kawa.android.mainact *activity*)

;; initialize the UI. just a textbox.
(define tv::android.widget.TextView (android.widget.TextView act))
(tv:setTextSize 20)
(act:setContentView tv)

;; get a SensorManager
(define sensman::android.hardware.SensorManager 
  (act:getSystemService "sensor"))

;; get some sensors. for orientation, we need accel and mag
(define acceltype android.hardware.Sensor:TYPE_ACCELEROMETER)
(define magtype android.hardware.Sensor:TYPE_MAGNETIC_FIELD)
(define accel::android.hardware.Sensor 
  (sensman:getDefaultSensor acceltype))
(define magnet::android.hardware.Sensor 
  (sensman:getDefaultSensor magtype))

;; create a SensorEventListener object
(define mysel::selclass (selclass))

;; some utility functions
;; float array to list
(define fatol
  (lambda (a::float[])
    (map a (iota a:length))))

(define sq
  (lambda (x)
    (* x x)))

;; apply a unary operator to a 3D float array.
(define vecunary
  (lambda (op a::float[])
    (let ((retval (float[] length: 3)))
      (set! (retval 0) (op (a 0)))
      (set! (retval 1) (op (a 1)))
      (set! (retval 2) (op (a 2)))
      retval
      )))

;; apply a binary operator to two 3D float arrays.
(define vecbinary
  (lambda (op a::float[] b::float[])
    (let ((retval (float[] length: 3)))
      (set! (retval 0) (op (a 0) (b 0)))
      (set! (retval 1) (op (a 1) (b 1)))
      (set! (retval 2) (op (a 2) (b 2)))
      retval
      )))

;; scale a float array into a unit vector.
(define makeunit
  (lambda (vec::float[])
    (let* ((total (sqrt (apply + (fatol (vecunary sq vec)))))
           (divtotal (lambda (x) (/ x total))))
      (vecunary divtotal vec)
      )))

(define lastmag::float[] (float[] length: 3))
(define lastaccel::float[] (float[] length: 3))

;; lambda for handling each SensorEvent
(define mys
  (lambda (e::android.hardware.SensorEvent)
    (if (= (e:sensor:getType) acceltype)
          (java.lang.System:arraycopy e:values 0 lastaccel 0 3))
    ;; the mag sensor has a more stable clock. 
    ;; use it to update the UI.
    (if (= (e:sensor:getType) magtype)
        (begin 
          (java.lang.System:arraycopy e:values 0 lastmag 0 3)
          ;; TODO: we should check if the mag data is realistic.
          ;; if not, ask the user to do a calibration.
          (let* ((up (makeunit lastaccel))
                 ;; orthonormalize the magnetic data using "up"
                 (updotmag (apply + (fatol (vecbinary * up lastmag))))
                 (scaleup (lambda (x) (* x updotmag)))
                 (upscaled (vecunary scaleup up))
                 (magnorth (makeunit (vecbinary - lastmag upscaled)))
                 ;; TODO: insert correction for magnetic/true north.
                 )
          (tv:set-text (string-append
                         "Up is: \n"
                         (format #f "x: ~8,5F \n" (up 0))
                         (format #f "y: ~8,5F \n" (up 1))
                         (format #f "z: ~8,5F \n" (up 2))
                         "Magnetic North is: \n"
                         (format #f "x: ~8,5F \n" (magnorth 0))
                         (format #f "y: ~8,5F \n" (magnorth 1))
                         (format #f "z: ~8,5F \n" (magnorth 2))
                         )))))
    ))

(mysel:setonSensorEvent mys)

;; my lambda for onPause
(define mypause
  (lambda ()
    ;; Android says to do this to save battery.
    (sensman:unregisterListener mysel)
    ))

(act:setonPause mypause)

;; my lambda for onResume
(define myresume
  (lambda ()
    ;; these sensor listeners run on the UI thread. this could be bad.
    ;; change these lines to specify handler/looper/thread.
    ;; delay is in microseconds. 200000 is 5 times per second.
    (sensman:registerListener mysel accel 200000)
    (sensman:registerListener mysel magnet 200000)
    ))

(act:setonResume myresume)
