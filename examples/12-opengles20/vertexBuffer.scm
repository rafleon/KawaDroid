
;; for hashtables
(require 'srfi-69)

(define vB
  (let* ((triangleCoords 
          (float[] 
                0.0 0.622008459 0.0
                -0.5 -0.311004243 0.0
                0.5 -0.311004243 0.0))
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

;; Now put it into the renderer state hashtable:

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

;; set it
(hash-table-set! (glr:getState) 'vertexBuffer vB)
