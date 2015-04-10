
(require kawa.android.mainact)
(define mydir (loaddir *activity*))
(define sa string-append)

;; for compiledexload
(load (sa mydir "/cdl.scm"))

;; load the needed wrapper classes for OpenGL
(define glsvc 
  (compiledexload "glsvclass" (sa mydir "/GLSurfaceViewClass.scm")))
(define glrc 
  (compiledexload "glrclass" (sa mydir "/GLRenderClass.scm")))
;; save the loaded classes to global variables so all threads can use them.
((gnu.mapping.Environment:getGlobal):put 'glsvc glsvc)
((gnu.mapping.Environment:getGlobal):put 'glrc glrc)

(load (sa mydir "/telnetrepl.scm"))

;; Instantiate some objects and load a blank GLSurfaceView
(let* ((act::android.app.Activity *activity*)
      (glsv::glsvc (glsvc act))
      (glr::android.opengl.GLSurfaceView$Renderer (glrc))
      )
  (glsv:addRenderer glr)
  (act:setContentView glsv)
  )

;; You can edit these files and then re-load them from the telnet REPL.
;; These are interpreted, not compiled into bytecode.
;; Load the renderer lambda to draw a triangle.
(load (sa mydir "/myrender.scm"))
;; Load the lambda to respond to touch events.
(load (sa mydir "/mytouch.scm"))
