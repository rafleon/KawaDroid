
(define GL20::java.lang.Class android.opengl.GLES20)

(define loadShader
  (lambda (type::int shaderCode::String)
    (let* ((shader (GL20:glCreateShader type)))
      (GL20:glShaderSource shader shaderCode)
      (GL20:glCompileShader shader)
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
  (loadShader GL20:GL_VERTEX_SHADER vertexShaderCode))
(define fragmentShader 
  (loadShader GL20:GL_FRAGMENT_SHADER fragmentShaderCode))
(define mProgram (GL20:glCreateProgram))
(GL20:glAttachShader mProgram vertexShader)
(GL20:glAttachShader mProgram fragmentShader)
(GL20:glLinkProgram mProgram)

(hash-table-set! (glr:getState) 'mProgram mProgram)
