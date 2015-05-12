
;; A thin wrapper. 
;; Keep a reference to the renderer and provide "getRenderer". 

(define-simple-class glsvclass
  (android.opengl.GLSurfaceView)
  ;; on touch event lambda slot
  (otel::gnu.mapping.MethodProc access: 'private)
  ;; if the on touch event slot contains something
  (oteb::boolean access: 'private init: #f)
  ;; keep a reference to Renderer.
  (mRenderer::android.opengl.GLSurfaceView$Renderer access: 'private)
  ;; android demands that we init the super.
  ((*init* (context::android.content.Context))
   (invoke-special android.opengl.GLSurfaceView (this) '*init* context)
   (setEGLContextClientVersion 2))
  ;; add a Renderer
  ((addRenderer (newr::android.opengl.GLSurfaceView$Renderer))::void
   (set! mRenderer newr)
   (setRenderer newr)
   (setRenderMode RENDERMODE_WHEN_DIRTY))
  ;; get the Renderer
  ((getRenderer)::android.opengl.GLSurfaceView$Renderer
   mRenderer)
  ;; use this to set a lambda to respond to touch events.
  ((setonTouchEvent (newl::gnu.mapping.MethodProc))::void
   (set! otel newl)
   (set! oteb #t))
  ((onTouchEvent (e::android.view.MotionEvent))::boolean
   (if oteb (otel e))
   #t)
  )
