
(define GL20::java.lang.Class android.opengl.GLES20)

(define loadShader
  (lambda (type::int shaderCode::String)
    (let* ((shader (GL20:glCreateShader type)))
      (GL20:glShaderSource shader shaderCode)
      (GL20:glCompileShader shader)
      shader 
      )))

(define vertexShaderCode 
  (path-data (string-append (loaddir *activity*) "/vertexShader.glsl")))
(define fragmentShaderCode 
  (path-data (string-append (loaddir *activity*) "/fragmentShader.glsl")))

(define vertexShader 
  (loadShader GL20:GL_VERTEX_SHADER vertexShaderCode))
(define fragmentShader 
  (loadShader GL20:GL_FRAGMENT_SHADER fragmentShaderCode))
(define mProgram (GL20:glCreateProgram))
(GL20:glAttachShader mProgram vertexShader)
(GL20:glAttachShader mProgram fragmentShader)
(GL20:glLinkProgram mProgram)

(hash-table-set! (glr:getState) 'mProgram mProgram)
