
(define GLES20::android.opengl.GLES20
  (android.opengl.GLES20))

(define loadShader
  (lambda (type::int shaderCode::String)
    (let* ((shader (GLES20:glCreateShader type)))
      (GLES20:glShaderSource shader shaderCode)
      (GLES20:glCompileShader shader)
      shader 
      )))

(define vertexShaderCode 
  (string-append
            "uniform mat4 uMVPMatrix;" 
            "attribute vec4 vPosition;" 
            "void main() {" 
            "  gl_Position = uMVPMatrix * vPosition;" 
            "}"
            ))

(define fragmentShaderCode 
  (string-append
            "precision mediump float;"
            "uniform vec4 vColor;"
            "void main() {"
            "  gl_FragColor = vColor;"
            "}"
            ))

(define vertexShader 
  (loadShader GLES20:GL_VERTEX_SHADER vertexShaderCode))
(define fragmentShader 
  (loadShader GLES20:GL_FRAGMENT_SHADER fragmentShaderCode))
(define mProgram (GLES20:glCreateProgram))
(GLES20:glAttachShader mProgram vertexShader)
(GLES20:glAttachShader mProgram fragmentShader)
(GLES20:glLinkProgram mProgram)

(hash-table-set! (glr:getState) 'mProgram mProgram)
