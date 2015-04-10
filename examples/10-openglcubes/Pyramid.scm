
(require 'android-defs)
(define-alias gl10 javax.microedition.khronos.opengles.GL10)
(define-alias float-buffer java.nio.FloatBuffer)
(define-alias byte-buffer java.nio.ByteBuffer)
(define-alias byte-order java.nio.ByteOrder)

(define-simple-class Pyramid ()
  (vertexBuffer :: float-buffer)
  (colorBuffer :: float-buffer)
  (num-vertices-third :: int)
  ((*init*)
   (let* ((vertices (float[]
                          0.0  1.0  0.0 ; top
                          -1.0 -1.0 1.0 ; left front
                          1.0 -1.0 1.0 ; right front
                          0.0  1.0 0.0
                          1.0 -1.0 1.0
                          1.0 -1.0 -1.0 ; right back
                          0.0  1.0 0.0
                          1.0 -1.0 -1.0
                          -1.0 -1.0 -1.0 ; left back
                          0.0  1.0 0.0
                          -1.0 -1.0 -1.0
                          -1.0 -1.0 1.0
                          -1.0 -1.0 1.0 ; bottom
                          1.0 -1.0 1.0
                          -1.0 -1.0 -1.0
                          -1.0 -1.0 -1.0
                          1.0 -1.0 1.0
                          1.0 -1.0 -1.0
                          ))
         (colors (float[] 1.0 0.0 0.0 1.0
                        0.0 1.0 0.0 1.0
                        0.0 0.0 1.0 1.0
                        1.0 0.0 0.0 1.0
                        0.0 0.0 1.0 1.0
                        0.0 1.0 0.0 1.0
                        1.0 0.0 0.0 1.0
                        0.0 1.0 0.0 1.0
                        0.0 0.0 1.0 1.0
                        1.0 0.0 0.0 1.0
                        0.0 0.0 1.0 1.0
                        0.0 1.0 0.0 1.0
                        ;; bottom
                        0.0 1.0 0.0 1.0
                        0.0 0.0 1.0 1.0
                        0.0 0.0 1.0 1.0
                        0.0 0.0 1.0 1.0
                        0.0 0.0 1.0 1.0
                        0.0 1.0 0.0 1.0
                        ))
         (byteBuf :: byte-buffer (byte-buffer:allocateDirect (* vertices:length 4))))
     (set! num-vertices-third (as int (/ vertices:length 3)))

     (byteBuf:order (byte-order:nativeOrder))
     (set! vertexBuffer (byteBuf:asFloatBuffer))
     (vertexBuffer:put vertices)
     (vertexBuffer:position 0)

     (set! byteBuf (byte-buffer:allocateDirect (* colors:length 4)))
     (byteBuf:order (byte-order:nativeOrder))
     (set! colorBuffer (byteBuf:asFloatBuffer))
     (colorBuffer:put colors)
     (colorBuffer:position 0)))
  ((draw (gl :: gl10)) :: void
   (gl:glFrontFace gl10:GL_CW)
   (gl:glVertexPointer 3 gl10:GL_FLOAT 0 vertexBuffer)
   (gl:glColorPointer 4 gl10:GL_FLOAT 0 colorBuffer)
   (gl:glEnableClientState gl10:GL_VERTEX_ARRAY)
   (gl:glEnableClientState gl10:GL_COLOR_ARRAY)
   (gl:glDrawArrays gl10:GL_TRIANGLES 0 num-vertices-third)
   (gl:glDisableClientState gl10:GL_VERTEX_ARRAY)
   (gl:glDisableClientState gl10:GL_COLOR_ARRAY)))
