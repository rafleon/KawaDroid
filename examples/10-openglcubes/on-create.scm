
;; copied with little modification from here:
;; https://github.com/ecraven/SchemeAndroidOGL
;; adapted from here:
;; http://nehe.gamedev.net/tutorial/lessons_01__05/22004/

(require kawa.android.mainact)
(define mydir (loaddir *activity*))
(define sa string-append)

;; for compiledexload
(load (sa mydir "/newcdl.scm"))

;; load the needed wrapper classes for OpenGL
(define glsvc 
  (compiledexload "glsvclass" (sa mydir "/GLSurfaceViewClass.scm")))
((gnu.mapping.Environment:getGlobal):put 'glsvc glsvc)
(define Cube
  (compiledexload "Cube" (sa mydir "/Cube.scm")))
(define Pyramid 
  (compiledexload "Pyramid" (sa mydir "/Pyramid.scm")))
(define lesson05
  (compiledexload "lesson05" (sa mydir "/lesson05.scm")))
;; save "lesson05" renderer class into a global variable
((gnu.mapping.Environment:getGlobal):put 'glrc lesson05)

(load (sa mydir "/telnetrepl.scm"))

;; Instantiate some objects and load a blank GLSurfaceView
(let* ((act::android.app.Activity *activity*)
      (glsv::glsvc (glsvc act))
      )
  (glsv:addRenderer (lesson05))
  (act:setContentView glsv)
  (glsv:requestRender)
  )

;; Load the lambda to respond to touch events.
(load (sa mydir "/mytouch.scm"))
