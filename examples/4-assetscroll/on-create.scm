
(require kawa.android.mainact)
(let ((mydir (loaddir *activity*))
      (sa string-append))
  (load (sa mydir "/scroll.scm"))
  (load (sa mydir "/telnetrepl.scm")))
