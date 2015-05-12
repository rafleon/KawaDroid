
;; init the colorBuffer
(define cB
    (let* ((colors (float[]
                         1 1 1
                         1 0 0
                         0 0 0
                         1 1 1
                         0 1 0
                         0 0 0
                         1 1 1
                         0 0 1
                         0 0 0
                         1 1 1
                         1 1 0
                         0 0 0
                             ))
           (bb (java.nio.ByteBuffer:allocateDirect 
                (* 4 colors:length)))
           (colorBuffer (begin 
                           (bb:order (java.nio.ByteOrder:nativeOrder))
                           (bb:asFloatBuffer)))
           )
      ;; initialize colorBuffer
      (colorBuffer:put colors) 
      (colorBuffer:position 0)
      bb))

;; set it
(hash-table-set! (glr:getState) 'colorBuffer cB)
