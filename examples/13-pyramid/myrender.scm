
;; my renderer lambda
;; The arguments are: width, height, state
;; The state variable is a srfi-69 hash table.
;; Modify the state variable to respond to events, 
;;    save vertices, fragments, shaders, textures, etc.

;; *Almost* compatible with LWJGL version 3 for cross-platform use.
;; http://javadoc.lwjgl.org/
;; TODO: Clean up GL11/GL20 aliases.

(define myr
    (lambda (width::int height::int state::kawa.lib.kawa.hashtable$HashTable)
      ;; Both GL11 and GL20 aliases are used to match LWJGL.
      (let* ((GL11 android.opengl.GLES11)
             (GL20 android.opengl.GLES20)
             (ratio (/ width height))
             ;; rotation matrix. set by accel/magnet sensors.
             (mR (hash-table-ref/default 
                  state 'mR
                  ;; if rotation matrix isn't set, use identity matrix.
                  (let ((Matrix android.opengl.Matrix)
                        (idm (float[] length: 16)))
                    (Matrix:setIdentityM idm 0)
                    idm)))
             (mvpMatrix (mvpcalc ratio mR))
             (mProgram (hash-table-ref/default state 'mProgram 0))
             (coords-per-vertex 3)
             (coords-per-color 3)
             (vertex-per-triangle 3)
             (triangles 4)
             (vertexCount (* triangles vertex-per-triangle))
             (vertexStride (* 4 coords-per-vertex))
             (colorStride (* 4 coords-per-color))
             (vertexBuffer::java.nio.ByteBuffer 
              (hash-table-ref/default state 'vertexBuffer #f))
             (colorBuffer::java.nio.ByteBuffer
              (hash-table-ref/default state 'colorBuffer #f))
             (mPositionHandle 
              (GL20:glGetAttribLocation mProgram "aPosition"))
             (mColorHandle
              (GL20:glGetAttribLocation mProgram "aColor"))
             (mMVPMatrixHandle 
              (GL20:glGetUniformLocation mProgram "uMVPMatrix"))
             )
        ;; disable creepy see-thru surfaces.
        (GL11:glEnable GL11:GL_DEPTH_TEST)
        ;; moved from onSurfaceViewChanged
        (GL11:glViewport 0 0 width height)
        ;; set the background color
        (GL11:glClearColor 0 0 0 1)
        (GL11:glClearDepthf 1.0)
        (GL11:glClear (bitwise-ior GL11:GL_COLOR_BUFFER_BIT 
                                   GL11:GL_DEPTH_BUFFER_BIT))
        ;; Add program to OpenGL environment
        (GL20:glUseProgram mProgram)
        ;; Enable handles to the triangle vertices and colors.
        (GL20:glEnableVertexAttribArray mPositionHandle)
        (GL20:glEnableVertexAttribArray mColorHandle)
        ;; Prepare the triangle coordinate data
        (GL20:glVertexAttribPointer
         mPositionHandle 
         coords-per-vertex
         GL11:GL_FLOAT
         #f
         vertexStride 
         vertexBuffer)
        ;; Prepare the triangle color data
        (GL20:glVertexAttribPointer
         mColorHandle
         coords-per-color
         GL11:GL_FLOAT
         #f
         colorStride
         colorBuffer)
        ;;  Apply the projection and view transformation
        (GL20:glUniformMatrix4fv mMVPMatrixHandle 1 #f mvpMatrix 0)
        ;; Draw the triangles
        (GL11:glDrawArrays GL11:GL_TRIANGLES 0 vertexCount)
        ;; Disable vertex and color arrays.
        (GL20:glDisableVertexAttribArray mPositionHandle)
        (GL20:glDisableVertexAttribArray mColorHandle)
        )))

;; *** end renderer ***

;; Now load it:

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

;; this loads mvpcalc for the renderer lambda.
(glr:queue-lambda 
 (lambda ()
   (load (string-append (loaddir *activity*) "/mvpMatrix.scm"))
   ))

;; load and compile the shaders.
(glr:queue-lambda 
 (lambda ()
   (load (string-append (loaddir *activity*) "/Shader.scm"))
   ))

;; set the rendering lambda.
;; You can reload this file from the telnet REPL.
(glr:setonDrawFrame myr)
