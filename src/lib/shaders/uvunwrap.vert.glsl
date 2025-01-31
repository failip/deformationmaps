precision highp float;

varying vec3 vWorldPosition;

attribute vec2 uv1;

void main() {
  vWorldPosition = (modelMatrix * vec4(position, 1.0)).xyz;
  vec2 textureSpace = uv1 * 2.0 - 1.0;
  textureSpace.y = -textureSpace.y;
  gl_Position = vec4(textureSpace, 0.0, 1.0);
}