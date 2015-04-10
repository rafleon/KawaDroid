(define-simple-class llclass
  (com.google.android.gms.location.LocationListener) 
  (loc::android.location.Location access: 'private)
  (rlock::java.util.concurrent.locks.ReentrantLock
   access: 'private init: (java.util.concurrent.locks.ReentrantLock))
  ((onLocationChanged (location::android.location.Location))::void
   (set! loc location)
   (if (and (> 100 (location:getAccuracy)) 
            (rlock:isHeldByCurrentThread))
       (rlock:unlock))
;;   (android.util.Log:v "gps" (location:toString))
   )
  ((setLock (thislock::java.util.concurrent.locks.ReentrantLock))::void
   (set! rlock thislock)
   )
  ((getLocation)::android.location.Location
   loc)
)
