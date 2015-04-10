
(require 'android-defs)
(define-alias gl10 javax.microedition.khronos.opengles.GL10)
(define-alias float-buffer java.nio.FloatBuffer)
(define-alias byte-buffer java.nio.ByteBuffer)
(define-alias byte-order java.nio.ByteOrder)

(define-simple-class Cube ()
  (vertexBuffer :: float-buffer)
  (colorBuffer :: float-buffer)
  (indexBuffer :: byte-buffer)
  ((*init*)
   (let* ((vertices (float[] -1.0 -1.0 -1.0
                         1.0 -1.0 -1.0
                         1.0  1.0 -1.0
                         -1.0 1.0 -1.0
                         -1.0 -1.0  1.0
                         1.0 -1.0  1.0
                         1.0  1.0  1.0
                         -1.0  1.0  1.0))
          (colors (float[] 0.0  1.0  0.0  1.0
                       0.0  1.0  0.0  1.0
                       1.0  0.5  0.0  1.0
                       1.0  0.5  0.0  1.0
                       1.0  0.0  0.0  1.0
                       1.0  0.0  0.0  1.0
                       0.0  0.0  1.0  1.0
                       1.0  0.0  1.0  1.0))
         (indices (byte[] 0 4 5    0 5 1
                        1 5 6    1 6 2
                        2 6 7    2 7 3
                        3 7 4    3 4 0
                        4 7 6    4 6 5
                        3 0 1    3 1 2))
         (byteBuf :: byte-buffer (byte-buffer:allocateDirect (* vertices:length 4))))
     (byteBuf:order (byte-order:nativeOrder))
     (set! vertexBuffer (byteBuf:asFloatBuffer))
     (vertexBuffer:put vertices)
     (vertexBuffer:position 0)

     (set! byteBuf (byte-buffer:allocateDirect (* colors:length 4)))
     (byteBuf:order (byte-order:nativeOrder))
     (set! colorBuffer (byteBuf:asFloatBuffer))
     (colorBuffer:put colors)
     (colorBuffer:position 0)

     (set! indexBuffer (byte-buffer:allocateDirect indices:length))
     (indexBuffer:put indices)
     (indexBuffer:position 0)))
  ((draw (gl :: gl10)) :: void
   (gl:glFrontFace gl10:GL_CW)
   (gl:glVertexPointer 3 gl10:GL_FLOAT 0 vertexBuffer)
   (gl:glColorPointer 4 gl10:GL_FLOAT 0 colorBuffer)
   (gl:glEnableClientState gl10:GL_VERTEX_ARRAY)
   (gl:glEnableClientState gl10:GL_COLOR_ARRAY)
   (gl:glDrawElements gl10:GL_TRIANGLES 36 gl10:GL_UNSIGNED_BYTE indexBuffer)
   (gl:glDisableClientState gl10:GL_VERTEX_ARRAY)
   (gl:glDisableClientState gl10:GL_COLOR_ARRAY)))
