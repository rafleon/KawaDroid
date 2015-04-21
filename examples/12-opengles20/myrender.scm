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
  (lambda (width::int height::int state::kawa.lib.kawa.hashtable$HashTable)
    (let* ((GLES20 android.opengl.GLES20)
           (Matrix android.opengl.Matrix)
           (ratio (/ width height))
           (mProjectionMatrix
            (let ((temp (float[] length: 16)))
              (Matrix:frustumM temp 0 (- 0 ratio) ratio -1 1 3 7)
              temp))
           (mViewMatrix
            (let ((temp (float[] length: 16)))
              (Matrix:setLookAtM temp 0 0 0 -3 0 0 0 0 1.0 0.0)
              temp))
           (mMVPMatrix
            (let ((temp (float[] length: 16)))
              (Matrix:multiplyMM temp 0 mProjectionMatrix 0 mViewMatrix 0)
              temp))
           (mAngle (hash-table-ref/default state 'mAngle 0))
           (mRotationMatrix
            (let ((temp (float[] length: 16)))
              (Matrix:setRotateM temp 0 mAngle 0 0 1.0)
              temp))
           (mvpMatrix
            (let ((temp (float[] length: 16)))
              (Matrix:multiplyMM temp 0 mMVPMatrix 0 mRotationMatrix 0)
              temp))
           (mProgram
            (let ((temp (hash-table-ref/default state 'mProgram 0)))
              ;; initialize the Shader, if needed.
              (if (= 0 temp)
                  (begin 
                    (load (string-append (loaddir *activity*) "/Shader.scm"))
                    (hash-table-ref/default state 'mProgram 0))
                  temp)))
           (mPositionHandle 
            (GLES20:glGetAttribLocation mProgram "vPosition"))
           (coords-per-vertex 3)
           (vertexCount 3)
           (vertexStride (* 4 coords-per-vertex))
           (color (float[] 0.63671875 0.76953125 0.22265625 0.0))
           (vertexBuffer::java.nio.Buffer 
            (hash-table-ref/default state 'vertexBuffer #f))
           (mColorHandle
            (GLES20:glGetUniformLocation mProgram "vColor"))
           (mMVPMatrixHandle 
            (GLES20:glGetUniformLocation mProgram "uMVPMatrix"))
           )
       ;; moved from onSurfaceViewChanged
      (GLES20:glViewport 0 0 width height)
      ;; set the background color
      (GLES20:glClearColor 0 0 0 1)
      (GLES20:glClear (bitwise-ior GLES20:GL_COLOR_BUFFER_BIT 
                                   GLES20:GL_DEPTH_BUFFER_BIT))
      ;; Add program to OpenGL environment
      (GLES20:glUseProgram mProgram)
      ;; Enable a handle to the triangle vertices
      (GLES20:glEnableVertexAttribArray mPositionHandle)
      ;; Prepare the triangle coordinate data
      (GLES20:glVertexAttribPointer
                mPositionHandle 
                coords-per-vertex
                GLES20:GL_FLOAT
                #f
                vertexStride 
                vertexBuffer)
      ;; Set color for drawing the triangle
      (GLES20:glUniform4fv mColorHandle 1 color 0)
      ;;  Apply the projection and view transformation
      (GLES20:glUniformMatrix4fv mMVPMatrixHandle 1 #f mvpMatrix 0)
      ;;Draw the triangle
      (GLES20:glDrawArrays GLES20:GL_TRIANGLES 0 vertexCount)
      ;;Disable vertex array
      (GLES20:glDisableVertexAttribArray mPositionHandle)
      )))

;; set the rendering lambda.
;; You can reload this file from the telnet REPL.
(glr:setonDrawFrame myr)
