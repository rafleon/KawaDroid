
(require kawa.android.mainact)
(define mydir (loaddir *activity*))
(define sa string-append)
(load (sa mydir "/message.scm"))
(load (sa mydir "/network.scm"))
(load (sa mydir "/setimage.scm"))
(load (sa mydir "/telnetrepl.scm"))
