
(define gpsstart
  (lambda (ll::com.google.android.gms.location.LocationListener)
    (let* 
        ((act::android.app.Activity *activity*)
         (looper (act:getMainLooper))
         (gacb (com.google.android.gms.common.api.GoogleApiClient:Builder act))
         (gac (begin
                (gacb:addApi com.google.android.gms.location.LocationServices:API)
                (gacb:build)))
         (lr (com.google.android.gms.location.LocationRequest:create))
         (lrhigh com.google.android.gms.location.LocationRequest:PRIORITY_HIGH_ACCURACY)
         (flapi com.google.android.gms.location.LocationServices:FusedLocationApi)
         )
      (lr:setPriority lrhigh)
      (lr:setInterval 1000)
      (gac:blockingConnect 5 java.util.concurrent.TimeUnit:SECONDS)
      (flapi:requestLocationUpdates gac lr ll looper)
      gac
      )))

(define getloc
  (lambda ()
    (let* (
           (act::android.app.Activity *activity*)
           ;; create and lock the GPS lock. 
           (gpslock (let ((temp::java.util.concurrent.locks.ReentrantLock
                           (java.util.concurrent.locks.ReentrantLock)))
                      (begin (act:runOnUiThread 
                              (runnable (lambda () (temp:tryLock))))
                             temp)))
           ;; Tie the gpslock to the Location Listener
           (ll (let ((temp::llclass (llclass)))
                 (begin (temp:setLock gpslock)
                        temp)))
           ;; start the client
           (gac::com.google.android.gms.common.api.GoogleApiClient 
            (gpsstart ll))
           )
      (msg "GPS sensor started, waiting for location information ... \n")
      (if (gpslock:tryLock 10 java.util.concurrent.TimeUnit:SECONDS) 
          (msg "Accurate location acquired.\n")
          (msg "GPS timed out.\n"))
      ;; cleanup
      (msg "Shutting down GPS sensor.\n")
      (gac:disconnect)
      (let ((myloc::android.location.Location (ll:getLocation)))
        (list
         (myloc:getLatitude)
         (myloc:getLongitude)
         ))
      )))
