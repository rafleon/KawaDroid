
(require kawa.android.mainact)
(define mydir (loaddir *activity*))
(define sa string-append)

;; compiledexload my SensorEventListener class.
(load (sa mydir "/cdl.scm"))
(define selclassfile (sa mydir "/sensorclass.scm"))
(define selclass (compiledexload "selclass" selclassfile))

;; everything else.
(load (sa mydir "/mysensor.scm"))
(load (sa mydir "/telnetrepl.scm"))
