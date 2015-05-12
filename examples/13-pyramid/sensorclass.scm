
;; bare wrapper class for a SensorEventListener
;; set a lambda with setonSensorEvent 
(define-simple-class selclass
  (android.hardware.SensorEventListener)
  ;; on sensor event lambda slot
  (osel::gnu.mapping.MethodProc access: 'private)
  ;; if the on sensor event slot contains something
  (oseb::boolean access: 'private init: #f)
  ;; this is what I think of as onSensorEvent
  ((onSensorChanged (e::android.hardware.SensorEvent))::void
   (if oseb (osel e)))
  ((setonSensorEvent (newl::gnu.mapping.MethodProc))::void
   (set! osel newl)
   (set! oseb #t))
  ;; this does nothing. android requires this to exist.
  ((onAccuracyChanged (sensor::android.hardware.Sensor)
                      (accuracy::int))::void
   #t)
)
