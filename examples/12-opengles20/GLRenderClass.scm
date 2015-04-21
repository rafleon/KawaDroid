
(require 'srfi-69)

(define-simple-class glrclass
  (android.opengl.GLSurfaceView$Renderer)
  ;; the width and height
  (myw::int access: 'private)
  (myh::int access: 'private)
  ;; an all-purpose state variable
  (mys::kawa.lib.kawa.hashtable$HashTable access: 'private)
  ;; our callback lambda slot
  (odfl::gnu.mapping.MethodProc access: 'private)
  ;; whether lambda slot contains something.
  (odfb::boolean access: 'private init: #f)
  ;; init the state hashtable
  ((*init*)
   (set! mys (make-hash-table eq?)))
  ;; this does nothing. android demands that it exist.
  ((onSurfaceCreated (gl::javax.microedition.khronos.opengles.GL10)
                      (config::javax.microedition.khronos.egl.EGLConfig))::void
                      #t)
  ;; This is where we set a lambda to do the rendering.
  ;; the lambda takes gl context, width, height, all-purpose state variable.
  ((setonDrawFrame (newl::gnu.mapping.MethodProc))::void
   (set! odfl newl)
   (set! odfb #t))
  ((onDrawFrame (gl::javax.microedition.khronos.opengles.GL10))::void
                      (if odfb (odfl myw myh mys)))
  ((onSurfaceChanged (gl::javax.microedition.khronos.opengles.GL10) 
                     (width::int) 
                     (height::int))::void
                     (set! myw width)
                     (set! myh height))
  ;; getter for all-purpose state variable.
  ;; Put rendering state into a hashtable
  ((getState)::kawa.lib.kawa.hashtable$HashTable
   mys)
)
