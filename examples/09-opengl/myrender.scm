;; load class pointers from global environment
(define glsvc ((gnu.mapping.Environment:getGlobal):get 'glsvc))
(define glrc ((gnu.mapping.Environment:getGlobal):get 'glrc))

;; walk the heirarchy and get our GLSurfaceView
(define glsv::glsvc
  (let* ((act::android.app.Activity *activity*)
         (vg::android.view.ViewGroup 
          (act:findViewById android.R$id:content))
         )
    (vg:getChildAt 0)))

;; get the current renderer object.
(define glr::glrc (glsv:getRenderer))

;; my renderer lambda
;; the arguments are: the GL context, width, height, state variable.
;; the state variable is an all-purpose scheme list.
;; Modify the state variable as needed to respond to events, 
;;    provide vertices, textures, etc.
(define myr
  (lambda (gl::javax.microedition.khronos.opengles.GL10
           width::int height::int state::gnu.lists.Pair)
    (let* ((ratio (/ width height))
           (triangleCoords (float[]  0.0  0.622008459 0.0
                                 -0.5 -0.311004243 0.0
                                 0.5 -0.311004243 0.0))
           (bb (java.nio.ByteBuffer:allocateDirect 
                (* 4 triangleCoords:length)))
           (vertexBuffer (begin 
                           (bb:order (java.nio.ByteOrder:nativeOrder))
                           (bb:asFloatBuffer)))
           (mAngle (car state))
           )
      ;; moved from onSurfaceViewChanged
      (gl:glViewport 0 0 width height)
      (gl:glMatrixMode gl:GL_PROJECTION)
      (gl:glLoadIdentity)
      (gl:glFrustumf (- 0 ratio) ratio -1 1 3 7)
      ;; initialize the thing
      (gl:glClearColor 0 0 0 1)
      (gl:glClear (bitwise-ior gl:GL_COLOR_BUFFER_BIT gl:GL_DEPTH_BUFFER_BIT))
      (gl:glMatrixMode gl:GL_MODELVIEW)
      (gl:glLoadIdentity)
      (android.opengl.GLU:gluLookAt gl 0 0 -3 0 0 0 0 1.0 0.0)
      ;; change this angle on touch event. 
      (gl:glRotatef mAngle 0.0 0.0 1.0)
      ;; initialize vertexBuffer
      (vertexBuffer:put triangleCoords) 
      (vertexBuffer:position 0)
      ;; draw the triangle
      (gl:glEnableClientState gl:GL_VERTEX_ARRAY)
      (gl:glColor4f 0.63671875 0.76953125 0.22265625 0.0)
      (gl:glVertexPointer 3 gl:GL_FLOAT 0 vertexBuffer)
      (gl:glDrawArrays gl:GL_TRIANGLES 0 
                       (/ triangleCoords:length 3))
      (gl:glDisableClientState gl:GL_VERTEX_ARRAY)
      )))

;; set the rendering lambda.
;; You can reload this file from the telnet REPL.
(glr:setonDrawFrame myr)
(glsv:requestRender)
