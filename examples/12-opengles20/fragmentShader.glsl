#ifdef GL_ES
       precision mediump float;
#endif
uniform vec4 vColor;
void main() {
  gl_FragColor = vColor;
}