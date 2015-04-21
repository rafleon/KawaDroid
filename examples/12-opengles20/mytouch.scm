
(define logi
  (lambda (message)
    (android.util.Log:i "mytouch.scm" message)))

;; load class pointers from global environment
(define glsvc ((gnu.mapping.Environment:getGlobal):get 'glsvc))
(define glrc ((gnu.mapping.Environment:getGlobal):get 'glrc))

(define glsv::glsvc
  (let* ((act::android.app.Activity *activity*)
         (vg::android.view.ViewGroup 
          (act:findViewById android.R$id:content))
         )
    (vg:getChildAt 0)))

(define glr::glrc (glsv:getRenderer))

;; my touch event lambda
(define myt
  (let* ((TOUCH_SCALE_FACTOR (/ 60.0 320))
         (mPreviousX 0)
         (mPreviousY 0)
         (firstmove #f)
         (state (glr:getState))
         )
    (lambda (e::android.view.MotionEvent)
      ;;      (logi (e:toString))
      (let ((x (e:getX))
            (y (e:getY)))
        (if (equal? (e:getAction) e:ACTION_DOWN)
            (set! firstmove #t))
        (if (equal? (e:getAction) e:ACTION_MOVE)
            ;; on the first move event, record the finger position.
            ;; if you do it on e:ACTION_DOWN, it is glitchy.
            (if firstmove
                (begin
                  (set! mPreviousX x)
                  (set! mPreviousY y)
                  (set! firstmove #f))
                ;; otherwise move the triangle.
                (let ((dx (if (< y (/ (glsv:getHeight) 2))
                              (- x mPreviousX)
                              (- mPreviousX x)))
                      (dy (if (> x (/ (glsv:getWidth) 2))
                              (- y mPreviousY)
                              (- mPreviousY y)))
                      (mAngle (hash-table-ref/default state 'mAngle 0))
                      )
                  ;; update the all-purpose renderer state variable
                  (hash-table-set! state 'mAngle
                    (+ mAngle
                       (* TOUCH_SCALE_FACTOR (+ dx dy))))
                  (set! mPreviousX x)
                  (set! mPreviousY y)
                  (glsv:requestRender)
                  )))
        ))))

;; set the touch event lambda.
(glsv:setonTouchEvent myt)
