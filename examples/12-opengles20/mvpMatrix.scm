(define mvpcalc
  (let ((Matrix android.opengl.Matrix)
        (mProjectionMatrix (float[] length: 16))
        (mViewMatrix (float[] length: 16))
        (mMVPMatrix (float[] length: 16))
        (mRotationMatrix (float[] length: 16))
        (mvpMatrix (float[] length: 16)))
    (lambda (ratio angle)
      (Matrix:frustumM mProjectionMatrix 0 (- 0 ratio) ratio -1 1 3 7)
      (Matrix:setLookAtM mViewMatrix 0 0 0 -3 0 0 0 0 1.0 0.0)
      (Matrix:multiplyMM mMVPMatrix 0 mProjectionMatrix 0 mViewMatrix 0)
      (Matrix:setRotateM mRotationMatrix 0 angle 0 0 1.0)
      (Matrix:multiplyMM mvpMatrix 0 mMVPMatrix 0 mRotationMatrix 0)
      mvpMatrix
      )))