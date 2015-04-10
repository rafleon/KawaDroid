
(require kawa.android.mainact)
(let ((mydir (loaddir *activity*))
      (sa string-append))
  (load (sa mydir "/telnetrepl.scm"))
  (load (sa mydir "/showipaddr.scm"))
  )
