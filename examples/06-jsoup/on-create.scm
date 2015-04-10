
(require kawa.android.mainact)
(define mydir (loaddir *activity*))
(define sa string-append)
(load (sa mydir "/viewutils.scm"))
(load (sa mydir "/jsoup.scm"))
(load (sa mydir "/telnetrepl.scm"))
