
(require 'srfi-69)

(define-simple-class glrclass
  (android.opengl.GLSurfaceView$Renderer)
  ;; the width and height
  (myw::int access: 'private)
  (myh::int access: 'private)
  ;; an all-purpose state variable
  (mys::kawa.lib.kawa.hashtable$HashTable 
   access: 'private
   init: (make-hash-table eq?))
  ;; our callback lambda slot for rendering.
  (odfl::gnu.mapping.MethodProc access: 'private)
  ;; whether the lambda slot contains something.
  (odfb::boolean access: 'private init: #f)
  ;; because queueEvent is flaky ... we have:
  ;; fifo event queue for putting lambdas to run on gl thread.
  (evq::java.util.concurrent.ConcurrentLinkedQueue
   access: 'private
   init: (java.util.concurrent.ConcurrentLinkedQueue))
  ;; method for running all the lambdas in the queue.
  ((procevents)::void access: 'private
   (if (not (evq:isEmpty))
       (begin
         ((evq:poll))
         (procevents))))
  ;; add a lambda to run on the gl thread.
  ;;    this is the same as queueEvent, except it actually works.
  ((queue-lambda (l::gnu.mapping.MethodProc))::void
   (evq:add l))
  ;; this does nothing. android demands that it exist.
  ((onSurfaceCreated (gl::javax.microedition.khronos.opengles.GL10)
                      (config::javax.microedition.khronos.egl.EGLConfig))::void
                      #t)
  ;; set a lambda to do the rendering.
  ;; the lambda takes width, height, all-purpose state variable.
  ((setonDrawFrame (newl::gnu.mapping.MethodProc))::void
   (set! odfl newl)
   (set! odfb #t))
  ;; this is where everything actually happens.
  ((onDrawFrame (gl::javax.microedition.khronos.opengles.GL10))::void
   ;; process our lambdas.
   (procevents)
   ;; render.
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
