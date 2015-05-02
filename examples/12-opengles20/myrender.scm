
;; my renderer lambda
;; The arguments are: width, height, state
;; The state variable is a srfi-69 hash table.
;; Modify the state variable to respond to events, 
;;    save vertices, fragments, shaders, textures, etc.

;; *Almost* compatible with LWJGL version 3 for cross-platform use.
;; http://javadoc.lwjgl.org/
;; Both GL11 and GL20 aliases are used to match LWJGL.

;; TODO: Matrix operations are unique to Android and need to be cleaned out.

(define myr
  (let ((mProjectionMatrix (float[] length: 16))
        (mViewMatrix (float[] length: 16))
        (mMVPMatrix (float[] length: 16))
        (mRotationMatrix (float[] length: 16))
        (mvpMatrix (float[] length: 16)))
    (lambda (width::int height::int state::kawa.lib.kawa.hashtable$HashTable)
      (let* ((GL11 android.opengl.GLES11)
             (GL20 android.opengl.GLES20)
             (Matrix android.opengl.Matrix)
             (ratio (/ width height))
             (mAngle (hash-table-ref/default state 'mAngle 0))
             (mProgram
              (let ((temp (hash-table-ref/default state 'mProgram 0)))
                ;; initialize the Shader, if needed.
                (if (= 0 temp)
                    (begin 
                      (load (string-append (loaddir *activity*) "/Shader.scm"))
                      (hash-table-ref/default state 'mProgram 0))
                    temp)))
             (mPositionHandle 
              (GL20:glGetAttribLocation mProgram "vPosition"))
             (coords-per-vertex 3)
             (vertexCount 3)
             (vertexStride (* 4 coords-per-vertex))
             (vertexBuffer::java.nio.ByteBuffer 
              (hash-table-ref/default state 'vertexBuffer #f))
             (mColorHandle
              (GL20:glGetUniformLocation mProgram "vColor"))
             (mMVPMatrixHandle 
              (GL20:glGetUniformLocation mProgram "uMVPMatrix"))
             )
        ;; moved from onSurfaceViewChanged
        (GL11:glViewport 0 0 width height)
        ;; set the background color
        (GL11:glClearColor 0 0 0 1)
        (GL11:glClear (bitwise-ior GL11:GL_COLOR_BUFFER_BIT 
                                   GL11:GL_DEPTH_BUFFER_BIT))
        ;; Add program to OpenGL environment
        (GL20:glUseProgram mProgram)
        ;; Enable a handle to the triangle vertices
        (GL20:glEnableVertexAttribArray mPositionHandle)
        ;; Prepare the triangle coordinate data
        (GL20:glVertexAttribPointer
         mPositionHandle 
         coords-per-vertex
         GL11:GL_FLOAT
         #f
         vertexStride 
         vertexBuffer)
        ;; Set color for drawing the triangle
        (GL20:glUniform4f mColorHandle 0.63671875 0.76953125 0.22265625 0.0)
        ;;  Apply the projection and view transformation
        (Matrix:frustumM mProjectionMatrix 0 (- 0 ratio) ratio -1 1 3 7)
        (Matrix:setLookAtM mViewMatrix 0 0 0 -3 0 0 0 0 1.0 0.0)
        (Matrix:multiplyMM mMVPMatrix 0 mProjectionMatrix 0 mViewMatrix 0)
        (Matrix:setRotateM mRotationMatrix 0 mAngle 0 0 1.0)
        (Matrix:multiplyMM mvpMatrix 0 mMVPMatrix 0 mRotationMatrix 0)
        (GL20:glUniformMatrix4fv mMVPMatrixHandle 1 #f mvpMatrix 0)
        ;;Draw the triangle
        (GL11:glDrawArrays GL11:GL_TRIANGLES 0 vertexCount)
        ;;Disable vertex array
        (GL20:glDisableVertexAttribArray mPositionHandle)
        ))))

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

;; set the rendering lambda.
;; You can reload this file from the telnet REPL.
(glr:setonDrawFrame myr)
