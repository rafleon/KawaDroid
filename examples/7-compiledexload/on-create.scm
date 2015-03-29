
(require kawa.android.mainact)
(define mydir (loaddir *activity*))
(define sa string-append)
(load (sa mydir "/cdl.scm"))
(load (sa mydir "/compiledemo.scm"))
(load (sa mydir "/telnetrepl.scm"))
