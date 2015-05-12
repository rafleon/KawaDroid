
(define vB
  (let* ((triangleCoords 
          (float[]
                0 0 1
                -0.3 0.3 0
                0.3 0.3 0
                0 0 1
                0.3 0.3 0
                0.3 -0.3 0
                0 0 1
                0.3 -0.3 0
                -0.3 -0.3 0
                0 0 1
                -0.3 -0.3 0
                -0.3 0.3 0
                ))
         (bb (java.nio.ByteBuffer:allocateDirect 
              (* 4 triangleCoords:length)))
         (vertexBuffer (begin 
                         (bb:order (java.nio.ByteOrder:nativeOrder))
                         (bb:asFloatBuffer)))
         )
      (vertexBuffer:put triangleCoords) 
      ;; return the ByteBuffer, for compatibility with LWJGL3.
      bb))

;; *** end vertexBuffer ***

;; set it
(hash-table-set! (glr:getState) 'vertexBuffer vB)
