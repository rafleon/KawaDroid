
;; A mapper from callbacks to hooks.  

;; Java has compiled callbacks and emacs has interpreted hooks.
;; This class connects these two ways of thinking.
;; The lambda hooks could be interpreted or compiled.

;; The Android OpenGL system accepts this class as a valid renderer. 

;; Once this class is instantiated, the private rendering lambda is 
;; set with setOnDrawFrame.

;; Edit and set the renderer using the telnet REPL.
;; The renderer can be changed while the OpenGL SurfaceView is displayed 
;; in a running app.

(define-simple-class glrclass
  (android.opengl.GLSurfaceView$Renderer)
  ;; the width and height
  (myw::int access: 'private)
  (myh::int access: 'private)
  ;; an all-purpose state variable
  (mys::gnu.lists.Pair access: 'private init: '(0))
  ;; our callback lambda slot
  (odfl::gnu.mapping.MethodProc access: 'private)
  ;; whether lambda slot contains something.
  (odfb::boolean access: 'private init: #f)
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
                      (if odfb (odfl gl myw myh mys)))
  ((onSurfaceChanged (gl::javax.microedition.khronos.opengles.GL10) 
                     (width::int) 
                     (height::int))::void
                     (set! myw width)
                     (set! myh height))
  ;; setter and getter for all-purpose state variable.
  ;; Put all needed rendering state into a list and set it here.
  ((setState (news::gnu.lists.Pair))::void
   (set! mys news))
  ((getState)::gnu.lists.Pair
   mys)
)
