
(require 'srfi-1)

;; load class pointers from global environment
(define glsvc ((gnu.mapping.Environment:getGlobal):get 'glsvc))
(define glrc ((gnu.mapping.Environment:getGlobal):get 'glrc))

(define glsv::glsvc
  (let* ((act::android.app.Activity *activity*)
         (vg::android.view.ViewGroup
          (act:findViewById android.R$id:content))
         )
    (vg:getChildAt 0)))

(define glr::glrc (glsv:getRenderer))

(define act::kawa.android.mainact *activity*)

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

;; lambda for handling each SensorEvent
(define mys
  (let ((R (float[] length: 16))
        (I (float[] length: 16))
        (lastmag (float[] length: 3))
        (lastaccel (float[] length: 3))
        (state (glr:getState))
        )
  (lambda (e::android.hardware.SensorEvent)
    (if (= (e:sensor:getType) acceltype)
          (java.lang.System:arraycopy e:values 0 lastaccel 0 3))
    ;; the mag sensor has a more stable clock. 
    ;; use mag to update the UI.
    (if (= (e:sensor:getType) magtype)
        (begin 
          (java.lang.System:arraycopy e:values 0 lastmag 0 3)
          ;; TODO: we should check if the mag data is realistic.
          ;; if not, ask the user to do a calibration.
          ;; TODO: insert correction for magnetic/true north.
          (sensman:getRotationMatrix R I lastaccel lastmag)
          (hash-table-set! state 'mR R)
          (glsv:requestRender)
          )))))

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
    ;; delay is in microseconds. 100000 is 10 times per second.
    (sensman:registerListener mysel accel 100000)
    (sensman:registerListener mysel magnet 100000)
    ))

(act:setonResume myresume)
