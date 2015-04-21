
;; for hashtables
(require 'srfi-69)

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
(define act::android.app.Activity *activity*)
(define glsv::glsvc (glsvc act))
(define glr::android.opengl.GLSurfaceView$Renderer (glrc))
(glsv:addRenderer glr)
(act:setContentView glsv)

;; You can edit these files and then re-load them from the telnet REPL.
;; These are interpreted, not compiled into bytecode.
;; Initialize the vertexBuffer
(load (sa mydir "/vertexBuffer.scm"))
;; Load the renderer lambda to draw a triangle.
(load (sa mydir "/myrender.scm"))
;; Load the lambda to respond to touch events.
(load (sa mydir "/mytouch.scm"))
